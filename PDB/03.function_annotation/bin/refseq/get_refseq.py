import sys
import os
import argparse
from argparse import RawTextHelpFormatter
author ='Pengyu Fan'
mail = 'fanpengyu@alumni.hust.edu.cn'
data = '2021'
version = 'v1.0'
usage='''
author:    {0}
mail:      {1}
data:      {2}
version:   {3}
Description:
    This python script for refseq blast result format. 
Example: 
    python {4} -h
'''.format(author, mail, data, version, __file__[__file__.rfind(os.sep) + 1:])

parser = argparse.ArgumentParser(
    formatter_class=RawTextHelpFormatter,description=usage)
parser.add_argument(
    '-n','--refseq_blast',help='refseq blast result',dest='refseq_blast',required=True,type = str)
parser.add_argument(
    '-o','--output',help='output file',dest='output',default = 'refseq.xls',type = str)
args = parser.parse_args()
gene_refseq_info = {}
#if not os.path.exists(args.output):
#    os.makedirs(args.output)
#outputfile = os.path.join(args.output,'refseq.txt')
with open(args.refseq_blast,'r') as fr,open(args.output,'w') as fw:
    for line in fr:
        if line.strip() == '' or line.startswith('#'):
            pass
        else:
            l = line.strip().split('\t')
            if l[0] not in gene_refseq_info:
                gene_refseq_info[l[0]] = {}
            seq_id = l[1]
            line = line.replace('[+]','').replace('[-]','')
            if '[' in l[-1] and ']' in l[-1]:
                if line.strip().endswith(']'):
                    seq_info = '['.join(' '.join(line.strip().split(' ')[1:]).split('[')[:-1]).strip()
                    seq_sp = line.strip().split('[')[-1].split(']')[0]
                    gene_refseq_info[l[0]][l[1]] = '%s\t%s\t%s\t%s\n'%(l[0],seq_id,seq_info,seq_sp)
                else:
                    seq_info = ' '.join(line.strip().split(' ')[1:])
                    seq_sp = 'None'
                    gene_refseq_info[l[0]][l[1]] = '%s\t%s\t%s\t%s\n'%(l[0],seq_id,seq_info,'None')
            else:
                seq_info = ' '.join(line.strip().split(' ')[1:])
                seq_sp = 'None'
                gene_refseq_info[l[0]][l[1]] = '%s\t%s\t%s\t%s\n'%(l[0],seq_id,seq_info,'None')
    fw.write('SeqID\tAccession\tAnnotation\tSpecies\n')
    for i in gene_refseq_info:
        for j in gene_refseq_info[i]:
            fw.write(gene_refseq_info[i][j])
#import sys
#with open(sys.argv[1],'r') as f1,open(sys.argv[2],'w') as f2:
#    f2.write('SeqID\tAccession\tAnnotation\n')
#    for line in f1:
#        l = line.strip()
#        if l != '' and not l.startswith('#'):
#            ll = l.split('\t')
#            f2.write(ll[0]+'\t'+ll[1]+'\t'+ll[-1].split(' ',1)[-1]+'\n')
