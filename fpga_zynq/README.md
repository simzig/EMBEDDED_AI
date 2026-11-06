# Partie FPGA : AIfES sur Zynq (PYNQ-Z2)

1. Faire tourner l'inference AIfES (MNIST, MLP f32) sur l'ARM Cortex-A9 du Zynq, en bare-metal (Vitis).
2. Mesurer le temps d'inference logiciel (reference).
3. Proposer et integrer une IP materielle accelerant le calcul d'AIfES.

- hw/ : description materielle exportee de Vivado (block design Tcl + .xsa)
- vitis/ : workspace Vitis (plateforme + application aifes_app)
