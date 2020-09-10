#!/bin/bash
# CONSTANTS
INPUT_BAM=$1
VCF=$2

# Set Directory Paths and Dependencies
GATK=/projects/NCI_Burkitts/bin/centos-6/miniconda/bin/GenomeAnalysisTK
FASTA=/projects/NCI_Burkitts/results/rnaseq_variants/ref/GRCh38.p7.gencode.v25.chr_patch_hapl_scaff.with_chrEBV.genome.fa
DBSNP=/projects/NCI_Burkitts/ref/GRCh38/Annotation/Variation/dbsnp.gatk.common_all_20170403.vcf.gz

# Haplotype Caller for Variant Calling
# -dontUseSoftClippedBases minimizes false positive and negative calling; use dangling head merging operations and avoids using soft-clipped bases
$GATK -Xmx5G \
-T HaplotypeCaller \
-R $FASTA \
-I $INPUT_BAM \
-dontUseSoftClippedBases \
-stand_call_conf 20.0 \
--dbsnp $DBSNP \
--intervals chr1:23556984-23560684 \
--maxReadsInRegionPerSample 1000000 \
--maxReadsInMemoryPerSample 1000000 \
--debug \
-o $VCF 2> $VCF.log.txt
