#ssh into explorer and create a dir with the following EXACTLY
mkdir -p ~/crispritz_repro/{data,pam,guides,results,logs}

#In a local computer with docker desktop installed (exit explorer)
cd $env:USERPROFILE\Downloads
docker pull pinellolab/crispritz:latest
docker save -o crispritz_docker.tar pinellolab/crispritz:latest

#Transfer to explorer
scp "$env:USERPROFILE\Downloads\crispritz_docker.tar" <your username>@login.explorer.northeastern.edu:~/crispritz_repro/

#convert to .sif file
cd ~/crispritz_repro
apptainer build crispritz.sif docker-archive://crispritz_docker.tar

#Optional to verify function
cd ~/crispritz_repro
apptainer exec crispritz.sif crispritz.py
