#!/bin/bash

# VARIABLES
FASTA="/projects/rmorin/reference/igenomes/Homo_sapiens/GSC/GRCh38/Sequence/WholeGenomeFasta/GRCh38_no_alt.fa"
INTERVALS_LIST="/home/jtang/DLBCL_LY17/data/GATK_CNV/preprocessed_IDT_xgen_exome_panel_v1.0_GRCh38_no_alt.interval_list"

# CONSTANTS
ANNOTATED_INTERVALS_TSV=$1

gatk AnnotateIntervals \
 -R $FASTA \
 -L $INTERVALS_LIST \
--interval-merging-rule OVERLAPPING_ONLY \
-O $ANNOTATED_INTERVALS_TSV
