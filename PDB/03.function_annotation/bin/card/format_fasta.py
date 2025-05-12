import sys
import os
import re
with open(sys.argv[1],'r') as f,open(sys.argv[2],'w') as fw:
	for line in f:
		if line.startswith('>'):
			fw.write(re.split('\s+',line.strip())[0]+'\n')
		else:
			fw.write(line)
