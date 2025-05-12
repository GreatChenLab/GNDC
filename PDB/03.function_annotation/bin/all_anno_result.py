import sys
import os
import argparse
import subprocess
import gzip
from argparse import RawTextHelpFormatter
author ='Pengyu Fan'
mail = 'fanppengyu@alumni.hust.edu.cn'
data = '2022'
version = 'v1.0'
usage='''
author:    {0}
mail:      {1}
data:      {2}
version:   {3}
Description:
    This python script for Annot summary and stats result.
Example: 
    python {4} -h
'''.format(author, mail, data, version, __file__[__file__.rfind(os.sep) + 1:])

parser = argparse.ArgumentParser(
    formatter_class=RawTextHelpFormatter,description=usage)
parser.add_argument(
    '-seq','--seq',help='seq.fa',dest='seq',required=True,type = str)
parser.add_argument(
    '-kegg','--kegg',help='kegg annot file',dest='kegg',default='no',type = str)
parser.add_argument(
    '-ko','--ko',help='ko annot file',dest='ko',default='no',type = str)
parser.add_argument(
    '-nr','--nr',help='nr annot file',dest='nr',default='no',type = str)
parser.add_argument(
    '-uniprot','--uniprot',help='nr annot file',dest='uniprot',default='no',type = str)
parser.add_argument(
    '-go','--go',help='go annot file',dest='go',default='no',type = str)
parser.add_argument(
    '-cog','--cog',help='cog annot file',dest='cog',default='no',type = str)
parser.add_argument(
    '-kog','--kog',help='kog annot file',dest='kog',default='no',type = str)
parser.add_argument(
    '-pfam','--pfam',help='pfam annot file',dest='pfam',default='no',type = str)
parser.add_argument(
    '-interpro','--interpro',help='interpro annot file',dest='interpro',default='no',type = str)
parser.add_argument(
    '-refseq','--refseq',help='refseq annot file',dest='refseq',default='no',type = str)
parser.add_argument(
    '-tf','--tf',help='tf annot file',dest='tf',default='no',type = str)
parser.add_argument(
    '-tigerfam','--tigerfam',help='tigerfam annot file',dest='tigerfam',default='no',type = str)
parser.add_argument(
    '-o','--output',help='output dir',dest='output',default = './',type = str)
args = parser.parse_args()

def OnlyTableHead(infile):
    line_num = 0
    if os.path.getsize(infile) != 0:
        with open(infile,'r',encoding='utf-8') as f:
            for line in f:
                l = line.strip()
                if l != '':
                    line_num += 1
    return line_num
def get_file_size(infile):
    #check_file_stats(infile)
    return os.path.getsize(infile)
def check_file_stats(infile):
    error_num = 0
    error_list = []
    file_type = 'normal'
    # file must exists
    if os.path.exists(infile):
        # file not a temp file
        if os.path.getsize(infile):
            if infile.endswith('.gz'):
                file_type = 'gz'
                status_fq1, output_fq1 = subprocess.getstatusoutput('gunzip -t %s'%(infile))
                status_fq1 = int(status_fq1)
                # gz file must test pass
                if status_fq1 != 0:
                    error_list.append(output_fq1)
                    error_list.append("This gz file %s is broken !!!!"%(infile))
                    error_num += 1
        else:
            error_list.append("%s is a empty file !!!!"%(infile))
            error_num += 1
    else:
        error_list.append("%s does not exist !!!!"%(infile))
        error_num += 1
    #return error number,error info,and file type
    if error_num != 0:
        print('\n'.join(error_list))
        exit(1)

def read_annot(in_file,gene_c,anno_c,gene_dict,anno_type,num,anno_id=10000):
    all_tt = {}
    all_num = 0
    check_file_stats(in_file)
    with open(in_file,'r',encoding='utf-8') as fr:
        fr.readline()
        for line in fr:
            new_info = []
            if line.strip() == '' or line.startswith('#') or line.startswith('SeqID'):
                pass
            else:
                l = line.strip().split('\t')
                gene_info = l[gene_c]
                for i in anno_c:
                    new_info.append(l[i])
                if anno_id == 10000:
                    anno_info = '`'.join(new_info)
                else:
                    anno_info = l[anno_id] + '//' + '`'.join(new_info)
                if gene_info not in all_tt:
                    all_tt[gene_info] = ''
                    all_num += 1
                if gene_info not in gene_dict:
                    num += 1
                    gene_dict[gene_info] = {}
                    if anno_info != 'None':
                        gene_dict[gene_info][anno_type] = []
                        gene_dict[gene_info][anno_type].append(anno_info)
                else:
                    if anno_info != 'None':
                        if anno_type not in gene_dict[gene_info]:
                            gene_dict[gene_info][anno_type] = []
                        gene_dict[gene_info][anno_type].append(anno_info)
    return gene_dict,num,all_num

outputfile = os.path.join(args.output,'all_annotation.xls')
stat_outputfile = os.path.join(args.output,'stat.xls')

all_gene_num = 0
check_file_stats(args.seq)
if not args.seq.endswith('.gz'):
    with open(args.seq,'r') as f:
        for line in f:
            if line.startswith('>'):
                all_gene_num += 1
else:
    with gzip.open(args.seq,'r') as f:
        for line in f:
            line = line.decode()
            if line.startswith('>'):
                all_gene_num += 1

anno_list = []
anno_gene_num = 0
gene_anno_info = {}
all_anno_num = {}
if args.kegg != 'no':
    if get_file_size(args.kegg) != 0 and OnlyTableHead(args.kegg) > 1:
        anno_list.append('KEGG')
        all_anno_num['KEGG'] = 0
        gene_anno_info,anno_gene_num,all_anno_num['KEGG'] = read_annot(args.kegg,0,[2],gene_anno_info,'KEGG',anno_gene_num,1)
