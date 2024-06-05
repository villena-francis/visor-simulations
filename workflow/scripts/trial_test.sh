# Verify stage data
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <stage>"
    exit 1
fi

stage=$1

# Redirect stdout and stderr to the log file
exec > >(tee -a results/log/${stage}_test.log) 2>&1
set -x

# Download the human reference genome
for url in $(cat resources/url)
do
    bash workflow/scripts/download.sh $url resources/genome
done

# For a chromosome...
for chr in chr22
do
# Extract the individal fasta from reference genome
    samtools faidx resources/genome/*genome.fa $chr > resources/genome/$chr.fa
# Run VISOR HACk to insert SVs
    VISOR HACk -b resources/${stage}/HACk.h1.bed resources/${stage}/HACk.h2.bed -g resources/$chr.fa -o results/${stage}HACk
# Generate a BED file with the maximum length 
    bash workflow/scripts/makeBED.sh $stage $chr 
# Run VISOR LASeR to simulate long reads
    VISOR LASeR -g resources/genome/$chr.fa -s results/${stage}HACk -b results/${stage}HACk/laser.simple.bed -o results/${stage}LASeR --threads 10 --coverage 1 --fastq --read_type nanopore
done 