rule all:
    input:
        expand(f"{OUTDIR}/{{stage}}LASeR", stage = STAGE_LIST)

rule get_genome:
    output:
        f"{RESDIR}/{GENOME}"
    log:
        f"{LOGDIR}/get_genome/{GENOME}.log"
    benchmark:
        f"{LOGDIR}/get_genome/{GENOME}.bmk"
    shell:"""
        sh scripts/download.sh {URL} {RESDIR}
        """

rule extract_chromosome_fasta:
    input:
        f"{RESDIR}/{GENOME}"
    output:
        f"{RESDIR}/{CHR}.fa"
    log:
        f"{LOGDIR}/extract_fasta/{GENOME}.log"
    benchmark:
        f"{LOGDIR}/extract_fasta/{GENOME}.bmk"
    conda:
        "envs/samtools.yaml"
    shell:"""
        samtools faidx {input} {CHR} > {output}
    """

rule visor_hack:
    input:
        fasta = f"{RESDIR}/{CHR}.fa",
        bed1 = f"{DATA}/{{stage}}/HACk.h1.bed",
        bed2 = f"{DATA}/{{stage}}/HACk.h2.bed"
    output:
        h1_fa = f"{OUTDIR}/{{stage}}HACk/h1.fa",
        h1_fa_fai = f"{OUTDIR}/{{stage}}HACk/h1.fa.fai",
        h2_fa = f"{OUTDIR}/{{stage}}HACk/h2.fa",
        h2_fa_fai = f"{OUTDIR}/{{stage}}HACk/h2.fa.fai",
        folder = directory(f"{OUTDIR}/{{stage}}HACk")
    log:
        f"{LOGDIR}/visor_hack/{{stage}}.log"
    benchmark:
        f"{LOGDIR}/visor_hack/{{stage}}.bmk"
    conda:
        "envs/visor.yaml"
    shell:"""
        VISOR HACk -b {input.bed1} {input.bed2} -g {input.fasta} -o {output.folder}
    """

rule generate_bed:
    input:
        rules.visor_hack.output.h1_fa,
        rules.visor_hack.output.h2_fa,
        rules.visor_hack.output.h1_fa_fai,
        rules.visor_hack.output.h2_fa_fai,
    output:
        f"{OUTDIR}/{{stage}}HACk/laser.simple.bed"
    log:
        f"{LOGDIR}/generate_bed/{{stage}}.log"
    benchmark:
        f"{LOGDIR}/generate_bed/{{stage}}.bmk"
    shell:"""
        sh scripts/makeBED.sh {CHR} {wildcards.stage}
    """   

rule visor_laser:
    input:
        fasta = f"{RESDIR}/{CHR}.fa",
        hack_output = f"{OUTDIR}/{{stage}}HACk",
        bed = f"{OUTDIR}/{{stage}}HACk/laser.simple.bed"
    output:
        directory(f"{OUTDIR}/{{stage}}LASeR")
    log:
        f"{LOGDIR}/visor_laser/{{stage}}.log"
    benchmark:
        f"{LOGDIR}/run_visor_laser/{{stage}}.bmk"
    conda:
        "envs/visor.yaml"
    params:
        threads = 10,
        coverage = 1,
        read_type = "nanopore"
    shell:"""
        VISOR LASeR -g {input.fasta} -s {input.hack_output} -b {input.bed} \
        -o {output} --threads {params.threads} --coverage {params.coverage} \
        --fastq --read_type {params.read_type}
    """