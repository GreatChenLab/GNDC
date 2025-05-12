import sys
import os
import re
all_in = {}
with open(sys.argv[1],'r') as f,open(sys.argv[2],'w') as fw:
	for line in f:
		l = line.strip()
		if l != '' and not l.startswith('#'):
			ll = re.split('\s+',l)
			if ll[3] not in all_in:
				all_in[ll[3]] = 0
			all_in[ll[3]] += 1
			if all_in[ll[3]] < 2:
				fw.write(ll[3]+'\t'+ll[0]+'\n')
