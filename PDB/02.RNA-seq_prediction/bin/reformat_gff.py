import sys
import os
cds_num = 0
with open(sys.argv[1],'r') as f,open(sys.argv[2],'w') as fw:
	for line in f:
		l = line.strip()
		if l != '' and not l.startswith('#'):
			ll = l.split('\t')
			if '^' in ll[-1]:
				ll[-1] = ll[-1].split('^')[0]
			if ll[2] == 'CDS':
				cds_num += 1
				ll[-1] = ll[-1].replace('ID=cds','ID=cds'+str(cds_num))
			fw.write('\t'.join(ll)+'\n')
