#! /bin/bash
# Set File Path Variables for STAR FIRST PASS
STAR=/projects/NCI_Burkitts/bin/centos-6/miniconda/bin/STAR
DATDIR=/projects/NCI_Burkitts/data/mrna_fastqs
STAR_INDEX=/projects/NCI_Burkitts/results/rnaseq_variants/results/01_STAR_INDEX/Genome
SECOND_PASS=/projects/NCI_Burkitts/results/rnaseq_variants/results/05_STAR_SECOND_PASS
FASTQLIST="/projects/NCI_Burkitts/results/rnaseq_variants/results/sample_ids.txt"

# Run a While loop to run a batch of samples to generate output from STAR first pass commands.
while read line; do
        fastq1=${line}_R1.fastq.gz
        dirName=$fastq1
        dirName=${dirName%_*}
        mkdir $dirName
        outPrefix="${SECOND_PASS}/${dirName}/${outPrefix}"
done < "$FASTQLIST"

