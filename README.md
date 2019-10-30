<h1 align="center">
  <br>
  <a href="https://github.com/oskarvid/happy-snake"><img src="https://raw.githubusercontent.com/oskarvid/happy-snake/master/.logo.svg?sanitize=true" alt="Happy-Snake" width="200"></a>
</h1>

[![Travis Build Status](https://travis-ci.org/oskarvid/happy-snake/.logo.svg?branch=master)](https://travis-ci.org/oskarvid/happy-snake)

# Happy-Snake
Haplotype comparison snakemake workflow for running multiple vcf samples with [hap.py](https://github.com/Illumina/hap.py/).

![happy snake dag](https://raw.githubusercontent.com/oskarvid/happy-snake/master/.dag.svg?sanitize=true)

## Instructions

### Quick testing instructions
You can clone this repository and fire up a test immediately with the provided toy datasets. The toy fasta needs to be relatively big for `hap.py` to be able to finish so if you want to download it from this repository you need to install [git lfs](https://git-lfs.github.com/). Once you've installed it you will get the toy fasta file by default when you run `git clone https://github.com/oskarvid/happy-snake`. 

It runs in a docker container, install docker using the appropriate instructions here: https://docs.docker.com/install/

Then you run
```bash
cd /path/to/happy-snake
./scripts/go.sh
```

### Setting input file information
Edit the [samples.tsv](https://raw.githubusercontent.com/oskarvid/happy-snake/master/samples.tsv) file and enter the filename without the file ending in the `sample` column and the full file path in the `VCF` column. The file path is relative to the `happy-snake` directory. Only use tab spaces.  

### Download reference files
The workflow has been tested with the hg38 reference file from here: ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/hg38/Homo_sapiens_assembly38.fasta.gz  
You can download it with `wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/hg38/Homo_sapiens_assembly38.fasta.gz`  

You also need the gold standard vcf file, tbi index and bed interval file from here:  
ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/release/NA12878_HG001/NISTv3.3.2/GRCh38/  
Put them in your references directory.  

### Preprocessing the reference files
hap.py will do all preprocessing of your fasta file, just put it in the references directory. If you have an already unzipped fasta file the workflow will skip this step.

### Configuring the go.sh script
If you want to use a different reference file directory than the default one, change the path in the variable called `REFERENCES` in the `./scripts/go.sh` script and point it to your reference file directory. 

### Editing the config.yaml file
Edit the [config.yaml](https://raw.githubusercontent.com/oskarvid/happy-snake/master/config.yaml) file and change the file names, but don't change the `/references` file path because it refers to the mount point inside the container when the workflow is running.

### That's it!
This should be all you need to do to get going using this workflow. Happy benchmarking!  


<details><summary>Docker image build instructions</summary>
<p>
The docker images was built by manually building the hap.py docker image by cloning the hap.py github repository, and then this manually built hap.py image was used as base image to build the snakemake docker image from the snakemake gitlabs repository. It's a bit hacky but there you go.
</p>
</details>
