#!/bin/bash
head -n 37 ./results/rnaseq_variants/results/sample_ids.txt | parallel --plain --jobs 3 --resume-failed --joblog ./results/rnaseq_variants/results/logs/06-run_GATK_SplitNTrim_log1.txt 'bash ./results/rnaseq_variants/scripts/08-GATK_SPLITNTRIM_REASSIGNMQ.sh ./results/rnaseq_variants/results/06-PICARD_ADDREPRG_SAMBAMBA_MARKDUP/{}/MARKED_DUPLICATES.bam ./results/rnaseq_variants/results/07-GATK/01-SPLIT_N_TRIM/{}/SPLIT_REASSIGN_MQ.bam'
