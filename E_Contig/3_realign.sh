# Realign contigs generated by Tigra-SV to reference
# Based on work here: /gscmnt/gc7210/dinglab/medseq/Users/mwyczalk/Virus/Virus_2013.9a/analysis/UnifiedVirus2/S_TigraExt

# Support provided for cluster queuing system (bsub)
# Turn on queuing by uncommenting line below
USE_BSUB=1

source ./Contig.config
#OUT="$OUTD/TCGA_Virus.Pindel_RP.dat"
BWA="/usr/bin/bwa0.7.10 mem"

LIST="$BPS_DATA/A_Project/dat/TCGA_Virus.samples.dat"

mkdir -p $OUTD/BWA
if [ ! -z $USE_BSUB ]; then
# using bsub
mkdir -p bsub
fi  

while read l; do  # iterate over all rows of TCGA_Virus.samples.dat 

# Skip comments and header
[[ $l = \#* ]] && continue
[[ $l = barcode* ]] && continue

# assume RP file exists for all samples.  Can create test to make sure this is true, skip if not.
BAR=`echo $l | awk '{print $1}'`
FASTA=`echo $l | awk '{print $3}'`

DAT="$OUTD/$BAR.contig"
OUT="$OUTD/BWA/$BAR.sam"

CMD="$BWA $FASTA $DAT" 

if [ -z $USE_BSUB ]; then
    echo Executing: $CMD
    $CMD > $OUT
else
    bsub -e bsub/$BAR.3.bsub -o $OUT $CMD   # this appends bsub output to SAM file.  For now, clean manually
fi  

done < $LIST