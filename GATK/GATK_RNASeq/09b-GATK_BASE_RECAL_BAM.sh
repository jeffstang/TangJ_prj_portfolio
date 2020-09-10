#!/bin/bash
INPUT_BAM=$1
RECAL_TABLE=$2
RECAL_BAM=$3

# Set Directory Path
GATK=/projects/NCI_Burkitts/bin/centos-6/miniconda/bin/GenomeAnalysisTK
FASTA=/projects/NCI_Burkitts/results/rnaseq_variants/ref/GRCh38.p7.gencode.v25.chr_patch_hapl_scaff.with_chrEBV.genome.fa

# Create recalibrated BAM
$GATK -Xmx5G \
-T PrintReads \
-R $FASTA \
-I $INPUT_BAM \
-BQSR $RECAL_TABLE \
-o $RECAL_BAM
