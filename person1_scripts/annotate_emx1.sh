#!/bin/bash
# Annotate EMX1 CRISPRitz results with refGene BED annotation

set -euo pipefail

cd ~/crispritz_repro

if [[ ! -f crispritz.sif ]]; then
  echo "ERROR: crispritz.sif not found. Run build_container.sh first."
  exit 1
fi

if [[ ! -f data/refGene_hg19.bed ]]; then
  echo "ERROR: data/refGene_hg19.bed not found. Run fasta_download.sh first."
  exit 1
fi

if [[ ! -f results/emx1_hg19.targets.txt ]]; then
  echo "ERROR: results/emx1_hg19.targets.txt not found. Run run_emx1_search.sh first."
  exit 1
fi

echo "Annotating EMX1 results..."
apptainer exec crispritz.sif crispritz.py annotate-results \
  results/emx1_hg19.targets.txt \
  data/refGene_hg19.bed \
  results/emx1_hg19_annotated.txt

echo "Annotation complete. Outputs:"
ls -lh results/emx1_hg19_annotated.txt*
