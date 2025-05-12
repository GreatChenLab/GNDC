#!/usr/bin/env python3
# -*- coding: utf-8 -*-

##导入模块，初始传递命令、变量等
import os, argparse
import subprocess as sp
import re

parser = argparse.ArgumentParser(description = '\n切分gbk文件用于噬菌体预测', add_help = False, usage = '\nCool')
required = parser.add_argument_group('必选项')
optional = parser.add_argument_group('可选项')
required.add_argument('-i', '--input', metavar = '[genome.gbk]', help = 'gbk 格式的基因组信息文件', required = True)
optional.add_argument('-s', '--split', metavar = '[split]', default = '4000', help = '切分阈值', required = False)
optional.add_argument('-o', '--output', metavar = '[output_dir]', default = './', help = '结果输出路径，默认当前路径', required = False)
optional.add_argument('-h', '--help', action = "help", help = "帮助信息")
args = parser.parse_args()

##创建结果路径
os.makedirs(args.output, exist_ok = True)

ll_len = int(args.split)
##依据 genome_contigs 分割 gbk 文件
#new_file_name = []
flag = 0
file_name = 1
with open(args.input, 'r') as read_file:
	for line in read_file:
		line = line.strip('\n')
		if line[0:5] == 'LOCUS':
			l = line.strip('\n')
			try:
				lentt = int(re.split('\s+',l)[2])
			except ValueError:
				continue
			if lentt >= ll_len:
				flag += 1
				if flag >= 5001:
					flag = 1
					new_file.close()
					file_name += 1
					file_name_str = str(file_name)
					new_file = open(f'{args.output}/ctg{file_name_str}.gbk', 'w')
				elif flag == 1:
					file_name_str = str(file_name)
					new_file = open(f'{args.output}/ctg{file_name_str}.gbk', 'w')
				print(line, file = new_file)
		else:
			if lentt >= ll_len:
				print(line, file = new_file)
if flag == 0:
	os.system('touch %s/tmp.gbk'%(args.output))

new_file.close()
read_file.close()

