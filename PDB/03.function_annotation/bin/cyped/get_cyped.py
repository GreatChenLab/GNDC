import sys
import os
check_list = ['sid','pid','hfid','sfid','gi','taxonID']
with open(sys.argv[1],'r') as f,open(sys.argv[2],'w') as fw:
	fw.write('ID\tPident\tQcovhsp\tSequenceID\tProteinID\tHomologousFamilies\tSuperfamilies\tGI\tTaxonID\tSpecies\n')
	for line in f:
		l = line.strip()
		if l != '' and not l.startswith('#'):
			ll = l.split('\t')
			zz = ll[-1].split('|')
			aa = zz[:-1]
			pp = {}
			if len(aa)%2 != 1:
				bb = []
				cc = []
				for i in range(len(aa)):
					if i%2 == 0:
						bb.append(aa[i])
					else:
						cc.append(aa[i])
				dd = dict(zip(bb,cc))
			else:
				bb = []
				cc = []
				for i in range(len(aa)-1):
					if i%2 == 0:
						bb.append(aa[i])
					else:
						cc.append(aa[i])
				dd = dict(zip(bb,cc))
			type(dd)
			for j in check_list:
				if j not in dd:
					dd[j] = '-'
			tt = [dd['sid'],dd['pid'],dd['hfid'],dd['sfid'],dd['gi'],dd['taxonID']]
			fw.write(ll[0]+'\t'+ll[2]+'\t'+ll[3]+'\t'+'\t'.join(tt)+'\t'+zz[-1]+'\n')
