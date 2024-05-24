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