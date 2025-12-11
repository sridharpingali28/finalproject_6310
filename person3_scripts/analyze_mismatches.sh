#!/bin/bash

echo "=========================================="
echo "MISMATCH SCALING ANALYSIS"
echo "=========================================="
echo ""

for mm in 0 1 2 3 4 5; do
  file="results/person3/testing/test_${mm}mm.targets.txt"
  if [ -f "$file" ]; then
    count=$(wc -l < "$file")
    avg=$(echo "scale=1; $count / 10" | bc)
    echo "Mismatches: $mm | Total: $count | Avg per guide: $avg"
  else
    echo "Mismatches: $mm | FILE NOT FOUND (not run yet)"
  fi
done

echo ""
echo "Expected pattern: Exponential increase (~10-15x per mismatch)"
