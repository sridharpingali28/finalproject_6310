#!/bin/bash
# Build Apptainer container for CRISPRitz from Docker archive
# NOTE:
#   1) Run Docker commands on your LOCAL machine.
#   2) Then transfer crispritz_docker.tar to Explorer.
#   3) Run THIS script on Explorer.

set -euo pipefail

cd ~/crispritz_repro

if [[ ! -f crispritz_docker.tar ]]; then
  echo "ERROR: crispritz_docker.tar not found in ~/crispritz_repro"
  echo "Make sure you ran on your local machine:"
  echo "  docker pull pinellolab/crispritz:latest"
  echo "  docker save -o crispritz_docker.tar pinellolab/crispritz:latest"
  echo "  scp crispritz_docker.tar USER@login.explorer.northeastern.edu:~/crispritz_repro/"
  exit 1
fi

echo "Building Apptainer container from crispritz_docker.tar..."
apptainer build crispritz.sif docker-archive://crispritz_docker.tar

echo "Testing container..."
apptainer exec crispritz.sif crispritz.py

echo "Container build complete."
ls -lh crispritz.sif

chmod +x build_container.sh
