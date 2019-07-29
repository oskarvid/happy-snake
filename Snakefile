import pandas as pd
# Read functions.smk file to define the functions that are used to select input files
include: 'scripts/functions.smk'

# Config file with paths to reference files etc
configfile: 'config.yaml'

# tsv file with names and paths to input files
samples = config['samples']

# Create variables to select sample names, lane numbers and flowcell names from the sample.tsv file
samples = pd.read_csv(samples, sep='\t', dtype=str).set_index(["sample", "VCF"], drop=False)
samples.index = samples.index.set_levels([i.astype(str) for i in samples.index.levels]) # enforce str in index

rule all:
  input:
    expand("outputs/{samples}/{samples}_flag",
      samples=samples['sample']),

rule unzip:
  input:
    config['fasta'],
  output:
    "/references/hg38.fasta",
  shell:
    "zcat {input} > {output}"

rule sdfCreation:
  input:
    rules.unzip.output
  output:
    directory = directory("/references/hg38.sdf"),
    flag = temp(touch("/references/sdf-flag")),
  shell:
    "/opt/hap.py/libexec/rtg-tools-install/rtg \
    format \
    -o {output.directory} \
    {input}"

rule fastaIndexing:
  input:
    rules.unzip.output
  output:
    "/references/hg38.fasta.fai",
  shell:
    "/opt/hap.py/bin/samtools \
    faidx \
    {input} > {output}"

rule happy:
  input:
    "/references/sdf-flag",
    sdf = rules.sdfCreation.output.directory,
    fai = rules.fastaIndexing.output,
    fasta = rules.unzip.output,
    truth = config['truth'],
    bed = config['bed'],
    vcf = get_vcf,
  output:
    flag = temp(touch("outputs/{samples}/{samples}_flag")),
  threads:
    4
  params:
    basename = "outputs/{samples}/{samples}_happy",
  shell:
    "/opt/hap.py/bin/hap.py \
    --threads {threads} \
    --engine vcfeval \
    --engine-vcfeval-template {input.sdf} \
    -r {input.fasta} \
    {input.truth} \
    {input.vcf} \
    -o {params.basename} \
    -f {input.bed} \
    --no-json \
    --verbose"
