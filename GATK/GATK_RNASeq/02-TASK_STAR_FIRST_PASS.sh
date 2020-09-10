#!/bin/bash
# Command Line Arguments
fastq1=$1
fastq2=$2
OUTPUT_DIR=$3
NUM_THREADS=${4:-10}

# Usage (Record Keeping)
# ./path/to/02_STAR_FIRST_PASS.sh ./path/to/fastq1 ./path/to/fastq2 ./path/to/output/directory

# Set File Path Variables for STAR FIRST PASS
STAR=/projects/NCI_Burkitts/bin/centos-6/miniconda/bin/STAR
STAR_INDEX=/dev/shm/results/rnaseq_variants/results/01_STAR_INDEX/
GTF=/projects/NCI_Burkitts/results/rnaseq_variants/ref/gencode.v25.chr_patch_hapl_scaff.with_chrEBV.annotation.gtf

# Thread allocation can be changed in line 3
# refer to STAR index from previous step to detect splice junctions
# path to genome annotations
# direct STAR to sequences to be mapped read1 read2
# set number to be read_length-1, in this case 75-1=74
# set type of SAM/BAM output to null
# No SAM output
# decompress gzipped files specifically fastqs

# Commands
$STAR \
--runThreadN $NUM_THREADS \
--genomeDir $STAR_INDEX \
--sjdbGTFfile $GTF \
--readFilesIn $fastq1 $fastq2 \
--sjdbOverhang 74 \
--outSAMtype None \
--outSAMmode None \
--outFileNamePrefix $OUTPUT_DIR \
--readFilesCommand zcat

# Note: For single sample 2-pass mode, can use --twopassMode Basic; more efficient as it automates 2-pass approach, unfortunately not available for multiple samples yet
