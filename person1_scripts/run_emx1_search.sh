#!/bin/bash
# Run CRISPRitz search for EMX1 guide on hg19 index

set -euo pipefail

cd ~/crispritz_repro

if [[ ! -f crispritz.sif ]]; then
  echo "ERROR: crispritz.sif not found. Run build_container.sh first."
  exit 1
fi

if [[ ! -d genome_library/NGG_2_hg19 ]]; then
  echo "ERROR: genome_library/NGG_2_hg19 not found. Run index_genome.sh first."
  exit 1
fi

mkdir -p results

echo "Running EMX1 search on hg19 (up to 4 mismatches, 1 DNA and 1 RNA bulge)..."
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

echo "Search complete. Outputs in results/:"
ls -lh results
