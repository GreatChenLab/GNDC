import sys
import os
with open(sys.argv[1],'r') as f,open(sys.argv[2],'w') as fw:
	for line in f:
		l = line.strip()
		if l != '' and not l.startswith('#'):
			ll = l.split('\t')
			if ll[2] != 'CDS' and ll[2] != 'start_codon' and ll[2] != 'stop_codon':
				ll[1] = 'TamaMerge'
				trans = ll[-1].split('transcript_id')[1].split(';')[1].replace('"','').strip()
				genes = ll[-1].split('gene_id')[1].split(';')[0].replace('"','').strip()
				add_info = ''
				if ll[2] == 'exon':
					exon_info = ll[-1].split('exon_number')[1].split(';')[0].replace('"','').strip()
					add_info = ' exon_number "%s";'%(exon_info)
				ll[-1] = 'gene_id "%s"; transcript_id "%s";'%(genes,trans)+add_info
				fw.write('\t'.join(ll)+'\n')
