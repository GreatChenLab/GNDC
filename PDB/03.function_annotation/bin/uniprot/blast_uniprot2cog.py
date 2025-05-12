#!/usr/bin/python3
import re
import subprocess
import os
from optparse import OptionParser
#help
parser = OptionParser()
parser.add_option("-f", "--file", dest="blast",
                 help="uniprot blastx/blastp output, tab splited")
parser.add_option("-r", "--ref", dest='ref',
                 help='table: uniprot id|cog/kog id')
parser.add_option("-n", "--cog_class_name", dest='class_name',
                 help='table: cog/kog class | class annotation')
parser.add_option("-c", "--cog", dest='cog',
                 help='table: cog/kog name|cog/kog class|cog/kog anno')
parser.add_option("-o", "--output", dest='out_cog', default='cog.txt',
                 help='cog/kog output name [default: %default]')
#parser.add_option("-g", "--eggnog", dest='out_egg', default='eggnog.txt', metavar='OUT_EGGNOG',
#                 help='eggnog output name [default: %default]')
(options, args) = parser.parse_args()

class2anno = {}
cog2class = {}
cog2anno = {}
uni2cog = {}

def spline(line):
    """split tab splited line and return a list"""
    return re.split('\t', line.strip())

with open(options.ref, 'r') as f:
    for line in f:
        col = spline(line)
        if col[0] in uni2cog:
            uni2cog[col[0]].add(col[1])
        else:
            uni2cog[col[0]] = set([col[1]])

with open(options.class_name, 'r') as f:
    for line in f:
        col = spline(line)
        class2anno[col[0]] = col[1]

with open(options.cog,'r',encoding='utf-8') as f:
    for line in f:
        col = spline(line)
        cog2class[col[0]] = col[1]
        cog2anno[col[0]] = col[2]

#out_eggnog = open(options.out_egg, 'w',encoding='utf-8')
out_cog = open(options.out_cog, 'w',encoding='utf-8')
#out_eggnog.write("gene_id\tEggNOG\n")
last_gene = ''
with open(options.blast, 'r',encoding='utf-8') as f:
    for line in f:
        if line.strip() != '' and not line.startswith('#'):
            col = spline(line)
            if last_gene == col[0]:
                continue
            last_gene = col[0]
            coln = col[1].split('|')[1]
            if coln in uni2cog:
                egg = uni2cog[coln]
                for i in egg:
    #                out_eggnog.write(col[0]+'\t'+i+'\n')
                    if i in cog2class:
                        for j in cog2class[i]:
                            out_cog.write('{}\t{}\t{}\t{}\t{}\n'.format(col[0], i, cog2anno[i], class2anno[j], j))
                    else:
                        print ("Warning:\t" + i + "\thas no COG/KOG class annotation")
#out_eggnog.close()
out_cog.close()
#(status1, output) = subprocess.getstatusoutput("sort -u %s"%(options.out_cog))
os.system('sort -u %s > %s'%(options.out_cog,'tmp_oog.txt'))
output = open('tmp_oog.txt','r',encoding='utf-8').read()
#p = output1
#p = os.popen("sort -u %s"%(options.out_cog)).read()
#output, err = p.communicate()
if 'kog' in options.ref:
    with open(options.out_cog, 'w',encoding='utf-8') as f:
        f.write("SeqID\tKogID\tKogName\tKogClassName\tKogClassCode\n")
        f.write(output)
else:
    with open(options.out_cog, 'w',encoding='utf-8') as f:
        f.write("SeqID\tCogID\tCogName\tCogClassName\tCogClassCode\n")
        f.write(output)
