import sys
import os

with open(sys.argv[1],'r') as f,open(sys.argv[2],'w') as fw:
	for line in f:
		l = line.strip()
		if l != '':
			if line.startswith('#'):
				fw.write(line)
			else:
				ll = l.split('\t')
				if ll[6] == ".":
					ll[6] = '+'
				fw.write('\t'.join(ll)+'\n')
