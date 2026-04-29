rule all:
    input:
        # QC of reads
        "results/nanoplot/NanoPlot-report.html",

        # Polished genome
        "results/racon/polished.fasta",

        # Assembly QC
        "results/quast/report.txt",

        # Blast Characterization
        "results/blast/blast_results.tsv",

        # Annotation
        "results/prokka/polished.gff",
        "results/prokka/polished.faa",

        # Gene summary table
        "results/prokka/genes_summary.tsv",

        # Final report
        "report/report.md"


#########################
# Nanoplot (Quality control of long/read sequencing)
#########################
rule nanoplot:
    input:
        reads="data/reads.fastq"
    output:
        html="results/nanoplot/NanoPlot-report.html"
    conda:
        "envs/nanoplot.yaml"
    shell:
        """
        mkdir -p results/nanoplot
        NanoPlot --fastq {input.reads} -o results/nanoplot --N50 --loglength
        """

###########################
# MINIASM 
###########################

rule miniasm:
    input:
        "data/reads.fastq"
    output:
        "results/miniasm/assembly.gfa",
        "results/miniasm/assembly.fasta"
    threads: 2
    shell:
        """
        mkdir -p results/miniasm

        minimap2 -x ava-ont {input} {input} > results/miniasm/reads.paf

        miniasm -f {input} results/miniasm/reads.paf > results/miniasm/assembly.gfa

        awk '$1=="S"{{print ">"$2"\\n"$3}}' results/miniasm/assembly.gfa > results/miniasm/assembly.fasta
        """

###########################
# RACON (Polishing step)
##########################

rule racon:
    input:
        reads="data/reads.fastq",
        assembly="results/miniasm/assembly.fasta"
    output:
        "results/racon/polished.fasta"
    conda:
        "envs/racon.yaml"
    threads: 4
    shell:
        """
        mkdir -p results/racon

        # Step 1: map reads to assembly
        minimap2 -x map-ont -t {threads} {input.assembly} {input.reads} > results/racon/aln.paf

        # Step 2: polish
        racon -t {threads} {input.reads} results/racon/aln.paf {input.assembly} > {output}
        """

##############################
# QUAST (Quality check)
##############################
rule quast:
    input:
        assembly="results/racon/polished.fasta"
    output:
        "results/quast/report.tsv"
    shell:
        """
        mkdir -p results/quast
        quast.py {input.assembly} -o results/quast
        """

##############################
# BLAST (Taxonomic identification)
##############################

rule blast:
    input:
        assembly="results/racon/polished.fasta"
    output:
        "results/blast/blast_results.tsv"
    conda:
        "envs/blast.yaml"
    shell:
        """
        mkdir -p results/blast

        blastn \
          -query {input.assembly} \
          -db nt \
          -remote \
          -out {output} \
          -outfmt "6 qseqid sseqid pident length evalue bitscore stitle" \
          -max_target_seqs 5
        """
################################
# Prokka
################################
rule prokka:
    input:
        "results/racon/polished.fasta"
    output:
        gff="results/prokka/polished.gff",
        faa="results/prokka/polished.faa",
        tsv="results/prokka/polished.tsv"
    conda:
        "envs/prokka.yaml"
    shell:
        """
        prokka {input} \
          --outdir results/prokka \
          --prefix polished \
          --force
        """
###############################
# prokka results summarize
###############################
rule prokka_summary:
    input:
        "results/prokka/polished.gff"
    output:
        "results/prokka/genes_summary.tsv"
    shell:
        """
        grep -v "^#" {input} | cut -f1,4,5 > {output}
        """

##################################
# report 
##################################
rule report:
    input:
        "report/report.md"
    output:
        "report/report.html"
    shell:
        """
        pandoc {input[0]} -o {output}
        """
