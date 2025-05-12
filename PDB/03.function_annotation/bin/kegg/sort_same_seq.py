import sys
import os
import re
aa = {}
flag = 1
with open(sys.argv[1],'r') as f,open(sys.argv[2],'w') as fw:
    for line in f:
        l = line.strip()
        if l.startswith('>'):
            bb = re.split(r'\s+',l)[0]
            if bb not in aa:
                aa[bb] = ''
                fw.write(l+'\n')
                flag = 0
            else:
                flag = 1
        else:
            if flag == 0:
                fw.write(l+'\n')
