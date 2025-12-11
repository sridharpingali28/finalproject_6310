#!/bin/bash
# Annotate off-target results with gene information

cd ~/crispritz_repro

# Run annotation
# Parameters:
#   results/emx1_hg19.targets.txt: off-target search results
#   data/refGene_hg19.bed: gene annotation file
#   results/emx1_hg19_annotated.txt: output file

apptainer exec crispritz.sif crispritz.py annotate-results \
    results/emx1_hg19.targets.txt \
    data/refGene_hg19.bed \
    results/emx1_hg19_annotated.txt

echo "Annotation complete!"

# Show top genes hit by off-targets
echo ""
echo "Top 10 genes hit by EMX1 off-targets:"
grep -v "^-" results/emx1_hg19_annotated.txt.Annotation.summary.txt | \
    awk '{sum=0; for(i=2;i<=NF;i++) sum+=$i; print sum"\t"$1}' | \
    sort -rn | head -12
