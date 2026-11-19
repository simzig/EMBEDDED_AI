# Partie FPGA : AIfES sur Zynq (ZedBoard)

1. Faire tourner l'inference AIfES (MNIST, MLP f32) sur l'ARM Cortex-A9 du Zynq, en bare-metal (Vitis).
2. Mesurer le temps d'inference logiciel (reference).
3. Proposer et integrer une IP materielle accelerant le calcul d'AIfES.

- hw/ : description materielle exportee de Vivado (block design Tcl + .xsa)
- vitis/ : workspace Vitis (plateforme + application aifes_app)

Carte : ZedBoard (Zynq xc7z020, Cortex-A9 a 666 MHz, 512 Mo de DDR). Console serie sur UART1 (MIO 48-49), 115200 bauds.

Reference logicielle (f32, -O2) : 31.2 ms par inference sur le Cortex-A9.

## Analyse du code AIfES

### Où se fait le calcul
En suivant les appels depuis notre main :
- aifes_f32_fnn_inference() (header généré par AIfES-Converter)
- aialgo_inference_model() puis aialgo_forward_model(), qui boucle sur les couches (basic/base/aialgo/aialgo_sequential_inference.c)
- ailayer_dense_forward(), qui appelle layer->linear() (basic/base/ailayer/ailayer_dense.c)
- aimath_f32_default_linear(), qui fait le produit matrice x vecteur + biais avec trois boucles imbriquées (basic/default/aimath/aimath_f32_default.c)

layer->linear est un pointeur de fonction, affecté dans basic/default/ailayer/ailayer_dense_default.c.
On peut donc le faire pointer vers notre propre fonction (qui pilotera l'IP) sans modifier la bibliothèque.
AIfES fait déjà ça pour sa version optimisée ARM (dossier basic/cmsis).

### Nombre d'opérations
Modèle : MLP 784-512-256-128-64-10 en float32.
- Dense 1 : 784 x 512 = 401 408 multiplications-additions (70 %)
- Dense 2 : 512 x 256 = 131 072 (23 %)
- Dense 3 : 256 x 128 = 32 768 (6 %)
- Dense 4 et 5 : 8 832 (1,5 %)
- ReLU et softmax : environ 1 000 opérations, négligeable

Au total 574 080 multiplications-additions, donc quasiment tout le temps est dans aimath_f32_default_linear().

### Temps mesuré
31,3 ms par inférence sur le Cortex-A9 (moyenne sur 100 inférences, -O2), soit environ 36 cycles par multiplication-addition.
C'est beaucoup pour une seule opération. Notre hypothèse (à vérifier) : le processeur attend surtout la mémoire.
Les 2,3 Mo de poids ne tiennent pas dans le cache, et la boucle les lit avec des sauts de 2 Ko pour la couche 1.

### Ce qu'on peut accélérer
- Un multiplicateur seul en matériel remplace juste l'opérateur * de la boucle. Il sera plus lent que le processeur, car chaque échange sur le bus AXI coûte plus cher que la multiplication. On le fait quand même pour valider toute la chaîne (module, testbench, IP, intégration, logiciel).
- Ensuite il faut déporter plus de calcul d'un coup : un neurone entier (produit scalaire), puis une couche entière, avec les poids envoyés en continu et plusieurs multiplieurs en parallèle.
- Passer en Q7 (entiers 8 bits) diviserait la taille des poids par 4, ce qui réduit le problème d'accès mémoire.