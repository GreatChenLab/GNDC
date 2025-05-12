import sys
import os
if sys.argv[2] == 'None':
	os.system('%s'%(sys.argv[1]))
	os.system("echo '##gff-version 3' > crisprs.gff3")
	os.system("echo -e '#seqid\tsource\ttype\tstart\tend\tscore\tstrand\tphase\tattributes' >> crisprs.gff3")
	os.system("grep -v '#' gff3 >> crisprs.gff3")
else:
	os.system('%s'%(sys.argv[1]))
	os.system("echo '##gff-version 3' > %s.crisprs.gff3"%(sys.argv[2]))
	os.system("echo -e '#seqid\tsource\ttype\tstart\tend\tscore\tstrand\tphase\tattributes' >> %s.crisprs.gff3"%(sys.argv[2]))
	os.system("grep -v '#' gff3 >> %s.crisprs.gff3"%(sys.argv[2]))
