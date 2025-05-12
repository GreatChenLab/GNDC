import sys
import os
with open(sys.argv[1],'r') as f,open(sys.argv[2],'w') as fw:
	for line in f:
		l = line.strip('\n')
		if l != '':
			ll = l.split('\t')
			new_ll = []
			for i in ll:
				if i.strip() == '':
					new_ll.append('-')
				else:
					new_ll.append(i)
			fw.write('\t'.join(new_ll)+'\n')