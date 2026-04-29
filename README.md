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

## Results

The `results/` folder contains the processed outputs of the pipeline:

- **qc_raw/** – NanoPlot summaries of raw reads
- **nanoplot/** – NanoPlot plots and interactive HTML reports
- **quast/** – Assembly quality reports and PDF summaries
- **blast/** – Summary tables of contig characterization
- **prokka/** – Gene annotation summaries
- **miniasm/** – Placeholder folder for assembly outputs (.keep)
- **minimap2/** – Placeholder folder for alignments (.keep)
- **racon/** – Placeholder folder for polishing step (.keep)


Dataset used: [Google Drive Link](https://drive.google.com/drive/folders/10MGILmqY2qzQOh4thZHgstubOmDpEhrV?usp=sharing)
