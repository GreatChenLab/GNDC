import sys
import os
if sys.argv[1] == '-h' or sys.argv[1] == '-help' or sys.argv[1] == '--h' or sys.argv[1] == '--help':
	print('python3 %s <kobas.xls> <KoPathways.txt> <PathwayHtext.txt> <K_info.txt> <kegg.xls> <pathway.xls>'%(sys.argv[0]))
	exit(0)
K_info = {}
with open(sys.argv[4],'r') as f:
	for line in f:
		l = line.strip()
		if not l.startswith('ENTRY'):
			ll = l.split('\t')
			K_info[ll[0]] = [ll[1],ll[2]]
K_ko = {}
with open(sys.argv[2],'r') as f:
	for line in f:
		l = line.strip()
		ll = l.split('\t')
		if ll[0] not in K_ko:
			K_ko[ll[0]] = []
		K_ko[ll[0]].append(ll[1])
ko_info = {}
with open(sys.argv[3],'r') as f:
	for line in f:
		l = line.strip()
		ll = l.split('\t')
		ko_info[ll[2]] = [ll[0],ll[1],ll[3]]
id2K = {}
id2ko = {}
flag = 0 
with open(sys.argv[1],'r') as f:
	for line in f:
		l = line.strip()
		if l != '' and not l.startswith('#'):
			if '--------------------' in l:
				flag = 1
			else:
				if flag == 0:
					ll = l.split('\t')
					if ll[1] != 'None':
						if ll[1].split('|')[0] in K_info:
#							if ll[1].split('|')[0] in K_ko:
#								if ll[0] not in id2K:
#									id2K[ll[0]] = ll[1].split('|')[0]
							if ll[0] not in id2K:
								id2K[ll[0]] = []
							id2K[ll[0]].append(ll[1].split('|')[0])
for i in id2K:
	for j in id2K[i]:
		if j in K_ko:
			#if i not in id2ko:
			#	id2ko[i] = []
			for z in K_ko[j]:
				if z in ko_info:
					if i not in id2ko:
						id2ko[i] = []
					id2ko[i].append(z)
with open(sys.argv[5],'w') as f:
	f.write('SeqID\tAccession\tAnnotation\n')
	for i in id2K:
		for j in id2K[i]:
			f.write(i+'\t'+j+'\t'+'`'.join(K_info[j])+'\n')
with open(sys.argv[6],'w') as f:
	f.write('SeqID\tA\tB\tC\tPathwayID\n')
	for i in id2ko:
		for j in id2ko[i]:
			f.write(i+'\t'+'\t'.join(ko_info[j])+'\t'+j+'\n')
