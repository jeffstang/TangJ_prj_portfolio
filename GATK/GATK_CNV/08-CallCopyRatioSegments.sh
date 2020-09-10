#!/bin/bash

CR_SEG=$1
OUTPUT=$2

gatk CallCopyRatioSegments \
	--input $CR_SEG \
	--output $OUTPUT
