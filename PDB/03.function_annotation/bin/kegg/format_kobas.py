import sys
import os
if sys.argv[1] == '-h' or sys.argv[1] == '-help' or sys.argv[1] == '--h' or sys.argv[1] == '--help':
	print('python3 %s <kobas.xls> <tmp_kobas.xls>'%(sys.argv[0]))
	exit(0)
flag = 0 
with open(sys.argv[1],'r') as f,open(sys.argv[2],'w') as fw:
	for line in f:
		l = line.strip()
		if l != '' and not l.startswith('#'):
			if '--------------------' in l:
				flag = 1
			else:
				if flag == 0:
					fw.write(line)