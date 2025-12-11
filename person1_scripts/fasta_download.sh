#!/bin/bash
# Download required data files

cd ~/crispritz_repro

# Download hg19 reference genome (~900MB)
echo "Downloading hg19 genome..."
wget https://hgdownload.soe.ucsc.edu/goldenPath/hg19/bigZips/chromFa.tar.gz

# Extract genome
echo "Extracting genome..."
tar -xzf chromFa.tar.gz -C data/hg19_chr
echo "Extracted $(ls data/hg19_chr/*.fa | wc -l) chromosome files"

# Download PAM file
echo "Downloading PAM file..."
cd pam
wget https://raw.githubusercontent.com/pinellolab/CRISPRitz/master/pam/pamNGG.txt
echo "PAM file contents:"
cat pamNGG.txt

# Download gene annotations
echo "Downloading gene annotations..."
cd ../data
wget http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/refGene.txt.gz
gunzip refGene.txt.gz
cut -f3,5,6,13 refGene.txt | awk '{print $1"\t"$2"\t"$3"\t"$4}' > refGene_hg19.bed
echo "Created annotation file with $(wc -l < refGene_hg19.bed) gene features"

# Create EMX1 guide file
echo "Creating EMX1 guide file..."
cd ../guides
echo "GAGTCCGAGCAGAAGAAGAANGG" > emx1.txt
echo "EMX1 guide: $(cat emx1.txt)"

echo "Data download complete!"
