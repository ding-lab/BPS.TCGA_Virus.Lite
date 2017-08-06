# Create GGP objects with read depth information
#   two files for every row in PlotList

source ./BPS_Stage.config

DATD="$BPS_DATA/K_ReadDepth/dat"

BIN="$BPS_CORE/src/plot/DepthDrawer.R"

OUTDD="$OUTD/GGP.Depth"
mkdir -p $OUTDD

rm -f $OUTD/GGP  # GGP is a link
ln -s $OUTDD $OUTD/GGP

# We are not normalizing the read depth to obtain copy number, since flagstat-based calculations
# are not appropriate on Synthetic data.
# FLAGSTAT="$DATD/flagstat.dat"

# usage: process_chrom CHROM_ID BAR NAME CHROM RANGE_START RANGE_END
# CHROM_ID is either A or B
function process_chrom {
    CHROM_ID=$1
    BAR=$2
    NAME=$3
    CHROM=$4
    START=$5
    END=$6

    DEP="$DATD/${BAR}/${NAME}.${CHROM_ID}.DEPTH.dat"

    OUTDDD="$OUTDD/$BAR"
    mkdir -p $OUTDDD

    OUT="$OUTDDD/${NAME}.${CHROM_ID}.depth.ggp"

    ARGS=" -M ${CHROM}:${START}-${END} "
    if [ ! -z $FLAGSTAT ] && [ -f $FLAGSTAT ]; then  # If flagstat file is defined and it exists...
        # barcode	filesize	read_length	reads_total	reads_mapped
        # TCGA-DX-A1KU-01A-32D-A24N-09	163051085994	100	2042574546	1968492930
        NUMREADS=`grep $BAR $FLAGSTAT | cut -f 5`  # using number of mapped reads
        READLEN=`grep $BAR $FLAGSTAT | cut -f 3`


        # Recall, from "$BPS_CORE/src/plot/DepthDrawer.R":
            # if both num.reads and read.length are defined (-u -n) then plot copy number
            #   otherwise, plot read depth
        ARGS=" $ARGS -u $NUMREADS -n $READLEN "
    fi

    COLOR="-a 0.1 -s 16"

    if [ $CHROM_ID == 'B' ]; then
        ARGS="$ARGS -B"
    fi
    if [ $FLIPAB == 1 ]; then    # defined in ../bps.config
        ARGS="$ARGS -l"
    fi

    Rscript $BIN $ARGS $COLOR -p depth $DEP $OUT
}

while read l; do  
# barcode name    chrom.A event.A.start   event.A.end range.A.start   range.A.end chrom.B event.B.start   event.B.end range.B.start   range.B.end
# TCGA-IS-A3KA-01A-11D-A21Q-09    TCGA-IS-A3KA-01A-11D-A21Q-09.chr_1_2.aa 1   5156542 207193935   5106542 207243935   2   122476446   228566993   122426446   228616993

# Skip comments and header
[[ $l = \#* ]] && continue
[[ $l = barcode* ]] && continue

# extract sample names
BAR=`echo "$l" | cut -f 1`
NAME=`echo "$l" | cut -f 2`     

A_CHROM=`echo "$l" | cut -f 3`
A_START=`echo "$l" | cut -f 6`
A_END=`echo "$l" | cut -f 7`

B_CHROM=`echo "$l" | cut -f 8`
B_START=`echo "$l" | cut -f 11`
B_END=`echo "$l" | cut -f 12`

process_chrom A $BAR $NAME $A_CHROM $A_START $A_END
process_chrom B $BAR $NAME $B_CHROM $B_START $B_END

done < $PLOT_LIST

