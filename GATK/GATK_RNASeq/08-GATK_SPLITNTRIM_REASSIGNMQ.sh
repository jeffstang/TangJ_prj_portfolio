#!/bin/bash
# CONSTANTS
INPUT_BAM=$1
OUTPUT_BAM=$2

# Set File/Directory Paths
GATK=/projects/NCI_Burkitts/bin/centos-6/miniconda/bin/GenomeAnalysisTK
FASTA=/projects/NCI_Burkitts/results/rnaseq_variants/ref/GRCh38.p7.gencode.v25.chr_patch_hapl_scaff.with_chrEBV.genome.fa

# Run GATK SplitNCigar, reassign mapping quality
# IMPORTANT NOTE:STAR assigns good alignments as MAPQ=255, incompatible with GATK as it means "unknown"
# ReassignOneMappingQuality reassigns from 255 to 60, not ideal and may be subject to change!

$GATK -Xmx5G -T SplitNCigarReads -R $FASTA -I $INPUT_BAM -o $OUTPUT_BAM -rf ReassignOneMappingQuality -RMQF 255 -RMQT 60 -U ALLOW_N_CIGAR_READS
