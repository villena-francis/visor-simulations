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