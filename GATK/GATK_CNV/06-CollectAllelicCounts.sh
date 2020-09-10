#!/bin/bash

INTERVALS_LIST="/home/jtang/DLBCL_LY17/data/GATK_CNV/01-PreprocessIntervalList/preprocessed_IDT_xgen_exome_panel_v1.0_GRCh38_no_alt.interval_list"
REF="/projects/rmorin/reference/igenomes/Homo_sapiens/GSC/GRCh38/Sequence/WholeGenomeFasta/GRCh38_no_alt.fa"

TUMOUR_BAM=$1
OUTPUT=$2

gatk --java-options "-Xmx30g" CollectAllelicCounts \
    -L $INTERVALS_LIST \
    -I $TUMOUR_BAM \
    -R $REF \
    -O $OUTPUT
