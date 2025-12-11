# CRISPRitz Pipeline Reproduction

A comprehensive reproduction of the CRISPRitz off-target analysis pipeline for BINF6310 Bioinformatics Programming at Northeastern University.

## Overview

This project reproduces key analyses from:

> Cancellieri, S., Canver, M. C., Bombieri, N., Giugno, R., & Pinello, L. (2020). CRISPRitz: rapid, high-throughput and variant-aware in silico off-target site identification for CRISPR genome editing. *Bioinformatics*, 36(7), 2001–2008.

CRISPR-Cas9 genome editing can cause unintended cuts at off-target sites with similar sequences to the intended target. CRISPRitz addresses this by providing a fast, flexible framework that supports mismatch detection, DNA/RNA bulge handling, and variant-aware genome searching. Our team reproduced the core functionality of this tool on Northeastern's Explorer HPC cluster.

---

## Team Members & Roles

### Person 1: Cole – Infrastructure Setup & Data Management

**Responsibilities:**
- Converted CRISPRitz Docker container to Apptainer/Singularity format for HPC compatibility
- Configured the container to work with SLURM job scheduling system
- Downloaded and organized the hg19 reference genome from UCSC (~3 GB)
- Obtained gene annotations (refGene BED file) for result interpretation
- Created PAM file defining the NGG recognition sequence for SpCas9

**Key Challenges Solved:**
- HPC clusters use Apptainer/Singularity instead of Docker for security reasons
- Network restrictions on compute nodes required downloading data locally then transferring to cluster
- Verified all dependencies (Python, required libraries) were functional within the container

**Deliverables:**
- Working `crispritz.sif` Apptainer container (613 MB)
- Organized genome files (93 chromosome FASTAs)
- PAM and annotation files ready for downstream analysis

---

### Person 2: Santhiyaa – Variant Encoding & Genome Indexing

**Responsibilities:**
- Encoded genetic variants using IUPAC notation for variant-aware searching
- Built searchable genome indices for ultra-fast off-target detection
- Created both reference and variant-enriched genome versions

**Why Variant Encoding Matters:**
- Standard reference genomes miss genetic variation across human populations
- IUPAC codes represent ambiguous bases (R = A or G, Y = C or T, W = A or T, etc.)
- Enables identification of off-targets that only exist in certain individuals' genomes
- Critical for personalized medicine and therapeutic applications

**Technical Implementation:**
- Encoded 1,055,895 genetic variants from 1000 Genomes Project (2,504 individuals)
- Built ternary search tree (TST) structures optimized for short sequence queries
- Reference index: 6.8 GB | Enriched index: 6.9 GB
- Runtime: ~25 minutes on HPC cluster

**Key Insight:**
Large upfront compute cost for indexing, but searches become 10-100x faster afterward.

---

### Person 3: Kruti – Feature Testing & Validation

**Responsibilities:**
- Validated CRISPRitz algorithm accuracy and functionality
- Tested mismatch detection across 0-5 mismatch levels
- Benchmarked DNA bulge, RNA bulge, and combined bulge detection
- Ensured reproducibility across HPC environments

**Quality Assurance Process:**
- Built Apptainer container from CRISPRitz Docker image
- Prepared 10 synthetic gRNAs for systematic testing
- Indexed both reference and 1000 Genomes variant-aware genomes
- Resolved symlink issues (required full local genome copies)

**Mismatch Testing Results:**
- Tested mismatch levels: 0–5 mismatches
- Observed expected exponential growth (~11–14× increase per mismatch level)
- Confirmed runtime stability and reproducibility

**Bulge Testing Results:**
- Tested DNA, RNA, and combined bulges
- Bulges increased off-target counts by 10–100×
- RNA bulges showed the strongest effect on off-target detection

**Variant-Aware Validation:**
- Confirmed additional off-target sites found in variant genome vs reference-only
- Validated functionality across both index types

---

### Person 4: Harshini – CCR5 Clinical Analysis

**Responsibilities:**
- Analyzed CRISPR guides targeting the CCR5 gene for HIV therapy applications
- Assessed off-target safety profiles for therapeutic guide candidates
- Ranked guides by clinical suitability

**Clinical Context:**
- CCR5 encodes a co-receptor that HIV uses to enter human cells
- The CCR5-delta32 mutation confers natural HIV resistance
- CRISPR disruption of CCR5 is an active therapeutic strategy (similar to the Berlin Patient approach)
- Critical to assess off-target safety before any clinical application

