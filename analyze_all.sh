#!/bin/bash

echo "=========================================="
echo "PERSON 3 - COMPLETE ANALYSIS SUMMARY"
echo "=========================================="
echo ""

echo "EXECUTION LOG:"
echo "--------------"
if [ -f "results/person3/execution_log.txt" ]; then
  cat results/person3/execution_log.txt
else
  echo "No tests run yet"
fi

echo ""
echo ""

# Run subscripts
if [ -f "results/person3/analyze_mismatches.sh" ]; then
  ./results/person3/analyze_mismatches.sh
fi

echo ""
echo ""

if [ -f "results/person3/analyze_bulges.sh" ]; then
  ./results/person3/analyze_bulges.sh
fi

echo ""
echo "=========================================="
