import sys
import os
import glob
aa = glob.glob('*GI_all.txt')
GG_num = 0
aa_dict = {}
with open(sys.argv[2],'r') as fr:
	for line in fr:
		l = line.strip()
		if l != '':
			ll = l.split('\t')
			aa_dict[ll[0]] = ll[1]
with open(sys.argv[1],'w') as fw:
	fw.write('GI_ID\tSeq_ID\tStart\tEnd\tGI_Length\n')
	for j in aa:
		with open(j,'r') as f:
			for line in f:
				if line.strip() != '':
					GG_num += 1
					ll = line.strip().split('\t')
					ll[0] = 'GI%s'%(str(GG_num))
					if ll[1] in aa_dict:
						ll[1] = aa_dict[ll[1]]
					fw.write('\t'.join(ll)+'\n')