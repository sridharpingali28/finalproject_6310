#!/bin/bash
#SBATCH --job-name=index_enrich
#SBATCH --output=logs/index_enrich_%j.out
#SBATCH --error=logs/index_enrich_%j.err
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --partition=short

cd ~/crispritz_repro

# Index the enriched genome (with variants)
apptainer exec crispritz.sif crispritz.py index-genome \
  hg19_enriched \
  variants_genome/SNPs_genome/hg19_chr_enriched/ \
  pam/pamNGG.txt \
  -bMax 2 \
  -th 8

echo "Enriched genome indexing completed!"
