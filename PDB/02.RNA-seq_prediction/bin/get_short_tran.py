import sys
import os
import re
seq_dict = {}
max_len = int(sys.argv[1])
min_len = int(sys.argv[2])
with open(sys.argv[3],'r') as f,open(sys.argv[4],'w') as fw:
	for line in f:
		l = line.strip()
		if l != '':
			if l.startswith('>'):
				mid = re.split('\s+',l.split('>')[1])[0]
				seq_dict[mid] = ''
			else:
				seq_dict[mid] += l

	for i in seq_dict:
		if len(seq_dict[i]) <= max_len and len(seq_dict[i]) >= min_len:
			fw.write('>%s\n'%(i))
			fw.write(seq_dict[i]+'\n')
