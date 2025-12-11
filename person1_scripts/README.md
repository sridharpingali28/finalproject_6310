## CRISPRitz Reproducibility Person 1 Responsibilities: Environment setup and EMX1 guide validation
This respository folder contains the scripts used by myself, Cole Souders, to set up a fully reproducible CRISPRitz environment on Northeastern's Explorer HPC cluster and to reproduce the EMX1 off-target analysis from the CRISPRitz paper.
The goals of this part of the project were to:
- Create a shared project directory on Explorer (`~/crispritz_repro`).
- Build an Apptainer container (`crispritz.sif`) from the official Pinello Lab
  `pinellolab/crispritz:latest` Docker image.
- Download the hg19 reference genome, NGG PAM file, gene annotations, and EMX1 guide.
- Index the hg19 genome for CRISPRitz.
- Run an EMX1 off-target search and annotate the resulting sites.

These steps provided the validated environment and baseline EMX1 results that the
rest of the group used for mismatch/bulge validation and CCR5 guide analysis.

## Files in this repository

All scripts are intended to be run on Explorer, except the Docker commands
mentioned in comments (which are run on a local machine).

- `setup_directories.sh`  
  Creates the shared `~/crispritz_repro` directory structure (data, pam, guides,
  results, logs, genome_library).

- `build_container.sh`  
  Builds the `crispritz.sif` Apptainer image from a Docker archive
  (`crispritz_docker.tar`) that is prepared on a local machine.

- `fasta_download.sh`  
  Downloads the hg19 reference genome, SpCas9 NGG PAM file, hg19 refGene annotations,
  and creates the EMX1 guide file (`guides/emx1.txt`).

- `index_genome.sh`  
  Uses CRISPRitz to index the hg19 genome with NGG PAM and creates
  `genome_library/NGG_2_hg19/`.

- `run_emx1_search.sh`  
  Runs a CRISPRitz search for the EMX1 guide against the hg19 index, producing
  EMX1 off-target predictions in `results/emx1_hg19.*`.

- `annotate_emx1.sh`  
  Annotates the EMX1 off-targets using the `refGene_hg19.bed` annotation file and
  writes an annotated output file in `results/`.

  ## Prerequisites

- Access to Northeastern's Explorer HPC cluster.
- Apptainer installed on Explorer.
- Docker installed on a local machine (for the Docker → tar)
- Git (to clone this repository)

## STEPWISE EXECUTION
# 1. Clone this repository on Explorer
# 2. Create the project directory structure

    ./setup_directories.sh

Creates:
- `~/crispritz_repro/data/hg19_chr`
- `~/crispritz_repro/pam`
- `~/crispritz_repro/guides`
- `~/crispritz_repro/results`
- `~/crispritz_repro/logs`
- `~/crispritz_repro/genome_library`

# 3. On your local machine: pull and save the Docker image

Run these commands locally:

docker pull pinellolab/crispritz:latest
docker save -o crispritz_docker.tar pinellolab/crispritz:latest

Transfer the `.tar` file to Explorer:

scp crispritz_docker.tar <USERNAME>@login.explorer.northeastern.edu:~/crispritz_repro/

# 4. Build the Apptainer container on Explorer

./build_container.sh

Does:
- Builds `crispritz.sif`
- Verifies CRISPRitz is callable (`crispritz.py`)
- Confirms version 2.6.6 and available subcommands

# 5. Download hg19 genome, PAM, annotations, and EMX1 guide

./fasta_download.sh

Does:
- Downloads and extracts `chromFa.tar.gz` into `data/hg19_chr`
- Downloads the SpCas9 NGG PAM file (`pamNGG.txt`)
- Converts refGene annotations into BED format (`refGene_hg19.bed`)
- Creates the EMX1 guide file (`guides/emx1.txt`)

# 6. Index the hg19 genome with CRISPRitz

./index_genome.sh

Creates:

    ~/crispritz_repro/genome_library/NGG_2_hg19/

This step validates that CRISPRitz is functioning and that the index can be built reproducibly on Explorer.

# 7. Run EMX1 off-target search

./run_emx1_search.sh

Outputs written to:

- `results/emx1_hg19.targets.txt`
- Additional summary/profile files

This reproduces the EMX1 benchmark from the original CRISPRitz paper.

# 8. Annotate EMX1 off-target results

./annotate_emx1.sh

Produces:

- `results/emx1_hg19_annotated.txt`
- Annotation summary files (`*.Annotation.*`)
