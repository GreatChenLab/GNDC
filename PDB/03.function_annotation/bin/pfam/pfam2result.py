#!/usr/bin/env python 

import re
import subprocess

from optparse import OptionParser
parser = OptionParser()
parser.add_option("-f", "--file", dest="pfam", metavar='FILE',
                 help="pfam output")
parser.add_option("-e", "--evalue", dest='e', type="float", default=0.01,
                 help='evalue cut off [default: %default]')
parser.add_option("-o", "--output", dest='out_pfam', default='pfam.txt',
                 help='pfam output name [default: %default]')
(options, args) = parser.parse_args()

pfam_out = open(options.out_pfam, 'w')
e_cutoff = float(options.e)
with open(options.pfam, 'r') as f:
    for line in f:
        if line.startswith('#'):
            continue
        col = re.split('\s+', line.strip(), 22)
        if float(col[6]) < e_cutoff:
            pfam_out.write('{}\t{}\t{}\t{}\n'.format(col[3], col[1], col[0], col[-1]))
pfam_out.close()

p = subprocess.Popen(["sort", "-u", options.out_pfam], stdout=subprocess.PIPE)
output, err = p.communicate()
with open(options.out_pfam, 'w') as f:
    f.write('SeqID\tAccession\tPfamDomainname\tPfamDomainDescription\n')
    f.write(output)

