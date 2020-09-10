#!/bin/bash

# CONSTANTS
INTERVALS_LIST="/home/jtang/DLBCL_LY17/data/GATK_CNV/01-PreprocessIntervalList/preprocessed_IDT_xgen_exome_panel_v1.0_GRCh38_no_alt.interval_list"

# VARIABLES
SAMPLE_BAM=$1
COUNTS_FILE_HDF5=$2

# Use CollectReadCounts for latest implementation; replaces CollectFragmentCounts
gatk CollectReadCounts \
-I $SAMPLE_BAM \
-L $INTERVALS_LIST \
--interval-merging-rule OVERLAPPING_ONLY \
-O $COUNTS_FILE_HDF5

