必须软件：
docker
python3
dos2unix
nextflow
fastp
hisat2
samtools
minimap2
smrtlink
stringtie
TransDecoder

运行命令：
nextflow run 00.nf/transcript.nf \
-with-trace -resume \
-profile slurm_docker \
--queueq all.q \
--run_small y \
--genome genome.fa \
--sample_name Plants \
--data_set NGS \
--NGS_data rna2nd \
--split_trans n \
--fastp_cpu 16 \
--fastqc_cpu 16 \
--hisat2_build_cpu 16 \
--hisat2_cpu 16 \
--NGS_samtools_cpu 8 \
--NGS_stringtie_cpu 16 \
--nf_tmp result

注：genome.fa：基因组文件；rna2nd：二代数据输入目录；结果输出 result/03.Transcript/gff/amino_acids_5_75/。