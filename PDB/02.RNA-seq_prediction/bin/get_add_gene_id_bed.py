import sys
import os
tran_gene = {}
with open(sys.argv[1],'r') as f:
	for line in f:
		l = line.strip()
		if l != '' and not l.startswith('#'):
			ll = l.split('\t')
			trans_id = ll[-1].split('transcript_id')[1].split(';')[0].strip().replace('"','')
			genes_id = ll[-1].split('gene_id')[1].split(';')[0].strip().replace('"','')
			tran_gene[trans_id] = genes_id+';'+trans_id
with open(sys.argv[2],'r') as f,open(sys.argv[3],'w') as fw:
	for line in f:
		l = line.strip('\n')
		if l != '' and not l.startswith('#'):
			ll = l.split('\t')
			ll[3] = tran_gene[ll[3]]
			fw.write('\t'.join(ll)+'\n')
