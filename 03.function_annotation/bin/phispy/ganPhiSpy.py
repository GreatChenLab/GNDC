import sys
import os
cmd = sys.argv[1]
aa = os.system(cmd)
if aa != 0:
	os.system('mkdir -p phispy_out')
	os.system('touch phispy_out/prophage_coordinates.tsv')
	os.system('touch phispy_out/prophage.tbl')