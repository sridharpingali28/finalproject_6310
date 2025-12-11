#!/bin/bash
#SBATCH --job-name=index_ref
#SBATCH --output=logs/index_ref_%j.out
#SBATCH --error=logs/index_ref_%j.err
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --partition=short

cd ~/crispritz_repro

# Index the reference genome
apptainer exec crispritz.sif crispritz.py index-genome \
  hg19_reference \
  data/hg19_chr/ \
  pam/pamNGG.txt \
  -bMax 2 \
  -th 8

echo "Reference genome indexing completed!"
