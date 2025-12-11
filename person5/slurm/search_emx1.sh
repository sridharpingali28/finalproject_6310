#!/bin/bash
#SBATCH --job-name=crispritz_search
#SBATCH --output=logs/search_%j.out
#SBATCH --error=logs/search_%j.err
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --partition=short

cd ~/crispritz_repro

# Search for EMX1 guide off-targets
# Parameters:
#   genome_library/NGG_2_hg19: indexed genome directory
#   pam/pamNGG.txt: PAM sequence file
#   guides/emx1.txt: guide RNA sequence file
#   results/emx1_hg19: output prefix
#   -index: use indexed genome (faster)
#   -bDNA 1: allow 1 DNA bulge
#   -bRNA 1: allow 1 RNA bulge
#   -mm 4: allow up to 4 mismatches
#   -t: output in tabular format
#   -th 8: number of threads

apptainer exec crispritz.sif crispritz.py search \
    genome_library/NGG_2_hg19 \
    pam/pamNGG.txt \
    guides/emx1.txt \
    results/emx1_hg19 \
    -index \
    -bDNA 1 \
    -bRNA 1 \
    -mm 4 \
    -t \
    -th 8

echo "Search complete!"
echo "Total off-targets found: $(wc -l < results/emx1_hg19.targets.txt)"
