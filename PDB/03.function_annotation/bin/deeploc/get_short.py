import sys
import re
with open(sys.argv[1],'r') as f1,open(sys.argv[2],'w') as f2:
	for line in f1:
		if line.startswith('>'):
			f2.write(re.split('\s+',line)[0]+'\n')
		else:
			f2.write(line)
