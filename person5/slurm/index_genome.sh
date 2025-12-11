#!/bin/bash
#SBATCH --job-name=crispritz_index
#SBATCH --output=logs/index_%j.out
#SBATCH --error=logs/index_%j.err
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --partition=short

cd ~/crispritz_repro

# Index the hg19 genome for CRISPRitz searching
# This creates searchable tree structures for fast off-target detection
# Parameters:
#   hg19: output prefix for indexed genome
#   data/hg19_chr/: directory containing chromosome FASTA files
#   pam/pamNGG.txt: PAM sequence file (NGG for SpCas9)
#   -bMax 2: maximum bulge size
#   -th 8: number of threads

apptainer exec crispritz.sif crispritz.py index-genome \
    hg19 \
    data/hg19_chr/ \
    pam/pamNGG.txt \
    -bMax 2 \
    -th 8

echo "Genome indexing complete!"
ls -lh genome_library/
