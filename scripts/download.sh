file=$1
outdir=$2

# Download a file in an outdir
wget -nc -P $outdir $file

# Descompress the file
gunzip -vfk "$outdir/$(basename $file)"
