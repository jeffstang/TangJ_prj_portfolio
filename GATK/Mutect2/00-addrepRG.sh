#!/bin/bash

# PICARD Add Or Replace Read Groups
# CONSTANTS
INPUT_BAM=$1
OUTPUT_BAM=$2
SAMPLE_NAME=$3

picard AddOrReplaceReadGroups I=$INPUT_BAM O=$OUTPUT_BAM \
RGID=4 \
RGLB=lib1 \
RGPL=illumina \
RGPU=unit1 \
RGSM=$SAMPLE_NAME


