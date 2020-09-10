#!/bin/bash
# Constants
INPUT_BAM=$1
SORTED_OUTPUT_BAM=$2

# Set File/Directory Paths
PICARD=/projects/NCI_Burkitts/bin/centos-6/miniconda/bin/picard

# Add/Replace Read Groups sort
# I = input BAM or SAM
# O = output BAM or SAM
# SO - Optional sort method, if not specified, output will be in same order as input
# RGID Default value 1, can be set to null to clear default
# RGLB read group library
# RGPL read group platform
# RGPU read group platform unit
# RGSM read group sample name

$PICARD AddOrReplaceReadGroups I=$INPUT_BAM O=$SORTED_OUTPUT_BAM SORT_ORDER=coordinate RGID=4 RGLB=lib1 \
RGPL=illumina RGPU=unit1 RGSM=BLGSP
