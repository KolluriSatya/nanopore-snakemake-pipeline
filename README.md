# Nanopore Genome Assembly Pipeline

This repository contains the analysis of Nanopore sequencing reads for genome assembly, QC, annotation, and reporting using Snakemake.

## Workflow
1. Environment setup
2. QC of raw reads (NanoPlot)
3. Genome assembly (Miniasm)
4. Polishing assembly (Racon)
5. Annotation (Prokka)
6. Contig characterization (BLAST)
7. Assembly QC (Quast)
8. Reporting results

## Folder Structure
results/
├─ qc_raw/         
├─ nanoplot/       
├─ quast/          
├─ blast/          
├─ prokka/         
├─ miniasm/        # .keep placeholder
├─ minimap2/       # .keep placeholder
├─ racon/          # .keep placeholder

Dataset used: [Google Drive Link](https://drive.google.com/drive/folders/10MGILmqY2qzQOh4thZHgstubOmDpEhrV?usp=sharing)
