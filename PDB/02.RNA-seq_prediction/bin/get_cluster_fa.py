import sys
import os
if sys.argv[1].endswith('.gz'):
	aa = os.system("gunzip -c %s > %s"%(sys.argv[1],sys.argv[2]))
else:
	aa = os.system("cp %s %s"%(sys.argv[1],sys.argv[2]))
if aa != 0:
	exit(2)