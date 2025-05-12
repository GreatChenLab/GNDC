#!/bin/bash

for file in 0.raw_data/*.fa
do
    output_file="${file%.*}.clean.fa"
    (
        seqkit grep -v -s -p "X" -p "." "$file" | sed 's|\*$||g' > "$output_file"
        echo "已处理 $file，结果保存至 $output_file"
    ) &
done

wait
echo "all final"
