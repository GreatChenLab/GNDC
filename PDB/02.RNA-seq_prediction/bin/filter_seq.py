import sys
import os
all_pep = {}
with open(sys.argv[1],'r') as f:
	for line in f:
		l = line.strip()
		if l.startswith('>'):
			aa = l
			all_pep[aa] = ''
		else:
			all_pep[aa] += l
use_pep = {}
with open(sys.argv[2],'w') as f:
	for i in all_pep:
		if all_pep[i] != '' and '.' not in all_pep[i] and 'X' not in all_pep[i]:
			use_pep[i] = all_pep[i]
			f.write(i+'\n')
			f.write(all_pep[i]+'\n')
flag = 0
with open(sys.argv[3],'r') as f,open(sys.argv[4],'w') as fw:
	for line in f:
		l = line.strip()
		if l.startswith('>'):
			aa = l
			if aa in use_pep:
				flag = 0
				fw.write(aa+'\n')
			else:
				flag = 1
		else:
			if flag != 1:
				fw.write(l+'\n')
