import sys
import os
with open(sys.argv[1],'r') as f,open(sys.argv[2],'w') as fw:
	for line in f:
		l = line.strip()
		if l != '':
			if l.startswith('#'):
				fw.write(l+'\n')
			else:
				ll = l.split('\t')
				if int(ll[3]) > int(ll[4]):
					tmp = ll[3]
					ll[3] = ll[4]
					ll[4] = tmp
				fw.write('\t'.join(ll)+'\n')
