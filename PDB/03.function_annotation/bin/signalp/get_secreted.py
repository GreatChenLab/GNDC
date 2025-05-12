import sys
tt_dict = {}
with open(sys.argv[1],'r') as f:
	f.readline()
	for line in f:
		if line.strip() != '':
			ll = line.split('\t')[0]
			tt_dict[ll] = ''
with open(sys.argv[2],'r') as f,open(sys.argv[3],'w') as fw:
	fw.write('ID\n')
	f.readline()
	for line in f:
		if line.strip() != '':
			ll = line.split('\t')[0]
			if ll not in tt_dict:
				fw.write(ll+'\n')