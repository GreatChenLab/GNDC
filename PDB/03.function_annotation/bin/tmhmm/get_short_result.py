import sys
with open(sys.argv[1],'r') as f1,open(sys.argv[2],'w') as f2:
	f2.write('ID\tLen\tExpAA\tFirst60\tPredHel\tTopology\n')
	for line in f1:
		if line.strip() != '':
			ll = line.strip().split('\t')
			for i in range(1,len(ll)):
				ll[i] = ll[i].split('=')[1]
			f2.write('\t'.join(ll)+'\n')
