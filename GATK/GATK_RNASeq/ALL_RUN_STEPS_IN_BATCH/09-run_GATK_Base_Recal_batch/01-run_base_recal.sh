#!/bin/bash

cat ./results/rnaseq_variants/results/sample_ids.txt | parallel --plain --jobs 5 --resume-failed --joblog ./results/rnaseq_variants/results/00-run_logs/07-run_GATK_Base_Recal.log 'bash ./results/rnaseq_variants/scripts/09a-GATK_BASE_RECALIBRATION.sh ./results/rnaseq_variants/results/07-GATK/01-SPLIT_N_TRIM/{}/SPLIT_REASSIGN_MQ.bam ./results/rnaseq_variants/results/07-GATK/02-BASE_RECALIBRATION/{}/Recalibration_report.grp'

