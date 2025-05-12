#!/usr/bin/python3
# -*- coding: utf-8 -*-

"""
\033[42;33m                 _____ _   _ _   _  ____ _____ ___ ___  _   _                 \033[1m\033[0m
\033[42;33m                |  ___| | | | \\ | |/ ___|_   _|_ _/ _ \\| \\ | |                \033[1m\033[0m
\033[42;33m                | |_  | | | |  \\| | |     | |  | | | | |  \\| |                \033[1m\033[0m
\033[42;33m                |  _| | |_| | |\\  | |___  | |  | | |_| | |\\  |                \033[1m\033[0m
\033[42;33m                |_|    \\___/|_| \\_|\\____| |_| |___\\___/|_| \\_|                \033[1m\033[0m
\033[42;33m                                                                              \033[1m\033[0m
\033[43;32m              A Nextflow Pipline For function annotation Analysis             \033[1m\033[0m
\033[43;32m                    . Author  : Pengyu Fan                                    \033[1m\033[0m
\033[43;32m                    . Email   : fanpengyu@alumni.hust.edu.cn                  \033[1m\033[0m
\033[43;32m                    . Version : v1.1                                          \033[1m\033[0m
\033[43;32m                    . Update  : 2023.7.26                                     \033[1m\033[0m
"""

#####Import Module#####
import logging
import sys
import os
import math
import time
import argparse
import getopt
import csv
import re
import glob
import subprocess
from argparse import RawTextHelpFormatter

if len(sys.argv) > 1:
    if sys.argv[1].strip() == '--classList':
        print('''
\033[40;31m\033[1mHi, my frende,
Please select one of the following to enter:
\033[0m\033[40;36m\033[1m
Animals                              #动物
├── InVertebrates                    #无脊椎动物
├── Mammals                          #哺乳动物
├── Fishes                           #硬骨鱼类
├── Amphibians                       #两栖动物
├── Reptiles                         #爬行动物
├── Birds                            #鸟类
└── Vertebrates_other                #其他脊椎动物
\033[0m
\033[5;33;42m\033[1m(=^_^=) Please fill in correctly, if you make mistakes, you will be spanked (=^_^=)\033[0m
''')
        exit(0)

parser = argparse.ArgumentParser(
    formatter_class=RawTextHelpFormatter, description= __doc__)
