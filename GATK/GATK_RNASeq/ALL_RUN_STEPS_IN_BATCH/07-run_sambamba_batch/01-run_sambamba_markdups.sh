#!/bin/bash
cat ./results/rnaseq_variants/results/sample_ids.txt | parallel --plain --jobs 12 --resume-failed --joblog ./results/rnaseq_variants/results/logs/04-SAMBAMBA_markdup_log.txt 'bash ./results/rnaseq_variants/scripts/07-TASK_SAMBAMBA_MARKDUPS.sh ./results/rnaseq_variants/results/06-PICARD_ADDREPRG_SAMBAMBA_MARKDUP/{}/SORTED_READ_GROUPS.bam ./results/rnaseq_variants/results/06-PICARD_ADDREPRG_SAMBAMBA_MARKDUP/{}/MARKED_DUPLICATES.bam 12'
