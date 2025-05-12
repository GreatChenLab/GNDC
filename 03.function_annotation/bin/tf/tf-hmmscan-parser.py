#!/usr/bin/env python3
##########################################################
# hmmscan parser for dbCAN meta server
#
# Based off the hmmscan parser used in the dbCAN server,
# written by Dr. Yin
#
# Written by Tanner Yohe under the supervision
# of Dr. Yin in the YinLab at NIU.
#
# Updated by Le Huang from tips the contributor WATSON Mick <mick.watson@roslin.ed.ac.uk>,
# Thank you!
#
# INPUT
# python hmmscan-parser-dbCANmeta.py [inputFile] [eval] [coverage]
# eval and coverage are optional, inputFile is required
# -updating info:
# -adds pid for every subprocess to make codes robust.
# Last updated: 1/10/19
###########################################################


from subprocess import call
import sys
import os
import re

eval = 1e-15
coverage = 0.35

if len(sys.argv) > 1:
	inputFile = sys.argv[1]
else:
	print ("Please give a hmmscan output file as the first command")
	exit()

if len(sys.argv) > 3:
	eval = float(sys.argv[2])
	coverage = float(sys.argv[3])

tmpfile = "temp." + str(os.getpid())

call("cat "+inputFile+"  | grep -v '^#' | awk '{print $1,$3,$4,$6,$13,$16,$17,$18,$19,$2}' | sed 's/ /\t/g' | sort -k 3,3 -k 8n -k 9n | perl -e 'while(<>){chomp;@a=split;next if $a[-1]==$a[-2];push(@{$b{$a[2]}},$_);}foreach(sort keys %b){@a=@{$b{$_}};for($i=0;$i<$#a;$i++){@b=split(/\t/,$a[$i]);@c=split(/\t/,$a[$i+1]);$len1=$b[-1]-$b[-2];$len2=$c[-1]-$c[-2];$len3=$b[-1]-$c[-2];if($len3>0 and ($len3/$len1>0.5 or $len3/$len2>0.5)){if($b[4]<$c[4]){splice(@a,$i+1,1);}else{splice(@a,$i,1);}$i=$i-1;}}foreach(@a){print $_.\"\n\";}}' > " + tmpfile, shell=True)

pfam_dsc = {}
with open(inputFile, 'r') as f:
    for line in f:
        if line.startswith('#'):
            continue
        col = re.split('\s+', line.strip(), 22)
        #pfam_dsc[col[1]] = col[-1]
        pfam_dsc[col[0]] = 'http://planttfdb.gao-lab.org/family.php?fam=%s'%(col[0])

with open(tmpfile) as f:
	print('SeqID\tSeqLength\tAccession\tTfFamily\tProfileLength\tEValue\tProfileStart\tProfileEnd\tSeqStart\tSeqEnd\tCoverage\tDescription')
	for line in f:
		row = line.rstrip().split('\t')
		row.append(float(int(row[6])-int(row[5]))/int(row[1]))
		if float(row[4]) <= eval and float(row[-1]) >= coverage:
			#print(len(row))
			new_row = []
			new_row.append(row[2])
			new_row.append(row[3])
			new_row.append(row[9])
			new_row.append(row[0])
			new_row.append(row[1])
			new_row.append(row[4])
			new_row.append(row[5])
			new_row.append(row[6])
			new_row.append(row[7])
			new_row.append(row[8])
			new_row.append(row[10])
			if row[0] in pfam_dsc:
				new_row.append(pfam_dsc[row[0]])
			else:
				new_row.append('-')
			new_new_row = []
			for j in new_row:
				if str(j).strip() == '':
					new_new_row.append('-')
				else:
					new_new_row.append(str(j))
			print('\t'.join([str(x) for x in new_new_row]))

call(['rm', tmpfile])
