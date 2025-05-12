import sys
with open(sys.argv[1],'r') as f1,open(sys.argv[2],'w') as f2,open(sys.argv[3],'w') as f3:
	for line in f1:
		if line.startswith('#'):
			if "Organism: gram-" in line or "Organism: gram+" in line:
				f2.write('ID\tPrediction\tSP(Sec/SPI)\tTAT(Tat/SPI)\tLIPO(Sec/SPII)\tOTHER\tCS Position\n')
				f3.write('ID\tPrediction\tSP(Sec/SPI)\tTAT(Tat/SPI)\tLIPO(Sec/SPII)\tOTHER\tCS Position\n')
				break
			if "Organism: euk" in line:
				f2.write('ID\tPrediction\tSP(Sec/SPI)\tOTHER\tCS Position\n')
				f3.write('ID\tPrediction\tSP(Sec/SPI)\tOTHER\tCS Position\n')
				break
	for line in f1:
		if not line.startswith('#'):
			l = line.strip('\n')
			if l != '':
				ll = l.split('\t')
				if ll[-1] == '':
					ll[-1] = '-'
				f2.write('\t'.join(ll)+'\n')
				if ll[1] != "OTHER":
					f3.write('\t'.join(ll)+'\n')
			
