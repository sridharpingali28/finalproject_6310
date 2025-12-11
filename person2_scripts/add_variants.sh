#!/bin/bash
#SBATCH --job-name=add_variants
#SBATCH --output=logs/add_variants_%j.out
#SBATCH --error=logs/add_variants_%j.err
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --partition=short

cd ~/crispritz_repro

# Add variants to genome
apptainer exec crispritz.sif crispritz.py add-variants \
  data/variants/ \
  data/hg19_chr/

echo "Add-variants completed!"