if args.ko != 'no':
    if get_file_size(args.ko) != 0 and OnlyTableHead(args.ko) > 1:
        anno_list.append('Pathway')
        all_anno_num['Pathway'] = 0
        gene_anno_info,anno_gene_num,all_anno_num['Pathway'] = read_annot(args.ko,0,[3,1,2],gene_anno_info,'Pathway',anno_gene_num,4)
if args.nr != 'no':
    if get_file_size(args.nr) != 0 and OnlyTableHead(args.nr) > 1:
        anno_list.append('Nr')
        all_anno_num['Nr'] = 0
        gene_anno_info,anno_gene_num,all_anno_num['Nr'] = read_annot(args.nr,0,[2],gene_anno_info,'Nr',anno_gene_num,1)
if args.uniprot != 'no':
    if get_file_size(args.uniprot) != 0 and OnlyTableHead(args.uniprot) > 1:
        anno_list.append('Uniprot')
        all_anno_num['Uniprot'] = 0
        gene_anno_info,anno_gene_num,all_anno_num['Uniprot'] = read_annot(args.uniprot,0,[2],gene_anno_info,'Uniprot',anno_gene_num,1)
if args.go != 'no':
    if get_file_size(args.go) != 0 and OnlyTableHead(args.go) > 1:
        anno_list.append('GO')
        all_anno_num['GO'] = 0
        gene_anno_info,anno_gene_num,all_anno_num['GO'] = read_annot(args.go,0,[2,3],gene_anno_info,'GO',anno_gene_num,1)
if args.cog != 'no':
    if get_file_size(args.cog) != 0 and OnlyTableHead(args.cog) > 1:
        anno_list.append('COG')
        all_anno_num['COG'] = 0
        gene_anno_info,anno_gene_num,all_anno_num['COG'] = read_annot(args.cog,0,[1,2,3],gene_anno_info,'COG',anno_gene_num,10000)
if args.kog != 'no':
    if get_file_size(args.kog) != 0 and OnlyTableHead(args.kog) > 1:
        anno_list.append('KOG')
        all_anno_num['KOG'] = 0
        gene_anno_info,anno_gene_num,all_anno_num['KOG'] = read_annot(args.kog,0,[1,2,3],gene_anno_info,'KOG',anno_gene_num,10000)
if args.pfam != 'no':
    if get_file_size(args.pfam) != 0 and OnlyTableHead(args.pfam) > 1:
        anno_list.append('Pfam')
        all_anno_num['Pfam'] = 0
        gene_anno_info,anno_gene_num,all_anno_num['Pfam'] = read_annot(args.pfam,0,[2,3],gene_anno_info,'Pfam',anno_gene_num,1)
if args.interpro != 'no':
    if get_file_size(args.interpro) != 0 and OnlyTableHead(args.interpro) > 1:
        anno_list.append('Interpro')
        all_anno_num['Interpro'] = 0
        gene_anno_info,anno_gene_num,all_anno_num['Interpro'] = read_annot(args.interpro,0,[5],gene_anno_info,'Interpro',anno_gene_num,10000)
if args.refseq != 'no':
    if get_file_size(args.refseq) != 0 and OnlyTableHead(args.refseq) > 1:
        anno_list.append('Refseq')
        all_anno_num['Refseq'] = 0
        gene_anno_info,anno_gene_num,all_anno_num['Refseq'] = read_annot(args.refseq,0,[2],gene_anno_info,'Refseq',anno_gene_num,1)
if args.tf != 'no':
    if get_file_size(args.tf) != 0 and OnlyTableHead(args.tf) > 1:
        anno_list.append('TF')
        all_anno_num['TF'] = 0
        gene_anno_info,anno_gene_num,all_anno_num['TF'] = read_annot(args.tf,0,[2],gene_anno_info,'TF',anno_gene_num,10000)
if args.tigerfam != 'no':
    if get_file_size(args.tigerfam) != 0 and OnlyTableHead(args.tigerfam) > 1:
        anno_list.append('Tigerfam')
        all_anno_num['Tigerfam'] = 0
        gene_anno_info,anno_gene_num,all_anno_num['Tigerfam'] = read_annot(args.tigerfam,0,[2,3],gene_anno_info,'Tigerfam',anno_gene_num,1)

if anno_list == []:
    print('Please input anno file for run!!!')
    exit(2)

if not os.path.exists(args.output):
    os.makedirs(args.output)
with open(outputfile,'w',encoding='utf-8') as f1,open(stat_outputfile,'w',encoding='utf-8') as f2:
    first_line_list = ['SeqID']
    f2.write('Item\tCount\tPercentage\n')
    f2.write('%s\t%s\t%.2f%%\n'%('All',str(format(all_gene_num,',')),all_gene_num/all_gene_num*100))
    f2.write('%s\t%s\t%.2f%%\n'%('Annotation',str(format(anno_gene_num,',')),anno_gene_num/all_gene_num*100))
    for i in anno_list:
        f2.write('%s\t%s\t%.2f%%\n'%(i,str(format(all_anno_num[i],',')),all_anno_num[i]/all_gene_num*100))
        first_line_list.append(i)
    f1.write('\t'.join(first_line_list) + '\n')
    for j in gene_anno_info:
        line_list = [j]
        for z in anno_list:
            if z in gene_anno_info[j]:
                line_list.append(';'.join(gene_anno_info[j][z]))
            else:
                line_list.append('None')
        f1.write('\t'.join(line_list) + '\n')
