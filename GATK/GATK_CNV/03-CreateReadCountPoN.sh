#!/bin/bash

# 13 samples to generate Panel of Normals
# Can create a list of paths for input to generate panel of normals (PON)

# Explicit GC Bias Correction
GC_BIAS_INTERVALS="/home/jtang/DLBCL_LY17/data/GATK_CNV/AnnotateInterval_GC_Correction/AnnotateIntervalsGC.tsv"

# CONSTANTS
HDF5_LIST=$1
PON_HDF5=$2

gatk --java-options "-Xmx6500m" CreateReadCountPanelOfNormals \
	-I $HDF5_LIST \
	--annotated-intervals $GC_BIAS_INTERVALS \
	-O $PON_HDF5
