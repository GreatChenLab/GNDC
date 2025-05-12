import sys
import os
import re
id_dict = {}
with open(sys.argv[1],'r') as f:
	for line in f:
		l = line.strip()
		if l.startswith('>'):
			aa = re.split(r'\s+',l.split('>')[1])[0]
			id_dict[aa] = ''
with open(sys.argv[2],'r') as f,open(sys.argv[3],'w') as fw:
	for line in f:
		l = line.strip()
		if l != '':
			ll = l.split('\t')
			if ll[2] == 'mRNA':
				iid = ll[-1].split('ID=')[1].split(';')[0]
				ll[-1] = 'ID=%s'%(iid)
				if iid in id_dict:
					fw.write('\t'.join(ll)+'\n')
			else:
				iid = ll[-1].split('Parent=')[1].split(';')[0]
				if iid in id_dict:
					fw.write(line)
