#!/bin/bash

# Set File/Directory Path to generate STAR GENOME INDEX
STAR=/projects/NCI_Burkitts/bin/centos-6/miniconda/bin/STAR 
STAR_INDEX=/projects/NCI_Burkitts/results/rnaseq_variants/results/01_STAR_INDEX
FASTA=/projects/NCI_Burkitts/results/rnaseq_variants/ref/GRCh38.p7.gencode.v25.chr_patch_hapl_scaff.with_chrEBV.genome.fa
GTF=/projects/NCI_Burkitts/results/rnaseq_variants/ref/gencode.v25.chr_patch_hapl_scaff.with_chrEBV.annotation.gtf

# Generate Reference Genome Index for First Pass
# Length of overhang is Read.Length - 1 = 74

$STAR \
--runThreadN 6 \
--runMode genomeGenerate \
--genomeDir $STAR_INDEX \
--genomeFastaFiles $FASTA \
--sjdbGTFfile $GTF \
--sjdbOverhang 74 
