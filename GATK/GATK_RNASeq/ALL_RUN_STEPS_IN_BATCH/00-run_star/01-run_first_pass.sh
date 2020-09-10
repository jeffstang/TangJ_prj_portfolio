#!/bin/bash

cat ./results/rnaseq_variants/results/sample_ids.txt | parallel --plain --jobs 9 --joblog ./results/rnaseq_variants/results/logs/RUN_STAR_first_pass_log.txt 'bash ./results/rnaseq_variants/scripts/02_STAR_FIRST_PASS.sh ./data/mrna_fastqs/{}_R1.fastq.gz ./data/mrna_fastqs/{}_R2.fastq.gz ./results/rnaseq_variants/results/02_STAR_FIRST_PASS/{}/ 10'
