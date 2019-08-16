import pandas as pd
# Read functions.smk file to define the functions that are used to select input files
include: 'scripts/functions.smk'

# Config file with paths to reference files etc
configfile: 'config.yaml'

# tsv file with names and paths to input files
samples = config['samples']

# Make Snakefile easier to work with by accepting any input fasta file name and 
# automatically create output files based on the fasta file basename
basename = config['fasta'].rsplit('.', -1)[0]

# Create variables to select sample names, lane numbers and flowcell names from the sample.tsv file
samples = pd.read_csv(samples, sep='\t', dtype=str).set_index(["sample", "VCF"], drop=False)
samples.index = samples.index.set_levels([i.astype(str) for i in samples.index.levels]) # enforce str in index

rule all:
  input:
    expand("Outputs/{samples}/{samples}_flag",
      samples=samples['sample']),
    basename + '.fasta',
    basename + '.sdf',

rule unzip:
  input:
    config['fasta']
  output:
    basename + '.fasta',
  shell:
    "zcat {input} > {output}"

rule sdfCreation:
  input:
    config['fasta'],
  output:
    directory(basename + '.sdf'),
  shell:
    "/opt/hap.py/libexec/rtg-tools-install/rtg \
    format \
    -o {output} \
    {input}"

rule fastaIndexing:
  input:
    rules.unzip.output,
  output:
    basename + '.fasta.fai',
  shell:
    "/opt/hap.py/bin/samtools \
    faidx \
    {input} > {output}"

rule happy:
  input:
    vcf = get_vcf,
    bed = config['bed'],
    truth = config['truth'],
    fasta = rules.unzip.output,
    sdf = rules.sdfCreation.output,
    fai = rules.fastaIndexing.output,
  output:
    flag = temp(touch("Outputs/{samples}/{samples}_flag")),
  threads:
    4
  params:
    basename = "Outputs/{samples}/{samples}_happy",
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
