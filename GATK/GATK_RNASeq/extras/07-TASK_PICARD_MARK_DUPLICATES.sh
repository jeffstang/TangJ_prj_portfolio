#!/bin/bash
#Constants
SORTED_BAM=$1
MARK_DUPE_BAM=$2
OUTPUT_METRICS=$3

#PATH TO SOFTWARE DEPENDENCY
PICARD=/projects/NCI_Burkitts/bin/centos-6/miniconda/bin/picard

# Run Mark Duplicates using parameters provided in example from GATK documentation
# CREATE_INDEX creates BAM index for coordinate-sorted BAM file
# VALIDATION_STRINGENCY improves performance when processing BAM file (variable length data 
# such as read, qualities, tags, do not need to be decoded)

$PICARD MarkDuplicates I=$SORTED_BAM O=$MARK_DUPE_BAM CREATE_INDEX=true \
VALIDATION_STRINGENCY=SILENT M=$OUTPUT_METRICS && rm $SORTED_BAM
