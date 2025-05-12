import sys
import os
pp_info = {}
type_info = {}
seq_type = {}
fuck_pnum = {}
with open(sys.argv[1],'r') as f:
	for line in f:
		l = line.strip()
		if l != '' and not l.startswith('#'):
			ll = l.split('\t')
			if ll[1].strip() != '':
				pp_info[ll[0]] = [ll[1],ll[2],ll[4],ll[5]]
				seq_type[ll[0]] = ll[1]
				type_info[ll[1]] = [ll[2],ll[4],ll[5]]
				fuck_pnum[ll[0]] = float(ll[3])
type_aa = {}
with open(sys.argv[2],'r') as fr,open(sys.argv[3],'w') as fw:
	fw.write('SeqID\tProteinID\tPident\tQcovs\tResistanceType\tDescription\tResistanceProfile\tRequire\n')
	for line in fr:
		l = line.strip()
		if l != '' and not l.startswith('#'):
			ll = l.split('\t')
			if ll[1] in pp_info:
				if float(ll[2]) > fuck_pnum[ll[1]]:
					if seq_type[ll[1]] not in type_aa:
						type_aa[seq_type[ll[1]]] = []
					type_aa[seq_type[ll[1]]].append(ll[0])
					fw.write(ll[0]+'\t'+ll[1]+'\t'+ll[2]+'\t'+ll[3]+'\t'+'\t'.join(pp_info[ll[1]])+'\n')
with open(sys.argv[4],'w') as fw:
	fw.write('ResistanceType\tDescription\tResistanceProfile\tRequire\tSeqList\tNum\n')
	for j in type_aa:
		fw.write(j+'\t'+'\t'.join(type_info[j])+'\t'+','.join(type_aa[j])+'\t'+str(len(type_aa[j]))+'\n')
