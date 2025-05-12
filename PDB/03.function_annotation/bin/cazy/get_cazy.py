import sys
import os
all_info = {}
type_class = {}
class_info = {}
with open(sys.argv[1],'r') as fr:
	for line in fr:
		l = line.strip()
		if l != '' and not l.startswith('#'):
			ll = l.split('\t')
			all_info[ll[0]] = '\t'.join(ll[1:])
			class_info[ll[1]] = ll[2]
			type_class[ll[0]] = ll[1]
type_num = {'GHs':0,'GTs':0,'PLs':0,'CEs':0,'AAs':0,'CBMs':0}
with open(sys.argv[2],'r') as fr,open(sys.argv[3],'w') as fw:
	fw.write('SeqID\tDomain\tClass\tClassInfo\tDomainDescription\n')
	for line in fr:
		l = line.strip()
		if l != '' and not l.startswith('#'):
			ll = l.split('\t')
			if ll[2] in all_info:
				fw.write('%s\t%s\t%s\n'%(ll[0],ll[2],all_info[ll[2]]))
				type_num[type_class[ll[2]]] += 1
with open(sys.argv[4],'w') as f:
	f.write('Class\tNum\tDescrition\n')
	for j in ['GHs','GTs','PLs','CEs','AAs','CBMs']:
		f.write(j+'\t'+str(type_num[j])+'\t'+class_info[j]+'\n')

