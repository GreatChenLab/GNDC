import sys
import os
#1: Channels/Pores
#2: Electrochemical Potential-driven Transporters
#3: Primary Active Transporters
#4: Group Translocators
#5: Transmembrane Electron Carriers
#8: Accessory Factors Involved in Transport
#9: Incompletely Characterized Transport Systems
type_dict = \
{1:"Channels/Pores",\
2:"Electrochemical Potential-driven Transporters",\
3:"Primary Active Transporters",\
4:"Group Translocators",\
5:"Transmembrane Electron Carriers",\
8:"Accessory Factors Involved in Transport",\
9:"Incompletely Characterized Transport Systems"}
with open(sys.argv[1],'r') as fr,open(sys.argv[2],'w') as fw:
	fw.write('SeqID\tProteinID\tTcdbID\tClass\tDescription\n')
	for line in fr:
		l = line.strip()
		if l != '' and not l.startswith('#'):
			ll = l.split('\t')
			ss3 = ' '.join(ll[-1].replace(' |','|').split(' ')[1:])
			ss1 = ll[-1].replace('\t ',' ').replace(' |','|').split(' ')[0].split('|')[2]
			ss2 = ll[-1].replace('\t ',' ').replace(' |','|').split(' ')[0].split('|')[3]
			ss4 = 'None'
			if ss2[0].isdigit():
				pp = int(ss2[0])
				if pp in type_dict:
					ss4 = type_dict[pp]
			fw.write(ll[0]+'\t'+ss1+'\t'+ss2+'\t'+ss4+'\t'+ss3+'\n')
