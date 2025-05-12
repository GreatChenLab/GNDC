import sys
ready_in = {}
with open(sys.argv[1],'r') as f1,open(sys.argv[2],'w') as f2:
	f2.write('SeqID\tTfFamily\tTfFamilyLink\n')
	for line in f1:
		l = line.strip().split('\t')
		if line.strip() != '' and not line.strip().startswith('#'):
			#f2.write('Seq_id\tTF family\tTF family link\n')
			if  not in ready_in:
				ready_in[l[0]] = ''
				f2.write(l[0]+'\t'+l[-1].split('|')[1]+'\t'+'http://planttfdb.gao-lab.org/family.php?fam='+l[-1].split('|')[1]+'\n')
