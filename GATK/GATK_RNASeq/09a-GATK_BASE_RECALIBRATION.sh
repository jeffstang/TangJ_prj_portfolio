#!/bin/bash
# Constants
IN_BAM=$1
RECAL_TABLE=$2

# Set Directory Path
GATK=/projects/NCI_Burkitts/bin/centos-6/miniconda/bin/GenomeAnalysisTK
FASTA=/projects/NCI_Burkitts/results/rnaseq_variants/ref/GRCh38.p7.gencode.v25.chr_patch_hapl_scaff.with_chrEBV.genome.fa
VCF=/projects/NCI_Burkitts/ref/GRCh38/Annotation/Variation/dbsnp.gatk.common_all_20170403.vcf.gz

# Detect systematic errors in base quality scores using BaseRecalibrator
$GATK -Xmx5G \
-T BaseRecalibrator \
-R $FASTA \
-I $IN_BAM \
-knownSites $VCF \
-o $RECAL_TABLE
