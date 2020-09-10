#!/bin/bash

REF_DICT="/projects/rmorin/reference/igenomes/Homo_sapiens/GSC/GRCh38/Sequence/WholeGenomeFasta/GRCh38_no_alt.dict"

DENOISED_CR_TSV=$1
SEGS=$2
OUTPUT=$3
OUTPREFIX=$4

gatk PlotModeledSegments \
	--denoised-copy-ratios $DENOISED_CR_TSV \
	--segments $SEGS \
	--sequence-dictionary $REF_DICT \
	--minimum-contig-length 46709983 \
	--output $OUTPUT \
	--output-prefix $OUTPREFIX

