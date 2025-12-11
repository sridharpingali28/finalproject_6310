# ssh into Explorer
ssh <yourusername>@login.explorer.northeastern.edu

# make working directories
mkdir -p ~/crispritz_repro/{data,pam,guides,results,logs}
cd ~/crispritz_repro

# confirm the container file exists
ls -lh crispritz.sif

# if not, rebuild from docker tar (only if needed)
apptainer build crispritz.sif docker-archive://crispritz_docker.tar

# test that crispritz runs (should print version 2.6.6 + subcommands)
apptainer exec crispritz.sif crispritz.py

# download hg19 genome split by chromosome (CRISPRitz needs per-chromosome FASTA)
cd ~/crispritz_repro/data
mkdir -p hg19_chr
wget https://hgdownload.soe.ucsc.edu/goldenPath/hg19/bigZips/chromFa.tar.gz
tar -xzf chromFa.tar.gz -C hg19_chr
ls hg19_chr | head

# download PAM file (SpCas9 NGG)
cd ~/crispritz_repro/pam
wget https://raw.githubusercontent.com/pinellolab/CRISPRitz/master/pam/pamNGG.txt

# create EMX1 guide RNA file
cd ~/crispritz_repro/guides
echo "GAGTCCGAGCAGAAGAAGAAG" > emx1.txt

# slurm job for genome indexing
cd ~/crispritz_repro
nano index_genome.sh

# inside index_genome.sh
#!/bin/bash
#SBATCH --job-name=crispritz_index
#SBATCH --output=logs/index_%j.out
#SBATCH --error=logs/index_%j.err
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --partition=short

cd ~/crispritz_repro
# NOTE: CRISPRitz will create genome_library/NGG_2_hg19/
apptainer exec crispritz.sif crispritz.py index-genome hg19 data/hg19_chr/ pam/pamNGG.txt -bMax 2 -th 8

# save and exit (Ctrl+O, Enter, Ctrl+X)

# submit slurm job
sbatch index_genome.sh

# monitor until job is COMPLETED
squeue -u $USER

# run CRISPRitz search on indexed genome
cd ~/crispritz_repro
apptainer exec crispritz.sif crispritz.py search \
  genome_library/NGG_2_hg19 pam/pamNGG.txt guides/emx1.txt results/emx1_hg19 \
  -index -bDNA 1 -bRNA 1 -mm 4 -t -th 8

# download gene annotation file for hg19
cd ~/crispritz_repro/data
wget http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/refGene.txt.gz
gunzip refGene.txt.gz
cut -f3,5,6,13 refGene.txt | awk '{print $1"\t"$2"\t"$3"\t"$4}' > refGene_hg19.bed

# annotate the search results
cd ~/crispritz_repro
apptainer exec crispritz.sif crispritz.py annotate-results \
  results/emx1_hg19.targets.txt data/refGene_hg19.bed results/emx1_hg19_annotated.txt

# make sure annotation outputs exist (CRISPRitz appends .Annotation.*)
ls -lh results/*annotated* results/*.Annotation.*

# create plotting script
cd ~/crispritz_repro
cat > plot_annotation_summary.py << 'PY'
#!/usr/bin/env python3
import pandas as pd
import matplotlib.pyplot as plt

summary_file = "results/emx1_hg19_annotated.txt.Annotation.summary.txt"
output_png   = "results/emx1_annotation_barplot.png"

df = pd.read_csv(summary_file, sep="\t", comment="-", header=None)
df.columns = ["Feature"] + [f"Col{i}" for i in range(1, len(df.columns))]
df = df.head(20)
df_genes = df[~df["Feature"].str.lower().str.contains("targets")]

plt.figure(figsize=(10,5))
plt.barh(df_genes["Feature"], df_genes.iloc[:,1])
plt.xlabel("Count")
plt.ylabel("Gene / Feature")
plt.title("Top annotated targets – EMX1 guide on hg19")
plt.tight_layout()
plt.savefig(output_png, dpi=300)
print(f"Plot saved to {output_png}")
PY
chmod +x plot_annotation_summary.py

# run plotting script inside container
apptainer exec crispritz.sif python3 plot_annotation_summary.py

# confirm final image output
ls -lh results/emx1_annotation_barplot.png
