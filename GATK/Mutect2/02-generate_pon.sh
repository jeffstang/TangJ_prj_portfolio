#!/bin/bash

# CONSTANTS
LIST=$1
OUTPUT=$2

gatk CreateSomaticPanelOfNormals \
   -vcfs $LIST \
   -O $OUTPUT
