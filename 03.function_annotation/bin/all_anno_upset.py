import sys
import os
import argparse
import subprocess
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
#parser.add_argument(
#    '-seq','--seq',help='seq.fa',dest='seq',required=True,type = str)
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
def get_list(infile,ofile):
    gg = {}
    with open(infile,'r',encoding='utf-8') as f,open(ofile,'w',encoding='utf-8') as fw:
        f.readline()
        for line in f:
            l = line.strip()
            ll = l.split('\t')[0]
            if ll not in gg:
                gg[ll] = ''
                fw.write(ll+'\n')

if not os.path.exists(args.output):
    os.makedirs(args.output)
args.output = os.path.abspath(args.output)
outputfile = os.path.join(args.output,'Upset_anno.R')

add_info = ''
runOne = []
runTwo = []
add_num = 0
if args.kegg != 'no':
    if get_file_size(args.kegg) != 0 and OnlyTableHead(args.kegg) > 1:
        add_num += 1
        check_file_stats(args.kegg)
        runOne.append('kegg')
        runTwo.append('"KEGG"')
        add_info += 'kegg <- as.vector(t(read.delim("%s/kegg.list", header = F, stringsAsFactors = F)))\n'%(args.output)
        get_list(args.kegg,args.output+'/kegg.list')
if args.ko != 'no':
    if get_file_size(args.ko) != 0 and OnlyTableHead(args.ko) > 1:
        add_num += 1
        check_file_stats(args.ko)
        runOne.append('pathway')
        runTwo.append('"Pathway"')
        add_info += 'pathway <- as.vector(t(read.delim("%s/pathway.list", header = F, stringsAsFactors = F)))\n'%(args.output)
        get_list(args.ko,args.output+'/pathway.list')
if args.nr != 'no':
    if get_file_size(args.nr) != 0 and OnlyTableHead(args.nr) > 1:
        add_num += 1
        check_file_stats(args.nr)
        runOne.append('nr')
        runTwo.append('"Nr"')
        add_info += 'nr <- as.vector(t(read.delim("%s/nr.list", header = F, stringsAsFactors = F)))\n'%(args.output)
        get_list(args.nr,args.output+'/nr.list')
if args.uniprot != 'no':
    if get_file_size(args.uniprot) != 0 and OnlyTableHead(args.uniprot) > 1:
        add_num += 1
        check_file_stats(args.uniprot)
        runOne.append('uniprot')
        runTwo.append('"Uniprot"')
        add_info += 'uniprot <- as.vector(t(read.delim("%s/uniprot.list", header = F, stringsAsFactors = F)))\n'%(args.output)
        get_list(args.uniprot,args.output+'/uniprot.list')
if args.go != 'no':
    if get_file_size(args.go) != 0 and OnlyTableHead(args.go) > 1:
        add_num += 1
        check_file_stats(args.go)
        runOne.append('go')
        runTwo.append('"GO"')
        add_info += 'go <- as.vector(t(read.delim("%s/go.list", header = F, stringsAsFactors = F)))\n'%(args.output)
        get_list(args.go,args.output+'/go.list')
if args.cog != 'no':
    if get_file_size(args.cog) != 0 and OnlyTableHead(args.cog) > 1:
        add_num += 1
        check_file_stats(args.cog)
        runOne.append('cog')
        runTwo.append('"COG"')
        add_info += 'cog <- as.vector(t(read.delim("%s/cog.list", header = F, stringsAsFactors = F)))\n'%(args.output)
        get_list(args.cog,args.output+'/cog.list')
if args.kog != 'no':
    if get_file_size(args.kog) != 0 and OnlyTableHead(args.kog) > 1:
        add_num += 1
        check_file_stats(args.kog)
        runOne.append('kog')
        runTwo.append('"KOG"')
        add_info += 'kog <- as.vector(t(read.delim("%s/kog.list", header = F, stringsAsFactors = F)))\n'%(args.output)
        get_list(args.kog,args.output+'/kog.list')
if args.pfam != 'no':
    if get_file_size(args.pfam) != 0 and OnlyTableHead(args.pfam) > 1:
        add_num += 1
        check_file_stats(args.pfam)
        runOne.append('pfam')
        runTwo.append('"Pfam"')
        add_info += 'pfam <- as.vector(t(read.delim("%s/pfam.list", header = F, stringsAsFactors = F)))\n'%(args.output)
        get_list(args.pfam,args.output+'/pfam.list')
if args.interpro != 'no':
    if get_file_size(args.interpro) != 0 and OnlyTableHead(args.interpro) > 1:
        add_num += 1
        check_file_stats(args.interpro)
        runOne.append('interpro')
        runTwo.append('"Interpro"')
        add_info += 'interpro <- as.vector(t(read.delim("%s/interpro.list", header = F, stringsAsFactors = F)))\n'%(args.output)
        get_list(args.interpro,args.output+'/interpro.list')
if args.refseq != 'no':
    if get_file_size(args.refseq) != 0 and OnlyTableHead(args.refseq) > 1:
        add_num += 1
        check_file_stats(args.refseq)
        runOne.append('refseq')
        runTwo.append('"Refseq"')
        add_info += 'refseq <- as.vector(t(read.delim("%s/refseq.list", header = F, stringsAsFactors = F)))\n'%(args.output)
        get_list(args.refseq,args.output+'/refseq.list')
if args.tf != 'no':
    if get_file_size(args.tf) != 0 and OnlyTableHead(args.tf) > 1:
        add_num += 1
        check_file_stats(args.tf)
        runOne.append('tf')
        runTwo.append('"TF"')
        add_info += 'tf <- as.vector(t(read.delim("%s/tf.list", header = F, stringsAsFactors = F)))\n'%(args.output)
        get_list(args.tf,args.output+'/tf.list')
if args.tigerfam != 'no':
    if get_file_size(args.tigerfam) != 0 and OnlyTableHead(args.tigerfam) > 1:
        add_num += 1
        check_file_stats(args.tigerfam)
        runOne.append('tigerfam')
        runTwo.append('"Tigerfam"')
        add_info += 'tigerfam <- as.vector(t(read.delim("%s/tigerfam.list", header = F, stringsAsFactors = F)))\n'%(args.output)
        get_list(args.tigerfam,args.output+'/tigerfam.list')

if add_info == '':
    print('Please input anno file for run!!!')
    exit(2)

with open(outputfile,'w',encoding='utf-8') as f:
    f.write(
    '''
library(UpSetR)
library(RColorBrewer)
library(svglite)

%s

data <- list(%s)
names(data) <- c(%s)

setsBarColors <- brewer.pal(%s, "Paired")
pdf("all_annotation_upset.pdf", onefile = FALSE)
upset(fromList(data), nsets = %s,sets.bar.color=setsBarColors, order.by = "degree")
dev.off()
png("all_annotation_upset.png")
upset(fromList(data), nsets = %s,sets.bar.color=setsBarColors, order.by = "degree")
dev.off()
svg("all_annotation_upset.svg")
upset(fromList(data), nsets = %s,sets.bar.color=setsBarColors, order.by = "degree")
dev.off()
    '''%(
    add_info,\
    ', '.join(runOne),\
    ', '.join(runTwo),\
    str(add_num),\
    str(add_num),\
    str(add_num),\
    str(add_num)))
if add_num <= 1:
    os.system('touch all_annotation_upset.svg all_annotation_upset.pdf all_annotation_upset.png')
else:
    cc = os.system('Rscript %s'%(outputfile))
    if cc != 0:
        print('run error !!!')
        exit(1)
