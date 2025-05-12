import sys
with open(sys.argv[1],'r') as f1,open(sys.argv[2],'w') as f2:
	f2.write('ID\tLocation\tMembrane\tNucleus\tCytoplasm\tExtracellular\tMitochondrion\tCell_membrane\tEndoplasmic_reticulum\tPlastid\tGolgi_apparatus\tLysosome/Vacuole\tPeroxisome\n')
	for line in f1:
		f2.write(line)
