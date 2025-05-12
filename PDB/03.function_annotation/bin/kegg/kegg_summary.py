import sys,os

if len(sys.argv) != 6:
	print("python %s kegg.xls KoPathways.txt PathwayHtext.txt id2K_ko.xls kegg_summary.xls" %sys.argv[0])
	exit(1)

infile = sys.argv[1]
KoPathInfoFile = sys.argv[2]
pathWayClassFile = sys.argv[3]

outK = sys.argv[4]
outS = sys.argv[5]

pathWayClassInfo = {}
with open(pathWayClassFile, 'r') as f : lines = [i.strip().split('\t') for i in f.readlines() if i.strip()]
for line in lines:
	c1,c2,k0id,c3 = line
	pathWayClassInfo[k0id] = "%s\t%s\t%s" %(c1,c2,c3)

KoInfo = {}
with open(KoPathInfoFile, 'r') as f : lines = [i.strip().split('\t') for i in f.readlines() if i.strip()]
for line in lines:
	Ko,k0id = line
	if not Ko in KoInfo : KoInfo[Ko] = []
	KoInfo[Ko].append(k0id)

outKText = 'SeqID\tK_num\tko_num\n'
outSText = 'SeqID\tKoID\tGene\tPathwayID\tClassI\tClassII\tClassIII\n'

with open(infile, 'r') as f:
	for line in f:
		if line.startswith('SeqID') : continue
		gid,Koid,Koname = line.strip().split('\t')
		if Koid in KoInfo:
			for k0id in KoInfo[Koid]:
				if k0id in pathWayClassInfo:
					outKText += "%s\t%s\t%s\n" %(gid, Koid, k0id)
					outSText += "%s\t%s\t%s\t%s\t%s\n" %(gid, Koid, Koname, k0id, pathWayClassInfo[k0id])
				else:
					print(" %s do not has classinfo" %k0id)

with open(outK, 'w') as w : w.write(outKText)
with open(outS, 'w') as w : w.write(outSText)