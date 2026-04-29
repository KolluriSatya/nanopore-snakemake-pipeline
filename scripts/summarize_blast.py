import pandas as pd

# Load BLAST output
cols = ["qseqid","sseqid","pident","length","mismatch","evalue","bitscore","stitle"]
df = pd.read_csv(snakemake.input[0], sep="\t", names=cols)

# Keep best hit per contig (highest bitscore)
df = df.sort_values("bitscore", ascending=False).drop_duplicates("qseqid")

# Filter
df = df[(df["pident"] >= 70) & (df["length"] >= 200) & (df["evalue"] <= 1e-3)]

# Simple classification
def classify(x):
    x = str(x).lower()
    if "phage" in x:
        return "Phage"
    elif "plasmid" in x:
        return "Plasmid"
    else:
        return "Bacteria"

df["category"] = df["stitle"].apply(classify)

# Save
df.to_csv(snakemake.output[0], sep="\t", index=False)
