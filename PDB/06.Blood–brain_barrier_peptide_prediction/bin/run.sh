infile=$1
outfile=$2

python deepB3P/predict_user.py $infile $outfile &

PID=$!
pidstat -p $PID 1 -u -r > script_monitor.log &
MONITOR_PID=$!
wait $PID
kill $MONITOR_PID 2>/dev/null

sed 's|,|\t|g' $outfile > $outfile.tab

seqkit fx2tab -l -H $infile > $outfile.length

awk 'BEGIN{FS=OFS="\t"} ARGIND==1{a[$1]=$2} ARGIND==2{if($2 in a){print $1,$2,$4,a[$2]}}' $outfile.tab $outfile.length | sort -t "	" -k 4 -nr | sed '1i name\tseq\tlength\tprot' > $outfile.final.txt



