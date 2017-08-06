# Align synthetic reads to chr9/chr22 reference
# and write to BAM file

source ./BPS_Stage.config

mkdir -p $OUTD/BWA

function process {
    DAT1=$1
    DAT2=$2
    REF=$3
    OUT=$4

# bwa mem [options] <idxbase> <in1.fq> [in2.fq]
    CMD="$BWA mem $REF $DAT1 $DAT2" 

    echo Executing: $CMD
    echo Writing to $OUT

    # samtools view -b converts output to BAM file

    $CMD | samtools view -bT $REF | samtools sort -o $OUT
    samtools index $OUT
}

DAT1="$OUTD/synthetic.reads1.fq"
DAT2="$OUTD/synthetic.reads2.fq"
REF="$BPS_DATA/A_Reference/dat/reference.chr9_chr22.fa"
OUT="$OUTD/synthetic.BWA.bam"

process $DAT1 $DAT2 $REF $OUT

