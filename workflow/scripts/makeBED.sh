chr=$1
stage=$2

# Capture dimensions of chromosomes from haplotypes
cut -f1,2 results/${stage}HACk/*.fai res/$chr.fa.fai | \
# Obtain the maximum dimension
sort | awk '$2 > maxvals[$1] {lines[$1]=$0; maxvals[$1]=$2} END { for (tag in lines) print lines[tag] }' | \
# Generate a BED file with the maximum chromosome length 
awk 'OFS=FS="\t" {print $1, "1", $2, "100.0", "100.0"}' > results/${stage}HACk/laser.simple.bed

