#!/bin/bash

echo "=========================================="
echo "BULGE IMPACT ANALYSIS"
echo "=========================================="
echo ""

# Baseline (no bulges)
base_file="results/person3/testing/test_3mm.targets.txt"
if [ -f "$base_file" ]; then
  base_count=$(wc -l < "$base_file")
  echo "Baseline (3mm, no bulges): $base_count off-targets"
else
  base_count=1
  echo "Baseline: NOT RUN YET"
fi

echo ""

# Tests with bulges
tests=("test_3mm_1DNA:3mm + 1 DNA bulge" 
       "test_3mm_1RNA:3mm + 1 RNA bulge"
       "test_3mm_both_bulges:3mm + both bulges")

for test in "${tests[@]}"; do
  name=$(echo $test | cut -d: -f1)
  label=$(echo $test | cut -d: -f2)
  file="results/person3/testing/${name}.targets.txt"
  
  if [ -f "$file" ]; then
    count=$(wc -l < "$file")
    fold=$(echo "scale=1; $count / $base_count" | bc)
    echo "$label: $count off-targets (${fold}x baseline)"
  else
    echo "$label: NOT RUN YET"
  fi
done

echo ""
echo "Expected: 10-100x increase with bulges"
