import sys,os

if len(sys.argv) != 5:
	print("python %s tmp.emapper.annotations /annotation/uniprot/cog.txt /annotation/uniprot/CogClass.txt cog.xls" %sys.argv[0])
	exit(1)

with open(sys.argv[3], 'r') as f : lines = [i.strip().split('\t') for i in f.readlines()]
cogClass = {CogClassCode:CogClassName for CogClassCode,CogClassName in lines}

with open(sys.argv[2], 'r', encoding='utf-8') as f : lines = [i.strip().split('\t') for i in f.readlines()]
cog = {}
for line in lines:
	cogId,CogClassCode,CogName = line
	cog[cogId] = (CogClassCode,CogName)
if os.path.basename(sys.argv[2]).startswith('cog'):
	out = 'SeqID\tCogID\tCogName\tCogClassName\tCogClassCode\n'
else:
	out = 'SeqID\tKogID\tKogName\tKogClassName\tKogClassCode\n'
with open(sys.argv[1], 'r') as f :
	for line in f:
		if "#" in line : continue
		lst = line.split('\t')
		seqid = lst[0]
		cogId = lst[4].split('@')[0]
		if not cogId or not cogId in cog : continue
		for code in cog[cogId][0]:
			out += '%s\t%s\t%s\t%s\t%s\n' %(seqid,cogId,cog[cogId][1],cogClass[code],code)

with open(sys.argv[4], 'w', encoding='utf-8') as w : w.write(out)
