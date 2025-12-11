#!/usr/bin/env python3
"""
Generate visualization of EMX1 off-target annotation results.
Creates a horizontal bar plot showing top genes hit by off-targets.
"""

import matplotlib.pyplot as plt

def parse_annotation_summary(filepath):
    """Parse the CRISPRitz annotation summary file."""
    data = []
    
    with open(filepath, 'r') as f:
        for line in f:
            # Skip header and separator lines
            if line.startswith('-') or line.startswith('targets'):
                continue
            
            parts = line.strip().split()
            if len(parts) > 1:
                gene = parts[0]
                # Sum all count columns
                total = sum(int(x) for x in parts[1:])
                if total > 0:
                    data.append((gene, total))
    
    # Sort by count descending
    data.sort(key=lambda x: x[1], reverse=True)
    return data

def create_barplot(data, output_file, top_n=20):
    """Create horizontal bar plot of top genes."""
    
    top_genes = data[:top_n]
    genes = [x[0] for x in top_genes]
    counts = [x[1] for x in top_genes]
    
    # Create figure
    plt.figure(figsize=(12, 8))
    plt.barh(genes, counts, color='steelblue', edgecolor='black', alpha=0.8)
    
    # Formatting
    plt.xlabel('Number of Off-Targets', fontsize=14)
    plt.ylabel('Gene', fontsize=14)
    plt.title('Top 20 Genes Hit by EMX1 Off-Targets', fontsize=16, fontweight='bold')
    plt.gca().invert_yaxis()  # Highest at top
    
    # Add count labels on bars
    for i, (gene, count) in enumerate(top_genes):
        plt.text(count + 1, i, str(count), va='center', fontsize=10)
    
    plt.tight_layout()
    plt.savefig(output_file, dpi=300, bbox_inches='tight')
    plt.close()
    
    print(f"Plot saved to {output_file}")

def main():
    summary_file = "results/emx1_hg19_annotated.txt.Annotation.summary.txt"
    output_file = "results/emx1_annotation_barplot.png"
    
    print("Parsing annotation summary...")
    data = parse_annotation_summary(summary_file)
    
    print(f"Found {len(data)} genes with off-target hits")
    print(f"\nTop 5 genes:")
    for gene, count in data[:5]:
        print(f"  {gene}: {count} off-targets")
    
    print(f"\nCreating visualization...")
    create_barplot(data, output_file)

if __name__ == "__main__":
    main()
