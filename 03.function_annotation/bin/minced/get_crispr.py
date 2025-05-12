import sys
import os
with open(sys.argv[1],'r') as f,open(sys.argv[2],'w') as fw:
	fw.write('seqid\ttype\tstart\tend\tscore\tcrispr_id\trpt_unit_seq\n')
	for line in f:
		if line.strip() != '' and not line.startswith('#'):
			l = line.strip()
			ll = l.split('\t')
			line_list = [ll[0],ll[2],ll[3],ll[4],ll[5]]
			iid = ll[-1].split('ID=')[1].split(';')[0]
			kk_seq = ll[-1].split('rpt_unit_seq=')[1].split(';')[0]
			line_list.append(iid)
			line_list.append(kk_seq)
			fw.write('\t'.join(line_list)+'\n')
