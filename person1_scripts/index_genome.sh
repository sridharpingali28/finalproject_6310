#!/bin/bash
# Index hg19 genome for CRISPRitz using NGG PAM

set -euo pipefail

cd ~/crispritz_repro

if [[ ! -f crispritz.sif ]]; then
  echo "ERROR: crispritz.sif not found. Run build_container.sh first."
  exit 1
fi

mkdir -p genome_library

echo "Indexing hg19 with NGG PAM (bMax=2)..."
apptainer exec crispritz.sif crispritz.py index-genome \
  hg19 \
  data/hg19_chr/ \
  pam/pamNGG.txt \
  -bMax 2 \
  -th 8

echo "Indexing complete. Created genome_library/NGG_2_hg19/:"
ls -lh genome_library
