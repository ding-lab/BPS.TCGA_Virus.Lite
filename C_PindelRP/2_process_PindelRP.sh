# Process Pindel RP data into BPR file

# Writes dat/BAR.PindelRP.BPR.dat for each sample

source ./PindelRP.config

DATA_LIST="$OUTD/TCGA_Virus.Pindel_RP.dat"
BIN="$BPS_CORE/src/analysis/Pindel_RP.Reader.R"
echo Data list: $DATA_LIST
echo \$BIN: $BIN

while read l; do
[[ $l = \#* ]] && continue
[[ $l = barcode* ]] && continue

BAR=`echo $l | awk '{print $1}'`
PIN_FN=`echo $l | awk '{print $2}'`   

ARGS="-S" 
OUT="$OUTD/${BAR}.PindelRP.BPR.dat"

# keep only first 12 columns of Pindel_RP file
#cut -f 1-12 $PIN_FN | Rscript $BIN $ARGS stdin $OUT
cut -f 1-12 $PIN_FN | Rscript $BIN $ARGS stdin $OUT

echo Written to $OUT

done < $DATA_LIST