**Analysis Approach:**
- Evaluated multiple candidate guide RNAs targeting CCR5
- Ranked guides by off-target profile (fewer off-targets = safer)
- Identified guides hitting concerning genomic regions (coding genes, regulatory elements)
- Generated radar charts and comparison visualizations for guide quality metrics

**Key Findings:**
- Demonstrated importance of comprehensive off-target screening for therapeutic guides
- Identified safest guide candidates based on off-target analysis

---

### Person 5: Sridhar – EMX1 Analysis & Project Coordination

**Responsibilities:**
- Executed complete CRISPRitz pipeline demonstration using EMX1 guide
- Coordinated team contributions and integrated results
- Created visualizations and prepared final presentation

**Why EMX1?**
- EMX1 is a commonly used benchmark guide in CRISPR off-target studies
- Used in the original CRISPRitz paper for validation
- Allows direct comparison of our results to published findings
- Provides focused proof-of-concept (vs. analyzing 111,671 guides in GeCKO library)

**EMX1 Guide Details:**
- Sequence: `GAGTCCGAGCAGAAGAAGAA` + NGG (PAM)
- Genome: hg19 (human reference)
- Parameters: up to 4 mismatches, 1 DNA bulge, 1 RNA bulge


---

## Repository Structure

```
crispritz-pipeline-reproduction/
├── README.md                    # This file
├── scripts/
│   ├── 01_setup_directories.sh  # Create project folder structure
│   ├── 02_download_data.sh      # Download genome, PAM, annotations
│   ├── 03_build_container.sh    # Docker to Apptainer conversion
│   ├── 06_annotate_results.sh   # Add gene annotations to results
│   └── 07_plot_results.py       # Generate visualization
├── slurm/
│   ├── index_genome.sh          # SLURM job for genome indexing
│   └── search_emx1.sh           # SLURM job for EMX1 search
├── results/
│   └── emx1_hg19.targets.txt    # Raw off-target results
├── figures/
│   └── emx1_annotation_barplot.png  # Visualization
└── docs/
    └── presentation.pdf         # Final presentation slides
```

---

## Quick Start Guide

### Prerequisites

- Access to HPC cluster with Apptainer/Singularity
- Docker Desktop (for local container building)
- Python 3 with matplotlib
- ~50 GB disk space

### Installation & Execution

```bash
# 1. Clone repository
git clone https://github.com/YOUR_USERNAME/crispritz-pipeline-reproduction.git
cd crispritz-pipeline-reproduction

# 2. Set up directories
bash scripts/01_setup_directories.sh

# 3. Download data (genome, annotations, PAM file)
bash scripts/02_download_data.sh

# 4. Build container (requires Docker locally, then transfer)
# On local machine:
docker pull pinellolab/crispritz:latest
docker save -o crispritz_docker.tar pinellolab/crispritz:latest
scp crispritz_docker.tar USERNAME@login.explorer.northeastern.edu:~/crispritz_repro/

# On HPC:
apptainer build crispritz.sif docker-archive://crispritz_docker.tar

# 5. Submit indexing job (~2-4 hours)
sbatch slurm/index_genome.sh

# 6. Submit search job after indexing completes (~10 min)
sbatch slurm/search_emx1.sh

# 7. Annotate results
bash scripts/06_annotate_results.sh

# 8. Generate visualization
python3 scripts/07_plot_results.py
```


## References

1. Cancellieri, S., Canver, M. C., Bombieri, N., Giugno, R., & Pinello, L. (2020). CRISPRitz: rapid, high-throughput and variant-aware in silico off-target site identification for CRISPR genome editing. *Bioinformatics*, 36(7), 2001–2008.

2. The 1000 Genomes Project Consortium. (2015). A global reference for human genetic variation. *Nature*, 526(7571), 68–74.

3. Sanjana, N. E., Shalem, O., & Zhang, F. (2014). Improved vectors and genome-wide libraries for CRISPR screening. *Nature Methods*, 11(8), 783–784.

---

## License

MIT License

---

## Acknowledgments

- BINF6310 Bioinformatics Programming, Northeastern University
- Northeastern Research Computing (Explorer HPC Cluster)
- CRISPRitz development team (Pinello Lab)
