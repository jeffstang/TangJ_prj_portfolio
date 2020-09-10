#!/bin/bash

DENOISED_CR_TSV=$1
ALLELIC_COUNTS_TSV=$2
OUTPUT=$3
OUTPREFIX=$4

gatk --java-options "-Xmx30g" ModelSegments \
    --denoised-copy-ratios $DENOISED_CR_TSV \
    --allelic-counts $ALLELIC_COUNTS_TSV \
    --output $OUTPUT \
    --output-prefix $OUTPREFIX
