import sys
use_result = {}
with open(sys.argv[3],'r') as f:
	for line in f:
		l = line.strip()
		if l != '' and not l.startswith('Species'):
			ll = line.split('\t')
			if ll[3].strip() != '':
				aa = ll[4].split(';')
				for i in aa:
					if i.strip() != '':
						if ll[0].strip() != '':
							use_result[i.strip()] = ['https://guolab.wchscu.cn/AnimalTFDB4/#/detail/TF/%s/%s'%(ll[0].strip(),ll[3].strip()),ll[3].strip()]
						else:
							use_result[i.strip()] = ['https://guolab.wchscu.cn/AnimalTFDB4/#/family_summary/TF/%s'%(ll[3].strip()),ll[3].strip()]
with open(sys.argv[1],'r') as f1,open(sys.argv[2],'w') as f2:
	f2.write('SeqID\tTfFamily\ttDescription\n')
	for line in f1:
		l = line.strip().split('\t')
		if line.strip() != '' and not line.strip().startswith('#'):
			#f2.write('Seq_id\tTF family\tTF family link\n')
			if l[1] in use_result:
				f2.write(l[0]+'\t'+use_result[l[1]][1]+'\t'+use_result[l[1]][0]+'\n')
