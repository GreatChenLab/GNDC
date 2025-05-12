import sys
import os
with open(sys.argv[1],'r') as f,open(sys.argv[2],'w') as fw:
	fw.write('SeqID\tPident\tQcovs\tAccession\tAnnotation\n')
	for line in f:
		l = line.strip()
		if l != '' and not l.startswith('#'):
			ll = l.split('\t')
			fw.write(ll[0]+'\t'+ll[2]+'\t'+ll[3]+'\t'+ll[1]+'\t'+' '.join(ll[-1].split(' ')[1:])+'\n')
