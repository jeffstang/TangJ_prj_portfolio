#!/bin/bash

# Set Directory Paths
STAR=/projects/NCI_Burkitts/bin/centos-6/miniconda/bin/STAR
SJ_WITH_INDEX=/projects/NCI_Burkitts/results/rnaseq_variants/results/04_INDEX_WITH_SJ
FASTA=/projects/NCI_Burkitts/results/rnaseq_variants/ref/GRCh38.p7.gencode.v25.chr_patch_hapl_scaff.with_chrEBV.genome.fa
GTF=/projects/NCI_Burkitts/results/rnaseq_variants/ref/gencode.v25.chr_patch_hapl_scaff.with_chrEBV.annotation.gtf
SJ_OUT_TAB=/projects/NCI_Burkitts/results/rnaseq_variants/results/03_CAT_ALL_SAMPLE_SJ/novel_SJ_5_cohort_2.out.tab

# Generate Index from concatenated SJ
# --limitSjdbInsertNsj 118034 SOLUTION provided by STAR due to limit: "the number of junctions 
# to be inserted on the fly =1180034 is larger than the limitSjdbInsertNsj=100000"

$STAR \
--runThreadN 20 \
--runMode genomeGenerate \
--genomeDir $SJ_WITH_INDEX \
--genomeFastaFiles $FASTA \
--sjdbGTFfile $GTF \
--sjdbFileChrStartEnd $SJ_OUT_TAB \
--limitSjdbInsertNsj 1200000 \
--sjdbOverhang 74
