#!/bin/bash
# Create project directory structure

mkdir -p ~/crispritz_repro/{data,pam,guides,results,logs,genome_library}
mkdir -p ~/crispritz_repro/data/hg19_chr

cd ~/crispritz_repro
echo "Directory structure created at ~/crispritz_repro"
ls -lh

container:
#!/bin/bash
# Build Apptainer container from Docker image
# NOTE: Run Docker commands on local machine first, then transfer

# === ON LOCAL MACHINE (with Docker) ===
# docker pull pinellolab/crispritz:latest
# docker save -o crispritz_docker.tar pinellolab/crispritz:latest
# scp crispritz_docker.tar USERNAME@login.explorer.northeastern.edu:~/crispritz_repro/

# === ON HPC CLUSTER ===
cd ~/crispritz_repro

# Convert Docker tar to Apptainer SIF
echo "Building Apptainer container..."
apptainer build crispritz.sif docker-archive://crispritz_docker.tar

# Verify container
echo "Testing container..."
apptainer exec crispritz.sif crispritz.py

echo "Container build complete!"
ls -lh crispritz.sif
