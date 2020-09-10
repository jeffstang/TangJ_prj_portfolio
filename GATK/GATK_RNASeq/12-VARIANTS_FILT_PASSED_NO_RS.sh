#!/bin/bash
# SET CONSTANTS
INPUT_VCF=$1
VCF_FILT_ON_PASS_NO_RS=$2

# Separate columns by tab 
# Output line if it starts with a # ($0 ~ /^#/) 
# Or (||) if "no RSID" = . on column 3 and PASS on column 7

awk 'BEGIN {FS=OFS="\t"} $0 ~ /^#/ || ( $3 == "." && $7 == "PASS" )' "$INPUT_VCF" > "$VCF_FILT_ON_PASS_NO_RS"
