#!/bin/bash
# CONSTANTS
fastq1=$1
fastq2=$2
OUTPUT_DIR=$3
NUM_THREADS=${4:-10}

# Paths for directory/software dependencies 
STAR=/projects/NCI_Burkitts/bin/centos-6/miniconda/bin/STAR
STAR_INDEX=/projects/nhl_meta_analysis_scratch/projects/NCI_Burkitts/results/rnaseq_variants/results/04_INDEX_WITH_SJ

$STAR \
--runThreadN $NUM_THREADS \
--genomeDir $STAR_INDEX \
--readFilesIn $fastq1 $fastq2 \
--outFileNamePrefix $OUTPUT_DIR \
--sjdbOverhang 74 \
--outSAMtype BAM SortedByCoordinate \
--readFilesCommand zcat
