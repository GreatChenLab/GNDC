import sys
with open(sys.argv[1],'r') as f1,open(sys.argv[2],'w') as f2:
	f2.write('ID\tPrediction\tSP(Sec/SPI)\tOTHER\tCS Position\n')
	for line in f1:
		if not line.startswith('#'):
			l = line.strip('\n')
			if l != '':
				ll = l.split('\t')
				if ll[-1] == '':
					ll[-1] = '-'
				f2.write('\t'.join(ll)+'\n')
