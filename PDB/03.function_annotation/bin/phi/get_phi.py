import sys
import os
with open(sys.argv[1],'r') as f,open(sys.argv[2],'w') as fw:
	fw.write('SeqID\tPident\tQcovs\tProteinID\tPhiID\tPathogenGene\tPathogenSpecies\tMutantPhenotype\n')
	for line in f:
		l = line.strip()
		if l != '' and not l.startswith('#'):
			ll = l.split('\t')
			aa = ll[-1].split('#')
			fw.write(ll[0]+'\t'+ll[2]+'\t'+ll[3]+'\t'+'\t'.join([aa[0],aa[1],aa[2],aa[4],aa[5]])+'\n')