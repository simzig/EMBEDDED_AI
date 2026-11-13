#include <stdio.h>
#include "xil_printf.h"
#include "xiltimer.h"

/* AIfES n'active ses fonctions d'affichage (aiprint...) que sous Arduino.
   Le header généré les appelle quand même : on les fournit ici, AVANT l'include. */
static int aiprint(const char *s) { printf("%s\r\n", s); return 0; }
static int aiprint_uint(const char *fmt, unsigned int v) { printf(fmt, v); printf("\r\n"); return 0; }

#include "aifes_f32_fnn.h"   /* modèle généré par AIfES-Converter : définit INPUTS (784) et OUTPUTS (10) */

static float input_data[INPUTS];    /* image 28x28 aplatie */
static float output_data[OUTPUTS];  /* probabilité de chaque chiffre 0..9 */

int main(void)
{
    XTime t_debut, t_fin;

    printf("\r\n=== AIfES sur Zynq (Cortex-A9) ===\r\n");

    if (aifes_f32_fnn_create_model() != 0) {
        printf("Erreur : creation du modele impossible (memoire)\r\n");
        return 1;
    }

    /* Premier test : image entièrement noire (tout à 0) */
    for (int i = 0; i < INPUTS; i++) {
        input_data[i] = 0.0f;
    }

        /* Moyenne sur N_RUNS inférences pour une mesure fiable */
    const int N_RUNS = 100;
    XTime_GetTime(&t_debut);
    for (int r = 0; r < N_RUNS; r++) {
        aifes_f32_fnn_inference(input_data, output_data);
    }
    XTime_GetTime(&t_fin);

    for (int i = 0; i < OUTPUTS; i++) {
        printf("classe %d : %f\r\n", i, output_data[i]);
    }

    /* Le timer global du Cortex-A9 compte COUNTS_PER_SECOND ticks par seconde */
        printf("Temps moyen d'inference (%d runs) : %.3f ms\r\n", N_RUNS,
           1000.0 * (double)(t_fin - t_debut) / (COUNTS_PER_SECOND) / N_RUNS);
    return 0;
}