# Generate PlotList by hand.  This supercedes that made by step 3, to focus on two regions of interest and 
# maintain consistent naming scheme.  See README.md for details.
# Note that PLOT_LIST is defined in ../bps.config

source ./BPS_Stage.config

cat <<EOF | sort | tr ' ' '\t' > $PLOT_LIST
barcode name chrom.A event.A.start event.A.end range.A.start range.A.end chrom.B event.B.start event.B.end range.B.start range.B.end
NA19240 NA19240.AQ.chr10_chr20 chr10 41854249 41915847 41804249 41965847 chr20 31051980 31241883 31001980 31291883
NA19240 NA19240.AU.chr13_chr17 chr13 62947705 63061713 62897705 63111713 chr17 22124735 22180085 22074735 22230085
EOF

echo Written to $PLOT_LIST
