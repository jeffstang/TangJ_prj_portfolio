#!/bin/bash

# Set Variables
PREFIX="all_samples_SJ"
EXT="tab"

# Concatenate all SJ.out.tab files
ALL_SJ="$PREFIX.$EXT"

# Cats all samples at command line
cat "$@" > "$ALL_SJ"

# Filter splice junctions according to:
# 1) Remove annotated junctions, column 6
# 2) Remove junctions in chrM, column 1
# 3) Ensure at least one uniquely mapped read, column 7
ALL_SJ_FILT="$PREFIX.filt_on_sample.$EXT"
awk 'BEGIN { FS=OFS="\t" } { if ( $6 == "0" && $1 != "chrM" && $7 >= 1 ){ print $0 } }' "$ALL_SJ" > "$ALL_SJ_FILT"

# Then, only consider the first four columns (sample-agnostic properties)
# Sort and run uniq -c in order to count the number of samples supporting
# the junction, and filter on having 2 or more samples

ALL_SJ_FILT2="$PREFIX.filt_on_cohort.$EXT" 
cut -f1-4 "$ALL_SJ_FILT" | sort -V | uniq -c | perl -pe 's/^ +(\d+) (.*)/\1\t\2/' | awk 'BEGIN { FS=OFS="\t" } { if ( $1 >= 2 ){ print $2,$3,$4,$5 } }' | sort -k1,1 -k2,2n -k3,3 > $PREFIX.filt_on_cohort.tab

# Note to self: experiment filtering and cat step in R from output in FIRST_PASS.sh
