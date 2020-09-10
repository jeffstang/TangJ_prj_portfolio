#!/bin/bash

# CONSTANTS
TARGETS_INTERVAL_LIST="/home/jtang/DLBCL_LY17/data/GATK_CNV/01-PreprocessIntervalList/IDT_xgen_exome_panel_v1.0_GRCh38_no_alt.interval_list"
REF="/projects/rmorin/reference/igenomes/Homo_sapiens/GSC/GRCh38/Sequence/WholeGenomeFasta/GRCh38_no_alt.fa"

# VARIABLES
OUTPUT=$1

gatk PreprocessIntervals \
	-L $TARGETS_INTERVAL_LIST \
	-R $REF \
	--bin-length 0 \
	--interval-merging-rule OVERLAPPING_ONLY \
	--padding 150 \
	-O $OUTPUT
