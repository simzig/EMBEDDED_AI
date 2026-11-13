# Partie FPGA : AIfES sur Zynq (ZedBoard)

1. Faire tourner l'inference AIfES (MNIST, MLP f32) sur l'ARM Cortex-A9 du Zynq, en bare-metal (Vitis).
2. Mesurer le temps d'inference logiciel (reference).
3. Proposer et integrer une IP materielle accelerant le calcul d'AIfES.

- hw/ : description materielle exportee de Vivado (block design Tcl + .xsa)
- vitis/ : workspace Vitis (plateforme + application aifes_app)

Carte : ZedBoard (Zynq xc7z020, Cortex-A9 a 666 MHz, 512 Mo de DDR). Console serie sur UART1 (MIO 48-49), 115200 bauds.

Reference logicielle (f32, -O2) : 31.2 ms par inference sur le Cortex-A9.
