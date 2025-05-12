必须软件：
python3
nextflow
orfipy
cd-hit

运行命令：
nextflow run all_orf.nf \
-with-trace -resume \
--queueq xhhctdnormal \
--genome_dddir ../../genome/ \
-qs 30

注：../../genome/：基因组文件路径；结果输出 Result/01.orf/*/*.peptide*.fa。