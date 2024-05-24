# Verify stage data
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <stage>"
    exit 1
fi

stage=$1

# Redirect stdout and stderr to the log file
exec > >(tee -a log/${stage}_test.log) 2>&1
set -x

# Download the human reference genome
for url in $(cat res/urls)
do
    bash scripts/download.sh $url res
done

# For a chromosome...
for chr in chr22
do
# Extract the individal fasta from reference genome
    samtools faidx res/*genome.fa $chr > res/$chr.fa
# Run VISOR HACk to insert SVs
    VISOR HACk -b data/${stage}/HACk.h1.bed data/${stage}/HACk.h2.bed -g res/$chr.fa -o out/${stage}HACk
# Generate a BED file with the maximum length 
    bash scripts/makeBED.sh $chr $stage
# Run VISOR LASeR to simulate long reads
    VISOR LASeR -g res/$chr.fa -s out/${stage}HACk -b out/${stage}HACk/laser.simple.bed -o out/${stage}LASeR --threads 10 --coverage 1 --fastq --read_type nanopore
done 