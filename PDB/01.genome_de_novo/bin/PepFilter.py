#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
from Bio.Data import CodonTable
import sys


def get_amino_acids_from_codons(start_codons):
    """
    将起始密码子转换为对应的氨基酸
    
    参数:
    start_codons (str): 逗号分隔的密码子字符串
    
    返回:
    set: 对应的氨基酸集合
    """
    try:
        # 获取标准密码子表
        standard_table = CodonTable.standard_dna_table
        
        # 将输入的密码子分割并转换为大写
        codons = [codon.strip().upper() for codon in start_codons.split(',')]
        
        # 获取对应的氨基酸
        amino_acids = set()
        for codon in codons:
            try:
                aa = standard_table.forward_table[codon]
                amino_acids.add(aa)
            except KeyError:
                print(f"警告: 无法识别的密码子 '{codon}'", file=sys.stderr)
        
        return amino_acids
    
    except Exception as e:
        print(f"转换密码子时发生错误: {str(e)}", file=sys.stderr)
        sys.exit(1)


def has_long_repeats(sequence, max_repeats=6):
    """
    检查序列中是否存在连续重复的氨基酸
    
    参数:
    sequence (str): 氨基酸序列
    max_repeats (int): 允许的最大连续重复次数
    
    返回:
    bool: 如果存在超过max_repeats的连续重复氨基酸返回True，否则返回False
    """
    if len(sequence) < max_repeats:
        return False
        
    current_aa = sequence[0]
    repeat_count = 1
    
    for aa in sequence[1:]:
        if aa == current_aa:
            repeat_count += 1
            if repeat_count >= max_repeats:
                return True
        else:
            current_aa = aa
            repeat_count = 1
    
    return False
        
        
def filter_fasta_by_start_aa(input_file, output_file, allowed_aa, min_length=None, max_length=None):
    """
    过滤FASTA文件，只保留以指定氨基酸开头且符合长度要求的蛋白质序列
    同时排除具有长连续重复氨基酸的序列
    
    参数:
    input_file (str): 输入FASTA文件路径
    output_file (str): 输出FASTA文件路径
    allowed_aa (set): 允许的起始氨基酸集合
    min_length (int): 最小序列长度，None表示不限制
    max_length (int): 最大序列长度，None表示不限制
    """
    try:
        sequences_count = 0
        filtered_count = 0
        repeat_filtered_count = 0
        
        with open(output_file, 'w') as out_f:
            with open(input_file, 'r') as in_f:
                current_header = ''
                current_sequence = ''
                keep_sequence = False
                
                for line in in_f:
                    line = line.strip()
                    
                    if line.startswith('>'):
                        # 处理前一个序列
                        if current_sequence:
                            sequences_count += 1
                            seq_length = len(current_sequence)
                            length_ok = True
                            
                            if min_length is not None and seq_length < min_length:
                                length_ok = False
                            if max_length is not None and seq_length > max_length:
                                length_ok = False
                            
                            # 检查重复氨基酸
                            has_repeats = has_long_repeats(current_sequence)
                            if has_repeats:
                                repeat_filtered_count += 1
                            
                            if keep_sequence and length_ok and not has_repeats:
                                out_f.write(current_header + '\n')
                                out_f.write(current_sequence + '\n')
                                filtered_count += 1
                        
                        # 重置变量
                        current_header = line
                        current_sequence = ''
                        keep_sequence = False
                    
                    else:
                        current_sequence += line
                        # 检查序列的第一个氨基酸
                        if not keep_sequence and current_sequence:
                            keep_sequence = current_sequence[0] in allowed_aa
                
                # 处理最后一个序列
                if current_sequence:
                    sequences_count += 1
                    seq_length = len(current_sequence)
                    length_ok = True
                    
                    if min_length is not None and seq_length < min_length:
                        length_ok = False
                    if max_length is not None and seq_length > max_length:
                        length_ok = False
                    
                    # 检查重复氨基酸
                    has_repeats = has_long_repeats(current_sequence)
                    if has_repeats:
                        repeat_filtered_count += 1
                    
                    if keep_sequence and length_ok and not has_repeats:
                        out_f.write(current_header + '\n')
                        out_f.write(current_sequence + '\n')
                        filtered_count += 1
        
        # 打印统计信息
        print(f"处理完成:")
        print(f"总序列数: {sequences_count}")
        print(f"保留序列数: {filtered_count}")
        print(f"因起始氨基酸或长度不符被过滤的序列数: {sequences_count - filtered_count - repeat_filtered_count}")
        print(f"因连续重复氨基酸被过滤的序列数: {repeat_filtered_count}")
        print(f"结果已保存至: {output_file}")
    
    except FileNotFoundError:
        print(f"错误：找不到输入文件 '{input_file}'", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"处理FASTA文件时发生错误: {str(e)}", file=sys.stderr)
        sys.exit(1)


def main():
    # 设置命令行参数
    parser = argparse.ArgumentParser(description='根据起始密码子过滤FASTA序列')
    parser.add_argument('-i', '--input', required=True,
                        help='输入FASTA文件路径')
    parser.add_argument('-o', '--output', required=True,
                        help='输出FASTA文件路径')
    parser.add_argument('--start', required=True,
                        help='起始密码子，多个密码子用逗号分隔 (例如: ATG 或 ATG,TTG,CTG)')
    parser.add_argument('--size', help='序列长度范围，格式为"最小长度,最大长度"。可以省略其中一个值，例如："5,75"、"5,"、",100"')
    
    args = parser.parse_args()
    
    # 处理size参数
    min_length = None
    max_length = None
    if args.size:
        size_parts = args.size.split(',')
        if len(size_parts) == 2:
            if size_parts[0]:
                min_length = int(size_parts[0])
            if size_parts[1]:
                max_length = int(size_parts[1])
    
    # 获取允许的起始氨基酸
    allowed_aa = get_amino_acids_from_codons(args.start)
    if not allowed_aa:
        print("错误：未能识别任何有效的起始密码子", file=sys.stderr)
        sys.exit(1)
    
    print(f"允许的起始氨基酸: {', '.join(sorted(allowed_aa))}")
    if min_length is not None or max_length is not None:
        print(f"序列长度限制: {min_length if min_length is not None else '不限'} - {max_length if max_length is not None else '不限'}")
    
    # 过滤序列
    filter_fasta_by_start_aa(args.input, args.output, allowed_aa, min_length, max_length)


if __name__ == "__main__":
    main()

