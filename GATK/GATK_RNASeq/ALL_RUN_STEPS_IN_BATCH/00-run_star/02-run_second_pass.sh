#!/bin/bash

cat ./results/rnaseq_variants/results/sample_ids.txt | parallel --plain --jobs 3 --resume-failed --joblog ./results/rnaseq_variants/results/logs/RUN_STAR_second_pass_log.txt 'bash ./results/rnaseq_variants/scripts/05-TASK_STAR_SECOND_PASS.sh /projects/NCI_Burkitts/data/mrna_fastqs/{}_R1.fastq.gz /projects/NCI_Burkitts/data/mrna_fastqs/{}_R2.fastq.gz ./results/rnaseq_variants/results/05_STAR_SECOND_PASS/{}/ 10' 
