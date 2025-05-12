#!/bin/bash

mkdir -p split_output

for infile in 0.raw_data/*clean.fa
do
  base_name=$(basename "$infile")
  echo "正在拆分文件: $infile"
  (
    seqkit split2 -l 500k "$infile"
    
    mv "${infile}.split/"*.part_*.fa split_output/
    
    rm -rf "${infile}.split"
    
    echo "已完成拆分: $infile"
  ) &
done

wait
echo "所有文件拆分完成，结果保存在 split_output 目录中"

