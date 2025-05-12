import sys
sp_num = {}
with open(sys.argv[1],'r') as fr,open('Nr_Species_distribution.xls','w') as fw:
	fr.readline()
	for line in fr:
		if line.strip() == '' or line.startswith('#'):
			pass
		else:
			l = line.strip().split('\t')
			if l[-1] not in sp_num:
				sp_num[l[-1]] = 0
			sp_num[l[-1]] += 1
	fw.write('Species\tNumber\n')
	for j in sorted(sp_num.items(), key=lambda item:item[1], reverse=True):
		fw.write('%s\t%d\n'%(j[0],j[1]))
		

