import sys
import os
line_num = 0
with open(sys.argv[1],'r',encoding='utf-8') as f:
	for line in f:
		l = line.strip()
		if l != '':
			line_num += 1
if line_num > 1:
	os.system(sys.argv[2])
else:
	if sys.argv[2].endswith('kog'):
		os.system('cp %s/kog.svg %s/kog.pdf %s/kog.png ./'%(sys.argv[3],sys.argv[3],sys.argv[3]))
	else:
		os.system('cp %s/cog.svg %s/cog.pdf %s/cog.png ./'%(sys.argv[3],sys.argv[3],sys.argv[3]))