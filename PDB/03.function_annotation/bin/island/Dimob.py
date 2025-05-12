#!/usr/bin/env python3
# -*- coding: utf-8 -*-

##导入模块，初始传递命令、变量等
import os, argparse
import subprocess as sp

parser = argparse.ArgumentParser(description = '\n该命令用于预测基因岛（调用 GeneIslands/Dimob.pl）', add_help = False, usage = '\npython3 GI_predict.py -i [genome.gbk] -d [Dimob.pl] -o [output_dir]')
required = parser.add_argument_group('必选项')
optional = parser.add_argument_group('可选项')
required.add_argument('-i', '--input', metavar = '[genome.gbk]', help = 'gbk 格式的基因组信息文件', required = True)
required.add_argument('-d', '--dimob', metavar = '[Dimob.pl]', help = 'GeneIslands 主脚本 Dimob.pl 路径', required = True)
optional.add_argument('-o', '--output', metavar = '[output_dir]', default = os.getcwd(), help = '结果输出路径，默认当前路径', required = False)
optional.add_argument('-h', '--help', action = "help", help = "帮助信息")
args = parser.parse_args()

##创建结果路径
os.makedirs(args.output, exist_ok = True)

##依据 genome_contigs 分割 gbk 文件
new_file_name = []
with open(args.input, 'r') as read_file:
	for line in read_file:
		line = line.strip('\n')
		if line[0:5] == 'LOCUS':
			if (new_file_name):
				new_file.close()
			seq_ID = line.split()[1]
			new_file_name.append(seq_ID)
			new_file = open(f'{args.output}/{seq_ID}.gbk', 'w')
			print(line, file = new_file)
		else:
			print(line, file = new_file)

new_file.close()
read_file.close()

##基因岛预测
for seq_ID in new_file_name:
	try:
		sp.run(f'{args.dimob} {args.output}/{seq_ID}.gbk {args.output}/{seq_ID}.txt', shell=True, check=True)
	except:
		sp.Popen(f'touch {args.output}/{seq_ID}.txt', shell=True)

aa = os.path.basename(args.input)
new_file = open(f'{args.output}/{aa}.GI_all.txt', 'w')
#print('GI_ID\tseq_ID\tstart\tend\tGI_length', file = new_file)
i = 1
for seq_ID in new_file_name:
	result_file = f'{args.output}/{seq_ID}.txt'
	if os.path.getsize(result_file):
		with open(result_file, 'r') as read_file:
			for line in read_file:
				line = line.strip().split('\t')
				GI_ID = f'GI{i}'
				GI_length = abs(int(line[2]) - int(line[1])) + 1
				print(f'{GI_ID}\t{seq_ID}\t{line[1]}\t{line[2]}\t{GI_length}', file = new_file)
				i = i + 1

read_file.close()
new_file.close()