#run mode
run_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mRunningMode options\033[0m\033[40;36m')
run_group.add_argument(
    '-profile',help='\033[0m\033[40;32m\033[1mDifferent servers use different configurations\033[0m\033[40;36m',dest='profile',\
    choices=['sgeWuhanM','sgeWuhanG','sgeWuhanT','slurmWuhanM','slurmWuhanG','slurmWuhanT','slurmWuda'],default='sgeWuhanM',type=str)
run_group.add_argument(
    '-nhp',help='Whether you want to "nohup + &" run task', choices=['y','n'], default = 'n', type = str)
run_group.add_argument(
    '-run_mode',help='\033[0m\033[40;32m\033[1mrun mode for pipline\033[0m\033[40;36m',dest='run_mode',\
    choices=['Genome','Bacteria','Meta','Fungi','Transcrip','Normal'],default='Normal',type=str)
run_group.add_argument(
    '-map_soft',help='\033[0m\033[40;32m\033[1mmapping soft\033[0m\033[40;36m',dest='map_soft',\
    choices=['blastp','blastx'],default='blastp',type=str)
run_group.add_argument(
    '-bg',help = '\033[0m\033[40;32m\033[1mWhether to run in the background\033[0m\033[40;36m',dest='bg',choices=['y','n'],default='n',type = str)
#Input file
input_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mInputFile options\033[0m\033[40;36m')
input_group.add_argument(
    '-pep',help='\033[0m\033[40;32m\033[1minput the pep.fa\033[0m\033[40;36m',dest='pep',default='None',type=str)
input_group.add_argument(
    '-trans',help='\033[0m\033[40;32m\033[1minput the transcript.fa\033[0m\033[40;36m',dest='trans',default='None',type=str)
input_group.add_argument(
    '-gbk',help='\033[0m\033[40;32m\033[1minput the gbk file for island,phispy\033[0m\033[40;36m',dest='gbk',default='None',type=str)
input_group.add_argument(
    '-genome',help='\033[0m\033[40;32m\033[1minput the genome file for minced\033[0m\033[40;36m',dest='genome',default='None',type=str)
input_group.add_argument(
    '-gff',help='\033[0m\033[40;32m\033[1minput the gff file for antismash\033[0m\033[40;36m',dest='gff',default='None',type=str)
input_group.add_argument(
    '-sample_name',help="\033[0m\033[40;32m\033[1msample/species name ex: Arabidopsis_thaliana, if you want your file have prefix , Don't input\033[0m\033[40;36m",dest='sample_name',default='None',type=str)
#Species info
species_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mSpeciesChoose options\033[0m\033[40;36m')
species_group.add_argument(
    '-kingdom',help='\033[0m\033[40;32m\033[1mkingdom info ,if you choose Animals, Please run python3 %s --classList to choose info for -Phylum\033[0m\033[40;36m'%(sys.argv[0]),dest='kingdom',\
    choices=['All', 'Archaea', 'Bacteria', 'Fungi', 'Plants', 'Animals', 'Virus', 'Human', 'B_A_V', 'B_A_F_V'],\
    default='All', type = str)
species_group.add_argument(
    '-Phylum', help ='\033[0m\033[40;32m\033[1mPhylum detailed information for Animals',dest = 'Phylum',default='Animals', type = str)
#Common anno parameter for tf,tigerfam,tcdb,cazy,cyped,card,ardb,vfdb,phi
common_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mCommonParameter options\033[0m\033[40;36m')
common_group.add_argument(
    '-split',help='\033[0m\033[40;32m\033[1msplit the input into X file for tf,tigerfam,tcdb,cazy,cyped,card,ardb,vfdb,phi\033[0m\033[40;36m',dest='split',default="10",type=str)
common_group.add_argument(
    '-engine',help='\033[0m\033[40;32m\033[1mwhich blast use for ardb/vfdb/phi\033[0m\033[40;36m',dest='engine',choices=['diamond','ncbiblast'],default='ncbiblast',type=str)
common_group.add_argument(
    '-cpu',help='\033[0m\033[40;32m\033[1msoftware cpu for tf,tigerfam,tcdb,cazy,cyped,card,ardb,vfdb,phi\033[0m\033[40;36m',dest='cpu',default="16",type=str)
#kegg
kegg_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mKegg options\033[0m\033[40;36m')
kegg_group.add_argument(
    '-kegg',help='\033[0m\033[40;32m\033[1mif run kegg annot ,add -kegg behind command line\033[0m\033[40;36m',dest='kegg',default='pass',action="store_true")
kegg_group.add_argument(
    '-kegg_org',help='\033[0m\033[40;32m\033[1m单个物种注释，输入物种kegg官网上的缩写，例如人类 hsa\033[0m\033[40;36m',dest='kegg_org',default='None',type=str)
kegg_group.add_argument(
    '-kevalue',help='\033[0m\033[40;32m\033[1mkegg evalue\033[0m\033[40;36m',dest='kevalue',default='1e-5',type=str)
kegg_group.add_argument(
    '-kegg_map_soft',help='\033[0m\033[40;32m\033[1muse hmmscan or hmmsearch or blastp\033[0m\033[40;36m',dest='kegg_map_soft',choices=['hmmscan','hmmsearch','blastp'],default='hmmscan',type=str)
kegg_group.add_argument(
    '-splitk',help='\033[0m\033[40;32m\033[1msplit the input into X file for kegg\033[0m\033[40;36m',dest='splitk',default="20",type=str)
kegg_group.add_argument(
    '-kcpu',help='\033[0m\033[40;32m\033[1mrun kegg annot cpu for each blastp (diamond)/kofamscan\033[0m\033[40;36m',dest='kcpu',default="16",type=str)
kegg_group.add_argument(
    '-maxF_k',help='\033[0m\033[40;32m\033[1mmax num blastp/kofamscan can be executed in local parallel for kegg\033[0m\033[40;36m',dest='maxF_k',default="10",type=str)
kegg_group.add_argument(
    '-Kegg_mem',help='\033[0m\033[40;32m\033[1mKegg use mem\033[0m\033[40;36m',dest='Kegg_mem',default="10",type=str)
#nr
nr_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mNr options\033[0m\033[40;36m')
nr_group.add_argument(
    '-nr',help='\033[0m\033[40;32m\033[1mif run nr annot ,add -nr behind command line\033[0m\033[40;36m',dest='nr',default='pass',action="store_true")
nr_group.add_argument(
    '-splitn',help='\033[0m\033[40;32m\033[1msplit the input into X file for nr\033[0m\033[40;36m',dest='splitn',default="20",type=str)
nr_group.add_argument(
    '-ncpu',help='\033[0m\033[40;32m\033[1mrun nr annot cpu for each blastp (diamond)\033[0m\033[40;36m',dest='ncpu',default="16",type=str)
nr_group.add_argument(
    '-maxF_n',help='\033[0m\033[40;32m\033[1mmax num blastp can be executed in local parallel for nr\033[0m\033[40;36m',dest='maxF_n',default="8",type=str)
nr_group.add_argument(
    '-Nr_mem',help='\033[0m\033[40;32m\033[1mNr use mem\033[0m\033[40;36m',dest='Nr_mem',default="6",type=str)
#uniprot
uniprot_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mUniprot options\033[0m\033[40;36m')
uniprot_group.add_argument(
    '-uniprot',help='\033[0m\033[40;32m\033[1mif run uniprot annot ,add -uniprot behind command line\033[0m\033[40;36m',dest='uniprot',default='pass',action="store_true")
uniprot_group.add_argument(
    '-splitu',help='\033[0m\033[40;32m\033[1msplit the input into X file for uniprot\033[0m\033[40;36m',dest='splitu',default="20",type=str)
uniprot_group.add_argument(
    '-ucpu',help='\033[0m\033[40;32m\033[1mrun uniprot annot cpu for each blastp (diamond)\033[0m\033[40;36m',dest='ucpu',default="16",type=str)
uniprot_group.add_argument(
    '-maxF_u',help='\033[0m\033[40;32m\033[1mmax num blastp can be executed in local parallel for uniprot\033[0m\033[40;36m',dest='maxF_u',default="8",type=str)
uniprot_group.add_argument(
    '-Uniprot_mem',help='\033[0m\033[40;32m\033[1mUniprot use mem\033[0m\033[40;36m',dest='Uniprot_mem',default="6",type=str)
#go
go_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mGo options\033[0m\033[40;36m')
go_group.add_argument(
    '-go',help='\033[0m\033[40;32m\033[1mif run go annot ,add -go behind command line\033[0m\033[40;36m',dest='go',default='pass',action="store_true")
#egg
egg_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mEggNog options\033[0m\033[40;36m')
egg_group.add_argument(
    '-eggnog',help='\033[0m\033[40;32m\033[1mif run eggnog annot ,add -eggnog behind command line\033[0m\033[40;36m',dest='eggnog',default='pass',action="store_true")
egg_group.add_argument(
    '-egg_cpu',help='\033[0m\033[40;32m\033[1mrun cog/kog annot cpu for eggnog\033[0m\033[40;36m',dest='egg_cpu',default='16',type=str)
#cog
cog_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mCog options\033[0m\033[40;36m')
cog_group.add_argument(
    '-cog',help='\033[0m\033[40;32m\033[1mif run cog annot ,add -cog behind command line\033[0m\033[40;36m',dest='cog',default='pass',action="store_true")
#kog
kog_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mKog options\033[0m\033[40;36m')
kog_group.add_argument(
    '-kog',help='\033[0m\033[40;32m\033[1mif run kog annot ,add -kog behind command line\033[0m\033[40;36m',dest='kog',default='pass',action="store_true")
#pfam
pfam_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mPfam options\033[0m\033[40;36m')
pfam_group.add_argument(
    '-pfam',help='\033[0m\033[40;32m\033[1mif run pfam annot ,add -pfam behind command line\033[0m\033[40;36m',dest='pfam',default='pass',action="store_true")
pfam_group.add_argument(
    '-splitp',help='\033[0m\033[40;32m\033[1msplit the input into X file for pfam\033[0m\033[40;36m',dest='splitp',default="20",type=str)
pfam_group.add_argument(
    '-pcpu',help='\033[0m\033[40;32m\033[1mrun pfam annot cpu for each hmmscan\033[0m\033[40;36m',dest='pcpu',default="16",type=str)
pfam_group.add_argument(
    '-maxF_p',help='\033[0m\033[40;32m\033[1mmax num hmmscan can be executed in local parallel for pfam\033[0m\033[40;36m',dest='maxF_p',default="8",type=str)
pfam_group.add_argument(
    '-Pfam_mem',help='\033[0m\033[40;32m\033[1mPfam use mem\033[0m\033[40;36m',dest='Pfam_mem',default="3",type=str)
#interpro
interpro_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mInterpro options\033[0m\033[40;36m')
interpro_group.add_argument(
    '-interpro',help='\033[0m\033[40;32m\033[1mif run interpro annot ,add -interpro behind command line\033[0m\033[40;36m',dest='interpro',default='pass',action="store_true")
interpro_group.add_argument(
    '-no_interpro',help='\033[0m\033[40;32m\033[1monly for Genome model\033[0m\033[40;36m',dest='no_interpro',default='pass',action="store_true")
interpro_group.add_argument(
    '-spliti',help='\033[0m\033[40;32m\033[1msplit the input into X file for interpro\033[0m\033[40;36m',dest='spliti',default="20",type=str)
interpro_group.add_argument(
    '-cutForS',help='\033[0m\033[40;32m\033[1muse cutf or cuts\033[0m\033[40;36m',dest='cutForS',choices=['cutf','cuts'],default="cutf",type=str)
interpro_group.add_argument(
    '-icpu',help='\033[0m\033[40;32m\033[1mcpu for each interproscan\033[0m\033[40;36m',dest='icpu',default="16",type=str)
interpro_group.add_argument(
    '-maxF_i',help='\033[0m\033[40;32m\033[1mmax num interproscan can be executed in local parallel\033[0m\033[40;36m',dest='maxF_i',default="6",type=str)
interpro_group.add_argument(
    '-Interpro_mem',help='\033[0m\033[40;32m\033[1mInterpro use mem\033[0m\033[40;36m',dest='Interpro_mem',default="20",type=str)
#refseq
refseq_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mRefseq options\033[0m\033[40;36m')
refseq_group.add_argument(
    '-refseq',help='\033[0m\033[40;32m\033[1mif run refseq annot ,add -refseq behind command line\033[0m\033[40;36m',dest='refseq',default='pass',action="store_true")
refseq_group.add_argument(
    '-splitr',help='\033[0m\033[40;32m\033[1msplit the input into X file for refseq\033[0m\033[40;36m',dest='splitr',default="20",type=str)
refseq_group.add_argument(
    '-rcpu',help='\033[0m\033[40;32m\033[1mrun refseq annot cpu for each blastp (diamond)\033[0m\033[40;36m',dest='rcpu',default="16",type=str)
refseq_group.add_argument(
    '-maxF_r',help='\033[0m\033[40;32m\033[1mmax num blastp can be executed in local parallel for refseq\033[0m\033[40;36m',dest='maxF_r',default="8",type=str)
refseq_group.add_argument(
    '-Refseq_mem',help='\033[0m\033[40;32m\033[1mRefseq use mem\033[0m\033[40;36m',dest='Refseq_mem',default="5",type=str)
#tf
tf_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mTF options\033[0m\033[40;36m')
tf_group.add_argument(
    '-tf',help='\033[0m\033[40;32m\033[1mif run tf annot ,add -tf behind command line\033[0m\033[40;36m',dest='tf',default='pass',action="store_true")
#tigerfam
tigerfam_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mTigerfam options\033[0m\033[40;36m')
tigerfam_group.add_argument(
    '-tigerfam',help='\033[0m\033[40;32m\033[1mif run tigerfam annot ,add -tigerfam behind command line\033[0m\033[40;36m',dest='tigerfam',default='pass',action="store_true")
tigerfam_group.add_argument(
    '-splitt',help='\033[0m\033[40;32m\033[1msplit the input into X file for tigerfam\033[0m\033[40;36m',dest='splitt',default="20",type=str)
tigerfam_group.add_argument(
    '-tcpu',help='\033[0m\033[40;32m\033[1mrun tigerfam annot cpu for each hmmscan\033[0m\033[40;36m',dest='tcpu',default="16",type=str)
tigerfam_group.add_argument(
    '-maxF_t',help='\033[0m\033[40;32m\033[1mmax num blastp can be executed in local parallel for tigerfam\033[0m\033[40;36m',dest='maxF_t',default="8",type=str)
#tcdb
tcdb_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mTcdb options\033[0m\033[40;36m')
tcdb_group.add_argument(
    '-tcdb',help='\033[0m\033[40;32m\033[1mif run tcdb annot ,add -tcdb behind command line\033[0m\033[40;36m',dest='tcdb',default='pass',action="store_true")
#cazy
cazy_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mCazy options\033[0m\033[40;36m')
cazy_group.add_argument(
    '-cazy',help='\033[0m\033[40;32m\033[1mif run cazy annot ,add -cazy behind command line\033[0m\033[40;36m',dest='cazy',default='pass',action="store_true")
#cyped
cyped_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mCyped options\033[0m\033[40;36m')
cyped_group.add_argument(
    '-cyped',help='\033[0m\033[40;32m\033[1mif run cyped annot ,add -cyped behind command line\033[0m\033[40;36m',dest='cyped',default='pass',action="store_true")
#signalp
signalp_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mSignalp options\033[0m\033[40;36m')
signalp_group.add_argument(
    '-signalp',help='\033[0m\033[40;32m\033[1mif run signalp annot ,add -signalp behind command line\033[0m\033[40;36m',dest='signalp',default='pass',action="store_true")
signalp_group.add_argument(
    '-signalp_type',help='\033[0m\033[40;32m\033[1msignalp org choose\033[0m\033[40;36m',dest='signalp_type',choices=['euk','gram-','gram+','arch'],default='euk',type=str)
signalp_group.add_argument(
    '-pict_Signal',help='\033[0m\033[40;32m\033[1mif get picture for Signalp, choose y or n\033[0m\033[40;36m',dest='pict_Signal',choices=['y','n'],default='n',type=str)
signalp_group.add_argument(
    '-maxF_Sig',help='\033[0m\033[40;32m\033[1mmax num signalp can be executed in local parallel\033[0m\033[40;36m',dest='maxF_Sig',default="10",type=str)
#tmhmm
tmhmm_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mTmhmm options\033[0m\033[40;36m')
tmhmm_group.add_argument(
    '-tmhmm',help='\033[0m\033[40;32m\033[1mif run tmhmm annot ,add -tmhmm behind command line\033[0m\033[40;36m',dest='tmhmm',default='pass',action="store_true")
tmhmm_group.add_argument(
    '-pict_Tmhmm',help='\033[0m\033[40;32m\033[1mif get picture for Tmhmm, choose y or n\033[0m\033[40;36m',dest='pict_Tmhmm',choices=['y','n'],default='n',type=str)
tmhmm_group.add_argument(
    '-maxF_Tm',help='\033[0m\033[40;32m\033[1mmax num tmhmm can be executed in local parallel\033[0m\033[40;36m',dest='maxF_Tm',default="10",type=str)
#deeploc
deeploc_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mDeeploc options\033[0m\033[40;36m')
deeploc_group.add_argument(
    '-deeploc',help='\033[0m\033[40;32m\033[1mif run deeploc annot ,add --deeploc behind command line\033[0m\033[40;36m',dest='deeploc',default='pass',action="store_true")
deeploc_group.add_argument(
    '-maxF_d',help='\033[0m\033[40;32m\033[1mmax num deeploc can be executed in local parallel\033[0m\033[40;36m',dest='maxF_d',default="10",type=str)
#card
card_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mCard options\033[0m\033[40;36m')
card_group.add_argument(
    '-card',help='\033[0m\033[40;32m\033[1mif run card annot ,add -card behind command line\033[0m\033[40;36m',dest='card',default='pass',action="store_true")
#ardb
ardb_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mArdb options\033[0m\033[40;36m')
ardb_group.add_argument(
    '-ardb',help='\033[0m\033[40;32m\033[1mif run ardb annot ,add -ardb behind command line\033[0m\033[40;36m',dest='ardb',default='pass',action="store_true")
#vfdb
vfdb_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mVfdb options\033[0m\033[40;36m')
vfdb_group.add_argument(
    '-vfdb',help='\033[0m\033[40;32m\033[1mif run vfdb annot ,add -vfdb behind command line\033[0m\033[40;36m',dest='vfdb',default='pass',action="store_true")
#phi
phi_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mPhi options\033[0m\033[40;36m')
phi_group.add_argument(
    '-phi',help='\033[0m\033[40;32m\033[1mif run phi annot ,add -phi behind command line\033[0m\033[40;36m',dest='phi',default='pass',action="store_true")
#island
island_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mIsland options\033[0m\033[40;36m')
island_group.add_argument(
    '-island',help='\033[0m\033[40;32m\033[1mif run island annot ,add -island behind command line\033[0m\033[40;36m',dest='island',default='pass',action="store_true")
island_group.add_argument(
    '-island_len',help='\033[0m\033[40;32m\033[1mmin seq length\033[0m\033[40;36m',dest='island_len',default="4000",type=str)
#phispy
phispy_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mPhispy options\033[0m\033[40;36m')
phispy_group.add_argument(
    '-phispy',help='\033[0m\033[40;32m\033[1mif run phispy annot ,add -phispy behind command line\033[0m\033[40;36m',dest='phispy',default='pass',action="store_true")
phispy_group.add_argument(
    '-phispy_len',help='\033[0m\033[40;32m\033[1mmin seq length\033[0m\033[40;36m',dest='phispy_len',default="4000",type=str)
#minced
minced_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mMinced options\033[0m\033[40;36m')
minced_group.add_argument(
    '-minced',help='\033[0m\033[40;32m\033[1mif run minced annot ,add -minced behind command line\033[0m\033[40;36m',dest='minced',default='pass',action="store_true")
#antismash
antismash_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mAntismash options\033[0m\033[40;36m')
antismash_group.add_argument(
    '-antismash',help='\033[0m\033[40;32m\033[1mif run antismash annot ,add -antismash behind command line\033[0m\033[40;36m',dest='antismash',default='pass',action="store_true")
antismash_group.add_argument(
    '-antimode',help = '\033[0m\033[40;32m\033[1mantismash use file gbk or fasta or fasta_gff\033[0m\033[40;36m',dest='antimode',choices=['gbk','fasta','fasta_gff'],default='gbk',type = str)
##################Other
Other_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mOther options\033[0m\033[40;36m')
Other_group.add_argument(
    '-queue', help='\033[0m\033[40;32m\033[1msge/slurm queue\033[0m\033[40;36m', dest='queueq', default='all.q', type=str)
Other_group.add_argument(
    '-Distributed', help='\033[0m\033[40;32m\033[1mif Distributed system or not\033[0m\033[40;36m', dest='Distributed', choices=['y','n'], default='n', type=str)
#work dir & nextflow out
out_group = parser.add_argument_group(title='\033[0m\033[40;31m\033[1mOutput options\033[0m\033[40;36m')
out_group.add_argument(
    '-w',help='\033[0m\033[40;32m\033[1minput work dir\033[0m\033[40;36m',dest='work_dicr',default='./',type=str)
out_group.add_argument(
    '-regular_out',help='\033[0m\033[40;32m\033[1mnextflow script regular out\033[0m\033[40;36m',dest='regular_out',default='Result',type=str)
out_group.add_argument(
    '-specific_out',help='\033[0m\033[40;32m\033[1mnextflow script specific out\033[0m\033[40;36m',dest='specific_out',default='Result',type=str)
out_group.add_argument(
    '-element_out',help='\033[0m\033[40;32m\033[1mnextflow script element out\033[0m',dest='element_out',default='Result',type=str)
if len(sys.argv) == 1:
    parser.print_help()
    sys.exit(0)
args = parser.parse_args()

def check_software(software_path):
    if os.path.exists(software_path):
        logging.debug("Choose software:" + software_path + "!")
    else:
        output = os.popen('which ' + software_path)
        software_temp = output.read().strip()
        if os.path.exists(software_temp):
            software_path = software_temp
            logging.debug("Choose software:" + software_path + "!")
        else:
            logging.error("Can't locate the " + software_path + "!")
            exit(1)
    return software_path
def show_info(text):
    now_time = time.time()
    logging.info(text)
    return now_time
def run_cmd(cmd):
    logging.info(cmd)
    flag = os.system(cmd)
    if flag != 0:
        logging.error("Command fail: " + cmd)
        exit(2)
    return 0
def run_time(start_time):
    spend_time = time.time() - start_time
    logging.info("Total  spend time : " + fmt_time(spend_time))
    return 0
def fmt_time(spend_time):
    spend_time = int(spend_time)
    day = 24 * 60 * 60
    hour = 60 * 60
    min = 60
    if spend_time < 60:
        return "%ds" % math.ceil(spend_time)
    elif spend_time > day:
        days = divmod(spend_time, day)
        return "%dd%s" % (int(days[0]), fmt_time(days[1]))
    elif spend_time > hour:
        hours = divmod(spend_time, hour)
        return '%dh%s' % (int(hours[0]), fmt_time(hours[1]))
    else:
        mins = divmod(spend_time, min)
        return "%dm%ds" % (int(mins[0]), math.ceil(mins[1]))
def check_path(ff_in):
    if os.path.exists(ff_in):
        ff_in = os.path.abspath(ff_in)
    else:
        logging.error("Can not find file %s ,please check input file !!!"%(ff_in))
        exit(3)
    return ff_in
def get_cmd(ainfo_dict,cc,llist):
    if ainfo_dict[llist[0]] != 'pass':
        cc.append('--%s'%(llist[0]))
        if len(llist) > 1:
            for j in llist[1:]:
                cc.append('--%s %s'%(j,ainfo_dict[j]))
    return cc
def main():
    cmd_add = []
    if not os.path.exists(args.work_dicr):
        os.makedirs(args.work_dicr)
    args.work_dicr = os.path.abspath(args.work_dicr)
    src_dir = os.path.dirname(os.path.realpath(__file__))
    nf_src = os.path.join(src_dir,'all_fun.nf')
    nf_config = os.path.join(src_dir,'nextflow.config')
    n_soft = 'None'
    with open(nf_config,'r') as f:
        for line in f:
            l = line.strip()
            if n_soft == 'None':
                if args.profile == 'sgeWuhanM':
                    if l.startswith('M_nextflow'):
                        n_soft = l.split('=')[1].strip().replace('"','').replace("'",'')
                elif args.profile == 'sgeWuhanG':
                    if l.startswith('G_nextflow'):
                        n_soft = l.split('=')[1].strip().replace('"','').replace("'",'')
                elif args.profile == 'sgeWuhanT':
                    if l.startswith('T_nextflow'):
                        n_soft = l.split('=')[1].strip().replace('"','').replace("'",'')
                elif args.profile == 'localNodeM':
                    if l.startswith('M_nextflow'):
                        n_soft = l.split('=')[1].strip().replace('"','').replace("'",'')
                elif args.profile == 'localNodeG':
                    if l.startswith('G_nextflow'):
                        n_soft = l.split('=')[1].strip().replace('"','').replace("'",'')
                elif args.profile == 'localNodeT':
                    if l.startswith('T_nextflow'):
                        n_soft = l.split('=')[1].strip().replace('"','').replace("'",'')
                elif args.profile == 'localBeijing':
                    if l.startswith('B_nextflow'):
                        n_soft = l.split('=')[1].strip().replace('"','').replace("'",'')
                elif args.profile == 'slurmWuda':
                    if l.startswith('Y_nextflow'):
                        n_soft = l.split('=')[1].strip().replace('"','').replace("'",'')
#    ,'Kegg_mem'
#    ,'Nr_mem'
#    ,'Uniprot_mem'
#    ,'Pfam_mem'
#    ,'Interpro_mem'
#    ,'Refseq_mem'
    if n_soft == 'None':
        check_software('nextflow')
        n_soft = 'nextflow'
    cmd_add.append('--sample_name %s'%(args.sample_name))
    cmd_add.append('--split %s'%(args.split))
    cmd_add.append('--engine %s'%(args.engine))
    cmd_add.append('--cpu %s'%(args.cpu))
    if args.run_mode == 'Genome':
        pp_pri = vars(args)
        cmd_add.append('--kingdom '+args.kingdom)
        cmd_add.append('--Phylum '+args.Phylum)
        args.pep = check_path(args.pep)
        cmd_add.append('--pep '+args.pep)
        if args.trans != 'None':
            args.trans = check_path(args.trans)
        cmd_add.append('--trans '+args.trans)
        pp_pri['kegg'] = 'run'
        pp_pri['nr'] = 'run'
        pp_pri['uniprot'] = 'run'
        pp_pri['go'] = 'run'
        pp_pri['cog'] = 'run'
        pp_pri['kog'] = 'run'
        pp_pri['pfam'] = 'run'
        if args.no_interpro == 'pass':
            pp_pri['interpro'] = 'run'
        cmd_add = get_cmd(pp_pri,cmd_add,['kegg','splitk','kcpu','maxF_k','Kegg_mem','kegg_map_soft','kegg_org','kevalue'])
        cmd_add = get_cmd(pp_pri,cmd_add,['nr','splitn','ncpu','maxF_n','Nr_mem'])
        cmd_add = get_cmd(pp_pri,cmd_add,['uniprot','splitu','ucpu','maxF_u','Uniprot_mem'])
        cmd_add = get_cmd(pp_pri,cmd_add,['go'])
        if args.kingdom == 'All' or args.kingdom == 'Archaea' or args.kingdom == 'Bacteria' or args.kingdom == 'Virus' or args.kingdom == 'B_A_V' or args.kingdom == 'B_A_F_V':
            cmd_add = get_cmd(pp_pri,cmd_add,['cog'])
        else:
            if args.cog != 'pass':
                print("WARN: Cog only run for All, Archaea, Bacteria, Virus, B_A_V, B_A_F_V !!!!")
        if args.kingdom =='All' or args.kingdom =='Fungi' or args.kingdom =='Plants' or args.kingdom =='Animals' or args.kingdom =='Human' or args.kingdom =='B_A_F_V':
            cmd_add = get_cmd(pp_pri,cmd_add,['kog'])
        else:
            if args.kog != 'pass':
                print("WARN: Kog only run for All, Fungi, Plants, Animals, Human, B_A_F_V !!!!")
        cmd_add = get_cmd(pp_pri,cmd_add,['pfam','splitp','pcpu','maxF_p','Pfam_mem'])
        cmd_add = get_cmd(pp_pri,cmd_add,['interpro','spliti','icpu','maxF_i','Interpro_mem','cutForS'])
    if args.run_mode == 'Bacteria':
        pp_pri = vars(args)
        cmd_add.append('--kingdom '+'B_A_V')
        cmd_add.append('--Phylum '+args.Phylum)
        args.pep = check_path(args.pep)
        cmd_add.append('--pep '+args.pep)
        if args.trans != 'None':
            args.trans = check_path(args.trans)
        cmd_add.append('--trans '+args.trans)
        args.gbk = check_path(args.gbk)
        cmd_add.append('--gbk '+args.gbk)
        args.genome = check_path(args.genome)
        cmd_add.append('--genome '+args.genome)
        pp_pri['kegg'] = 'run'
        pp_pri['nr'] = 'run'
        pp_pri['uniprot'] = 'run'
        pp_pri['go'] = 'run'
        pp_pri['eggnog'] = 'run'
        pp_pri['cog'] = 'run'
        pp_pri['pfam'] = 'run'
        pp_pri['refseq'] = 'run'
        pp_pri['tigerfam'] = 'run'
        pp_pri['tcdb'] = 'run'
        pp_pri['cazy'] = 'run'
        pp_pri['cyped'] = 'run'
        pp_pri['signalp'] = 'run'
        pp_pri['tmhmm'] = 'run'
        pp_pri['card'] = 'run'
        pp_pri['ardb'] = 'run'
        pp_pri['vfdb'] = 'run'
        pp_pri['phi'] = 'run'
        pp_pri['island'] = 'run'
        pp_pri['phispy'] = 'run'
        pp_pri['minced'] = 'run'
        pp_pri['antismash'] = 'run'
        cmd_add = get_cmd(pp_pri,cmd_add,['kegg','splitk','kcpu','maxF_k','Kegg_mem','kegg_map_soft','kegg_org','kevalue'])
        cmd_add = get_cmd(pp_pri,cmd_add,['nr','splitn','ncpu','maxF_n','Nr_mem'])
        cmd_add = get_cmd(pp_pri,cmd_add,['uniprot','splitu','ucpu','maxF_u','Uniprot_mem'])
        cmd_add = get_cmd(pp_pri,cmd_add,['go'])
        cmd_add = get_cmd(pp_pri,cmd_add,['eggnog','egg_cpu'])
        cmd_add = get_cmd(pp_pri,cmd_add,['cog'])
        cmd_add = get_cmd(pp_pri,cmd_add,['pfam','splitp','pcpu','maxF_p','Pfam_mem'])
        cmd_add = get_cmd(pp_pri,cmd_add,['refseq','splitr','rcpu','maxF_r','Refseq_mem'])
        cmd_add = get_cmd(pp_pri,cmd_add,['tigerfam','splitt','tcpu','maxF_t'])
        cmd_add = get_cmd(pp_pri,cmd_add,['tcdb'])
        cmd_add = get_cmd(pp_pri,cmd_add,['cazy'])
        cmd_add = get_cmd(pp_pri,cmd_add,['cyped'])
        cmd_add = get_cmd(pp_pri,cmd_add,['signalp','signalp_type','pict_Signal','maxF_Sig'])
        cmd_add = get_cmd(pp_pri,cmd_add,['tmhmm','pict_Tmhmm','maxF_Tm'])
        cmd_add = get_cmd(pp_pri,cmd_add,['card'])
        cmd_add = get_cmd(pp_pri,cmd_add,['ardb'])
        cmd_add = get_cmd(pp_pri,cmd_add,['vfdb'])
        cmd_add = get_cmd(pp_pri,cmd_add,['phi'])
        cmd_add = get_cmd(pp_pri,cmd_add,['island','island_len'])
        cmd_add = get_cmd(pp_pri,cmd_add,['phispy','phispy_len'])
        cmd_add = get_cmd(pp_pri,cmd_add,['minced'])
        pp_pri['antimode'] = 'gbk'
        cmd_add = get_cmd(pp_pri,cmd_add,['antismash','antimode'])
    if args.run_mode == 'Meta':
        pp_pri = vars(args)
        cmd_add.append('--kingdom '+'B_A_F_V')
        cmd_add.append('--Phylum '+args.Phylum)
        args.pep = check_path(args.pep)
        cmd_add.append('--pep '+args.pep)
        if args.trans != 'None':
            args.trans = check_path(args.trans)
        cmd_add.append('--trans '+args.trans)
        args.gbk = check_path(args.gbk)
        cmd_add.append('--gbk '+args.gbk)
        args.genome = check_path(args.genome)
        cmd_add.append('--genome '+args.genome)
        pp_pri['kegg'] = 'run'
        pp_pri['nr'] = 'run'
        pp_pri['uniprot'] = 'run'
        pp_pri['go'] = 'run'
        pp_pri['eggnog'] = 'run'
        pp_pri['cog'] = 'run'
        pp_pri['kog'] = 'run'
        pp_pri['pfam'] = 'run'
        pp_pri['refseq'] = 'run'
        pp_pri['tigerfam'] = 'run'
        pp_pri['tcdb'] = 'run'
        pp_pri['cazy'] = 'run'
        pp_pri['cyped'] = 'run'
        pp_pri['card'] = 'run'
        pp_pri['ardb'] = 'run'
        pp_pri['vfdb'] = 'run'
        pp_pri['phi'] = 'run'
        pp_pri['minced'] = 'run'
        cmd_add = get_cmd(pp_pri,cmd_add,['kegg','splitk','kcpu','maxF_k','Kegg_mem','kegg_map_soft','kegg_org','kevalue'])
        cmd_add = get_cmd(pp_pri,cmd_add,['nr','splitn','ncpu','maxF_n','Nr_mem'])
        cmd_add = get_cmd(pp_pri,cmd_add,['uniprot','splitu','ucpu','maxF_u','Uniprot_mem'])
        cmd_add = get_cmd(pp_pri,cmd_add,['go'])
        cmd_add = get_cmd(pp_pri,cmd_add,['eggnog','egg_cpu'])
        cmd_add = get_cmd(pp_pri,cmd_add,['cog'])
        cmd_add = get_cmd(pp_pri,cmd_add,['kog'])
        cmd_add = get_cmd(pp_pri,cmd_add,['pfam','splitp','pcpu','maxF_p','Pfam_mem'])
        cmd_add = get_cmd(pp_pri,cmd_add,['refseq','splitr','rcpu','maxF_r','Refseq_mem'])
        cmd_add = get_cmd(pp_pri,cmd_add,['tigerfam','splitt','tcpu','maxF_t'])
        cmd_add = get_cmd(pp_pri,cmd_add,['tcdb'])
        cmd_add = get_cmd(pp_pri,cmd_add,['cazy'])
        cmd_add = get_cmd(pp_pri,cmd_add,['cyped'])
        cmd_add = get_cmd(pp_pri,cmd_add,['card'])
        cmd_add = get_cmd(pp_pri,cmd_add,['ardb'])
        cmd_add = get_cmd(pp_pri,cmd_add,['vfdb'])
        cmd_add = get_cmd(pp_pri,cmd_add,['phi'])
        pp_pri['island_len'] = '7000'
        cmd_add = get_cmd(pp_pri,cmd_add,['island','island_len'])
        pp_pri['phispy_len'] = '7000'
        cmd_add = get_cmd(pp_pri,cmd_add,['phispy','phispy_len'])
        cmd_add = get_cmd(pp_pri,cmd_add,['minced'])
    if args.run_mode == 'Fungi':
        pp_pri = vars(args)
        cmd_add.append('--kingdom '+'Fungi')
        cmd_add.append('--Phylum '+args.Phylum)
        args.pep = check_path(args.pep)
        cmd_add.append('--pep '+args.pep)
        if args.trans != 'None':
            args.trans = check_path(args.trans)
        cmd_add.append('--trans '+args.trans)
        args.gff = check_path(args.gff)
        cmd_add.append('--gff '+args.gff)
        args.genome = check_path(args.genome)
        cmd_add.append('--genome '+args.genome)
        pp_pri['kegg'] = 'run'
        pp_pri['nr'] = 'run'
        pp_pri['uniprot'] = 'run'
        pp_pri['go'] = 'run'
        pp_pri['eggnog'] = 'run'
        pp_pri['cog'] = 'run'
        pp_pri['kog'] = 'run'
        pp_pri['pfam'] = 'run'
        pp_pri['interpro'] = 'run'
        pp_pri['refseq'] = 'run'
        pp_pri['tigerfam'] = 'run'
        pp_pri['tcdb'] = 'run'
        pp_pri['cazy'] = 'run'
        pp_pri['cyped'] = 'run'
        pp_pri['signalp'] = 'run'
        pp_pri['tmhmm'] = 'run'
        pp_pri['card'] = 'run'
        pp_pri['ardb'] = 'run'
        pp_pri['vfdb'] = 'run'
        pp_pri['phi'] = 'run'
        pp_pri['antismash'] = 'run'
        cmd_add = get_cmd(pp_pri,cmd_add,['kegg','splitk','kcpu','maxF_k','Kegg_mem','kegg_map_soft','kegg_org','kevalue'])
        cmd_add = get_cmd(pp_pri,cmd_add,['nr','splitn','ncpu','maxF_n','Nr_mem'])
        cmd_add = get_cmd(pp_pri,cmd_add,['uniprot','splitu','ucpu','maxF_u','Uniprot_mem'])
        cmd_add = get_cmd(pp_pri,cmd_add,['go'])
        cmd_add = get_cmd(pp_pri,cmd_add,['eggnog','egg_cpu'])
        cmd_add = get_cmd(pp_pri,cmd_add,['cog'])
        cmd_add = get_cmd(pp_pri,cmd_add,['kog'])
        cmd_add = get_cmd(pp_pri,cmd_add,['pfam','splitp','pcpu','maxF_p','Pfam_mem'])
        cmd_add = get_cmd(pp_pri,cmd_add,['interpro','spliti','icpu','maxF_i','Interpro_mem','cutForS'])
        cmd_add = get_cmd(pp_pri,cmd_add,['refseq','splitr','rcpu','maxF_r','Refseq_mem'])
        cmd_add = get_cmd(pp_pri,cmd_add,['tigerfam','splitt','tcpu','maxF_t'])
        cmd_add = get_cmd(pp_pri,cmd_add,['tcdb'])
        cmd_add = get_cmd(pp_pri,cmd_add,['cazy'])
        cmd_add = get_cmd(pp_pri,cmd_add,['cyped'])
        cmd_add = get_cmd(pp_pri,cmd_add,['signalp','signalp_type','pict_Signal','maxF_Sig'])
        cmd_add = get_cmd(pp_pri,cmd_add,['tmhmm','pict_Tmhmm','maxF_Tm'])
        cmd_add = get_cmd(pp_pri,cmd_add,['card'])
        cmd_add = get_cmd(pp_pri,cmd_add,['ardb'])
        cmd_add = get_cmd(pp_pri,cmd_add,['vfdb'])
        cmd_add = get_cmd(pp_pri,cmd_add,['phi'])
        pp_pri['antimode'] = 'fasta_gff'
        cmd_add = get_cmd(pp_pri,cmd_add,['antismash','antimode'])
    if args.run_mode == 'Transcrip':
        pp_pri = vars(args)
        cmd_add.append('--kingdom '+args.kingdom)
        cmd_add.append('--Phylum '+args.Phylum)
        args.pep = check_path(args.pep)
        cmd_add.append('--pep '+args.pep)
        if args.trans != 'None':
            args.trans = check_path(args.trans)
        cmd_add.append('--trans '+args.trans)
        pp_pri['kegg'] = 'run'
        pp_pri['nr'] = 'run'
        pp_pri['uniprot'] = 'run'
        pp_pri['go'] = 'run'
        pp_pri['cog'] = 'run'
        pp_pri['kog'] = 'run'
        pp_pri['pfam'] = 'run'
        pp_pri['tf'] = 'run'
        cmd_add = get_cmd(pp_pri,cmd_add,['kegg','splitk','kcpu','maxF_k','Kegg_mem','kegg_map_soft','kegg_org','kevalue'])
        cmd_add = get_cmd(pp_pri,cmd_add,['nr','splitn','ncpu','maxF_n','Nr_mem'])
        cmd_add = get_cmd(pp_pri,cmd_add,['uniprot','splitu','ucpu','maxF_u','Uniprot_mem'])
        cmd_add = get_cmd(pp_pri,cmd_add,['go'])
        if args.kingdom == 'All' or args.kingdom == 'Archaea' or args.kingdom == 'Bacteria' or args.kingdom == 'Virus' or args.kingdom == 'B_A_V' or args.kingdom == 'B_A_F_V':
            cmd_add = get_cmd(pp_pri,cmd_add,['cog'])
        else:
            if args.cog != 'pass':
                print("WARN: Cog only run for All, Archaea, Bacteria, Virus, B_A_V, B_A_F_V !!!!")
        if args.kingdom =='All' or args.kingdom =='Fungi' or args.kingdom =='Plants' or args.kingdom =='Animals' or args.kingdom =='Human' or args.kingdom =='B_A_F_V':
            cmd_add = get_cmd(pp_pri,cmd_add,['kog'])
        else:
            if args.kog != 'pass':
                print("WARN: Kog only run for All, Fungi, Plants, Animals, Human, B_A_F_V !!!!")
        cmd_add = get_cmd(pp_pri,cmd_add,['pfam','splitp','pcpu','maxF_p','Pfam_mem'])
        if args.kingdom == 'Animals' or args.kingdom == 'Plants' or args.kingdom == 'Human':
            cmd_add = get_cmd(pp_pri,cmd_add,['tf'])
        else:
            if args.tf != 'pass':
                print("WARN: TF only run for Plants or Animals !!!!")
    if args.run_mode == 'Normal':
        pp_pri = vars(args)
        cmd_add.append('--kingdom '+args.kingdom)
        cmd_add.append('--Phylum '+args.Phylum)
        if args.kegg != 'pass' or args.nr != 'pass' or args.uniprot != 'pass' \
        or args.go != 'pass' or args.pfam != 'pass' or args.interpro != 'pass' \
        or args.refseq != 'pass' or args.tigerfam != 'pass' or args.tcdb != 'pass' \
        or args.cazy != 'pass' or args.cyped != 'pass' or args.signalp != 'pass' \
        or args.tmhmm != 'pass' or args.deeploc != 'pass' or args.card != 'pass' \
        or args.ardb != 'pass' or args.vfdb != 'pass' or args.phi != 'pass' \
        or args.tf != 'pass' or args.eggnog != 'pass':
            args.pep = check_path(args.pep)
            cmd_add.append('--pep '+args.pep)
            if args.trans != 'None':
                args.trans = check_path(args.trans)
            cmd_add.append('--trans '+args.trans)
        cmd_add.append('--map_soft %s'%(args.map_soft))
        if args.map_soft == 'blastp':
            if args.island != 'pass' or args.phispy != 'pass' or (args.antismash != 'pass' and args.antimode == 'gbk'):
                args.gbk = check_path(args.gbk)
                cmd_add.append('--gbk '+args.gbk)
            if args.minced != 'pass' or (args.antismash != 'pass' and (args.antimode == 'fasta' or args.antimode == 'fasta_gff')):
                args.genome = check_path(args.genome)
                cmd_add.append('--genome '+args.genome)
            cmd_add = get_cmd(pp_pri,cmd_add,['kegg','splitk','kcpu','maxF_k','Kegg_mem','kegg_map_soft','kegg_org','kevalue'])
            cmd_add = get_cmd(pp_pri,cmd_add,['nr','splitn','ncpu','maxF_n','Nr_mem'])
            cmd_add = get_cmd(pp_pri,cmd_add,['uniprot','splitu','ucpu','maxF_u','Uniprot_mem'])
            if args.uniprot == "pass":
                if args.go != "pass":
                    cmd_add = get_cmd(pp_pri,cmd_add,['go','splitu','ucpu','maxF_u','Uniprot_mem'])
            else:
                cmd_add = get_cmd(pp_pri,cmd_add,['go'])
            cmd_add = get_cmd(pp_pri,cmd_add,['eggnog','egg_cpu'])
            if args.kingdom == 'All' or args.kingdom == 'Archaea' or args.kingdom == 'Bacteria' or args.kingdom == 'Virus' or args.kingdom == 'B_A_V' or args.kingdom == 'B_A_F_V':
                if args.uniprot == "pass" and args.go == "pass":
                    cmd_add = get_cmd(pp_pri,cmd_add,['cog','splitu','ucpu','maxF_u','Uniprot_mem'])
                else:
                    cmd_add = get_cmd(pp_pri,cmd_add,['cog'])
            else:
                if args.cog != 'pass':
                    print("WARN: Cog only run for All, Archaea, Bacteria, Virus, B_A_V, B_A_F_V !!!!")
            if args.kingdom =='All' or args.kingdom =='Fungi' or args.kingdom =='Plants' or args.kingdom =='Animals' or args.kingdom =='Human' or args.kingdom =='B_A_F_V':
                if args.uniprot == "pass" and args.go == "pass":
                    cmd_add = get_cmd(pp_pri,cmd_add,['kog','splitu','ucpu','maxF_u','Uniprot_mem'])
                else:
                    cmd_add = get_cmd(pp_pri,cmd_add,['kog'])
            else:
                if args.kog != 'pass':
                    print("WARN: Kog only run for All, Fungi, Plants, Animals, Human, B_A_F_V !!!!")
            cmd_add = get_cmd(pp_pri,cmd_add,['pfam','splitp','pcpu','maxF_p','Pfam_mem'])
            cmd_add = get_cmd(pp_pri,cmd_add,['interpro','spliti','icpu','maxF_i','Interpro_mem','cutForS'])
            cmd_add = get_cmd(pp_pri,cmd_add,['refseq','splitr','rcpu','maxF_r','Refseq_mem'])
            if args.kingdom == 'Animals' or args.kingdom == 'Plants' or args.kingdom == 'Human':
                cmd_add = get_cmd(pp_pri,cmd_add,['tf'])
            else:
                if args.tf != 'pass':
                    print("WARN: TF only run for Plants or Animals !!!!")
            cmd_add = get_cmd(pp_pri,cmd_add,['tigerfam','splitt','tcpu','maxF_t'])
            cmd_add = get_cmd(pp_pri,cmd_add,['tcdb'])
            cmd_add = get_cmd(pp_pri,cmd_add,['cazy'])
            cmd_add = get_cmd(pp_pri,cmd_add,['cyped'])
            cmd_add = get_cmd(pp_pri,cmd_add,['signalp','signalp_type','pict_Signal','maxF_Sig'])
            cmd_add = get_cmd(pp_pri,cmd_add,['tmhmm','pict_Tmhmm','maxF_Tm'])
            cmd_add = get_cmd(pp_pri,cmd_add,['deeploc','maxF_d'])
            cmd_add = get_cmd(pp_pri,cmd_add,['card'])
            cmd_add = get_cmd(pp_pri,cmd_add,['ardb'])
            cmd_add = get_cmd(pp_pri,cmd_add,['vfdb'])
            cmd_add = get_cmd(pp_pri,cmd_add,['phi'])
            cmd_add = get_cmd(pp_pri,cmd_add,['island','island_len'])
            cmd_add = get_cmd(pp_pri,cmd_add,['phispy','phispy_len'])
            cmd_add = get_cmd(pp_pri,cmd_add,['minced'])
            if args.antimode == 'fasta_gff':
                args.gff = check_path(args.gff)
                cmd_add.append('--gff '+args.gff)
            if args.kingdom in ['Archaea', 'Bacteria', 'B_A_V', 'Fungi', 'B_A_F_V']:
                cmd_add = get_cmd(pp_pri,cmd_add,['antismash','antimode'])
            else:
                if args.antismash != 'pass':
                    print("WARN: antismash only run for Archaea, Bacteria, B_A_V, Fungi, B_A_F_V !!!!")
        else:
            cmd_add = get_cmd(pp_pri,cmd_add,['kegg','splitk','kcpu','maxF_k','Kegg_mem','kegg_map_soft','kegg_org','kevalue'])
            cmd_add = get_cmd(pp_pri,cmd_add,['nr','splitn','ncpu','maxF_n','Nr_mem'])
            cmd_add = get_cmd(pp_pri,cmd_add,['uniprot','splitu','ucpu','maxF_u','Uniprot_mem'])
            if args.uniprot == "pass":
                if args.go != "pass":
                    cmd_add = get_cmd(pp_pri,cmd_add,['go','splitu','ucpu','maxF_u','Uniprot_mem'])
            else:
                cmd_add = get_cmd(pp_pri,cmd_add,['go'])
            if args.eggnog != 'pass':
                print("WARN: eggnog not for nucleic acid, will use uniprot result !!!!")
            if args.kingdom == 'All' or args.kingdom == 'Archaea' or args.kingdom == 'Bacteria' or args.kingdom == 'Virus' or args.kingdom == 'B_A_V' or args.kingdom == 'B_A_F_V':
                if args.uniprot == "pass" and args.go == "pass":
                    cmd_add = get_cmd(pp_pri,cmd_add,['cog','splitu','ucpu','maxF_u','Uniprot_mem'])
                else:
                    cmd_add = get_cmd(pp_pri,cmd_add,['cog'])
            else:
                if args.cog != 'pass':
                    print("WARN: Cog only run for All, Archaea, Bacteria, Virus, B_A_V, B_A_F_V !!!!")
            if args.kingdom =='All' or args.kingdom =='Fungi' or args.kingdom =='Plants' or args.kingdom =='Animals' or args.kingdom =='Human' or args.kingdom =='B_A_F_V':
                if args.uniprot == "pass" and args.go == "pass":
                    cmd_add = get_cmd(pp_pri,cmd_add,['kog','splitu','ucpu','maxF_u','Uniprot_mem'])
                else:
                    cmd_add = get_cmd(pp_pri,cmd_add,['kog'])
            else:
                if args.kog != 'pass':
                    print("WARN: Kog only run for All, Fungi, Plants, Animals, Human, B_A_F_V !!!!")
            cmd_add = get_cmd(pp_pri,cmd_add,['refseq','splitr','rcpu','maxF_r','Refseq_mem'])
#output
    cmd_add.append('--regular_out '+args.regular_out)
    cmd_add.append('--specific_out '+args.specific_out)
    cmd_add.append('--element_out '+args.element_out)
#add nextflow info
    if args.bg == 'y':
        cmd_add.append('-bg')
    cmd_add.append('-profile %s'%(args.profile))
    if args.nhp == 'y':
        nohup_info = '-ansi-log false'
    else:
        nohup_info = ''
    if args.Distributed == "y":
        n_soft = 'NXF_OPTS="-Dleveldb.mmap=false" '+n_soft
    run_start = show_info("==========Run fun anno is start!==========")
    cmd = 'cd %s && %s run %s %s %s --queueq %s -with-trace -resume'%(
        args.work_dicr,n_soft,nf_src,' '.join(cmd_add),nohup_info,args.queueq)
    work_sh = os.path.join(args.work_dicr,'nextflow_run.sh')
    with open(work_sh,'w') as f:
        f.write(cmd + '\n')
    print(cmd)
    run_cmd(cmd)
    run_time(run_start)
if __name__ == '__main__':
    try:
        t1 = time.time()
        time1 = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(t1))
        main()
        t2 = time.time()
        time2 = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(t2))
        run_time(t1)
    except KeyboardInterrupt:
        sys.stderr.write("User interrupt me! ;-) See you!\n")
        sys.exit(0)
