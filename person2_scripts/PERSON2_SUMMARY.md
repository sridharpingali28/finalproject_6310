# Person 2 (Santhiyaa Ramaraj) - Variant Encoding & Indexing
## Completion Date: November 15, 2025

## Summary
Successfully created variant-enriched genomes and genome indices for CRISPRitz off-target analysis. All deliverables are complete and ready for Person 3, 4, and 5 to use.

## What Was Accomplished

### 1. Environment Setup ✅
- Created CRISPRitz container using Apptainer: `crispritz.sif` (613 MB)
- Downloaded hg19 reference genome (93 chromosome files, ~3 GB total)
- Downloaded 1000 Genomes Project variants for chr22 (197 MB compressed)
- Set up directory structure and PAM files

### 2. Variant-Enriched Genome Creation ✅
- **Input**: hg19 reference genome + 1000 Genomes Phase 3 variants (chr22)
- **Output**: Enriched genome with **1,055,895 IUPAC-encoded variants**
- **Location**: `~/crispritz_repro/variants_genome/SNPs_genome/hg19_chr_enriched/`
- **Runtime**: ~2.5 minutes
- **Key Achievement**: Variants from 2,504 individuals encoded using IUPAC notation (R, Y, S, W, K, M)

### 3. Genome Indexing ✅
Created two complete genome indices for fast CRISPR off-target searching:

#### Reference Genome Index
- **Location**: `~/crispritz_repro/genome_library/NGG_2_hg19_reference/`
- **Size**: 6.8 GB
- **Runtime**: 11 minutes (664 seconds)
- **Contents**: 93 indexed chromosomes

#### Enriched Genome Index  
- **Location**: `~/crispritz_repro/genome_library/NGG_2_hg19_enriched/`
- **Size**: 6.9 GB  
- **Runtime**: 11 minutes (669 seconds)
- **Contents**: 93 indexed chromosomes with encoded variants

## Key Files for Team Use

### For Person 3 (Feature Testing - Kruti)
- Reference index: `genome_library/NGG_2_hg19_reference/`
- Enriched index: `genome_library/NGG_2_hg19_enriched/`
- Use these to test CRISPRitz search with different parameters

### For Person 4 (CCR5 Analysis - Harshini)
- Enriched index: `genome_library/NGG_2_hg19_enriched/`
- Use this for variant-aware CCR5 guide analysis

### For Person 5 (GeCKO Analysis - Sridhar & Cole)
- Both indices for comparison analysis

## Technical Details

### Challenges Encountered & Solutions
1. **VCF/FASTA chromosome naming mismatch**
   - Problem: VCF used "22", FASTA used "chr22"
   - Solution: Modified FASTA header to match VCF naming

2. **Memory limitations**
   - Problem: add-variants killed when run interactively
   - Solution: Used SLURM jobs with 64GB memory allocation

### SLURM Job Scripts Created
- `add_variants.sh` - Creates enriched genomes
- `index_reference.sh` - Indexes reference genome  
- `index_enriched.sh` - Indexes enriched genome

### Resource Usage
- **CPU**: 8 cores per job
- **Memory**: 64 GB per job
- **Partition**: short
- **Total runtime**: ~25 minutes for all tasks

## Verification
```bash
# Verify variant encoding
grep -v "^>" variants_genome/SNPs_genome/hg19_chr_enriched/22.enriched.fa | grep -o '[RYSWKM]' | wc -l
# Result: 1,055,895 variants encoded

# Verify indices exist
ls genome_library/
# Result: NGG_2_hg19_enriched/  NGG_2_hg19_reference/

# Check index sizes
du -sh genome_library/NGG_2_hg19_*
# Result: 6.8G reference, 6.9G enriched
```

## Next Steps for Team
- Person 3: Begin feature testing using both indices
- Person 4: Start CCR5 guide analysis with enriched index
- Person 5: Compare results between reference and enriched genomes for GeCKO library

## Notes
- All work completed on Northeastern Explorer cluster
- All indices use NGG PAM (SpCas9)
- Indices built with -bMax 2 (allows up to 2 bulges in searches)
- Only chr22 contains actual variants; other chromosomes are reference-only

---
**Prepared by**: Santhiyaa Ramaraj  
**Date**: November 15, 2025  
**Status**: ✅ COMPLETE - Ready for downstream analysis
