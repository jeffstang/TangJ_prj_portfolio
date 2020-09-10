#!/bin/bash

# CONSTANTS
INPUT_VCF=$1
FILTERED_VCF=$2

# DEPENDENCIES 
GATK=/projects/NCI_Burkitts/bin/centos-6/miniconda/bin/GenomeAnalysisTK
FASTA=/projects/NCI_Burkitts/results/rnaseq_variants/ref/GRCh38.p7.gencode.v25.chr_patch_hapl_scaff.with_chrEBV.genome.fa

# Variant Filtering
# Recommended RNA-seq-specific parameters: -window 35 -cluster 3 -- Filter clusters of at least 3 SNPs within 35 base window
# Recommended DNA-seq-specific parameters: Fisher strand values (FS>30) and Qual by Depth values (QD < 5.0), Read Depth (DP > 5)

$GATK \
-T VariantFiltration \
-R $FASTA \
-V $INPUT_VCF \
-window 35 \
-cluster 3 \
-filterName FS -filter "FS > 30.0" \
-filter "QD < 5.0" -filterName QD \
-filter "DP < 5.0" -filterName DP \
-o $FILTERED_VCF
