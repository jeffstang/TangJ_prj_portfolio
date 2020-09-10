#!/bin/bash
# CONSTANTS
INPUT_BAM=$1
OUTPUT_BAM=$2
NUM_THREADS=${3:-12}

# SAMBAMBA TOOL PATH
SAMBAMBA=/projects/NCI_Burkitts/bin/centos-6/miniconda/bin/sambamba

# RUN SAMBAMBA
# Set number of threads
# Show progress bar
# Uses same criteria as Picard

$SAMBAMBA markdup --nthreads=$NUM_THREADS --show-progress $INPUT_BAM $OUTPUT_BAM

# Add && rm $INPUT_BAM to remove SORTED_READ_GROUPS.bam
