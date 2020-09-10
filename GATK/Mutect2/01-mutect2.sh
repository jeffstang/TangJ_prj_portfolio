#!/bin/bash
# CONSTANTS

FASTA="/projects/rmorin/reference/igenomes/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.fa"
BAM=$1
NAME=$2
OUTPUT=$3

gatk Mutect2 \
-R $FASTA \
-I $BAM \
-tumor $NAME \
--disable-read-filter MateOnSameContigOrNoMappedMateReadFilter \
-O $OUTPUT
