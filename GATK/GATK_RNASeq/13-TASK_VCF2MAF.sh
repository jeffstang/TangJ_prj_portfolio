#!/bin/bash
# CONSTANTS
INPUT_VCF=$1
OUTPUT_MAF=$2
TUMOUR_SAMPLE_ID=$3

# PATHS
VCF2MAF="/projects/NCI_Burkitts/bin/centos-6/miniconda/bin/vcf2maf.pl"
REF_FASTA="/projects/NCI_Burkitts/ref/GRCh38/Sequence/WholeGenomeFasta/genome.fa"
VEP_PATH="/projects/NCI_Burkitts/bin/centos-6/miniconda/share/variant-effect-predictor-86-0"
VEP_DATA="/dev/shm/ensembl_vep_cache"

# VCF2MAF -- annotate variants to one possible effect
# To look for nonsynonymous mutations
"$VCF2MAF" \
--input-vcf "$INPUT_VCF" \
--output-maf "$OUTPUT_MAF" \
--tumor-id "$TUMOUR_SAMPLE_ID" \
--normal-id NO_NORMAL \
--ref-fast "$REF_FASTA" \
--vep-path "$VEP_PATH" \
--vep-data "$VEP_DATA" \
--vcf-tumor-id BLGSP \
--vep-forks 20 \
--species homo_sapiens \
--ncbi-build GRCh38

