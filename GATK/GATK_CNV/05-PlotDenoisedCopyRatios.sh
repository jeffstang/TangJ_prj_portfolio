#!/bin/bash
REF_DICT="/projects/rmorin/reference/igenomes/Homo_sapiens/GSC/GRCh38/Sequence/WholeGenomeFasta/GRCh38_no_alt.dict"

# --min-contig-length flag can be changed but GATK recommends to exclude sex chromosomes
# In this case, smallest chromosome would be chr21 (46709983 bp)

STANDARDIZED_CR_TSV=$1
DENOISED_CR_TSV=$2
OUTDIR=$3
OUTPREF=$4

gatk PlotDenoisedCopyRatios \
	--standardized-copy-ratios $STANDARDIZED_CR_TSV \
	--denoised-copy-ratios $DENOISED_CR_TSV \
	--sequence-dictionary $REF_DICT \
	--minimum-contig-length 46709983 \
	--output $OUTDIR \
	--output-prefix $OUTPREF
