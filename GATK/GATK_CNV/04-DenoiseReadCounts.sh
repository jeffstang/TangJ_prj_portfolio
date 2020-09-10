#!/bin/bash
# CONSTANTS
PON_GCAnnotated_HDF5="/home/jtang/DLBCL_LY17/data/GATK_CNV/03-CreatePanelOfNormals/LY17_pon.hdf5"

# VARIABLES
TUMOUR_COUNTS_HDF5=$1
STANDARDIZED_CR_TSV=$2
DENOISED_CR_TSV=$3

gatk DenoiseReadCounts \
	-I $TUMOUR_COUNTS_HDF5 \
	--count-panel-of-normals $PON_GCAnnotated_HDF5 \
	--standardized-copy-ratios $STANDARDIZED_CR_TSV \
	--denoised-copy-ratios $DENOISED_CR_TSV
