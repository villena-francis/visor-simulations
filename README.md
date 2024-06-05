# Purpose

This repository is used for exploratory analyses with [VISOR](https://github.com/davidebolo1993/VISOR) application, focusing on simulating long reads with structural variations (SVs) characteristic of multiple myeloma (MM).

# Initial test

The `trial_test.sh` was created to better understand how the HACk and LASeR modules of VISOR work.

Each stage of MM is represented by a specific folder in `resources`. These folders contain .bed files that provide the necessary [instructions to insert the SVs](https://davidebolo1993.github.io/visordoc/usage/usage.html#visor-hack) into the reference genome, wich is located in `genome`. For this trial, the only stage aviable is `test`.

```shell
#create the environment
mamba env create -f workflow/envs/visor_test.yaml
#activate the environment
mamba activate visor_test
#execute the pipeline for stage "test"
bash workflow/scripts/trial_test.sh test
```
# Snakemake pipeline

## Setup 

The setup of the pipeline consists of the modifying the `config.yaml`, setting the reference genome, the MM stages to simulate and the location of the output reads.

> **Pending expansion:** The methodology and instructions for generating the inputs of MM stages will be included soon.

### Input files

* **reference genome** to insert the SVs
* **stage(s) folder(s)** with **.bam files** that contain the instructions to recreate the SVs
  
## Usage

### 0. Get the reference genome

VISOR requires a reference genome to insert structural variations (SVs) and simulate the reads. This genome can be obtained from various sources. A possible method to download and prepare it is described below.

```shell
#download the human genome from GENCODE
wget -nc -P resources/genome https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_46/GRCh38.primary_assembly.genome.fa.gz
#descompress the file
gunzip -vk resources/genome/GRCh38.primary_assembly.genome.fa.gz
#generate a new fasta without unlocalized sequences
samtools faidx resources/genome/*genome.fa chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY > resources/genome/GRCh38_ref.fa
```

### 1. Set up the environment

This pipeline requires a [conda package manager](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html) and [bioconda](https://bioconda.github.io/). In addition, of course, it is essential to install [Snakemake](https://snakemake.readthedocs.io/en/stable/index.html); in this case, it has been decided to install it in a Mamba environment. 

> Snakemake environment allows working with a fixed version and avoids possible issues when re-running the pipeline after general software updates.

```shell
mamba env create -f workflow/envs/snakemake_visor.yaml
```

### 2. Download pipeline repository from GitHub

Use git clone command to create a local copy.

```shell
git clone https://github.com/villena-francis/visor-simulations
```

### 3. Configure the pipeline

Before executing the pipeline, users must configure it according to their samples. This involves editing the `config.yaml` to specify the names of the directories for the stages you want to simulate. 

> Stages directories must be created in advance with their corresponding .bed configuration files.

### 4. Run the pipeline

Once the pipeline is configured, the user just needs to activate the Snakemake environment and run visor.

```shell
#activate the environment
mamba activate snakemake_visor
#execute the pipeline
snakemake --use-conda --cores all
```