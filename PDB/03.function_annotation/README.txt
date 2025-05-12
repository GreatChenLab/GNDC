必须软件：
ncbi-blastp
diamond
hmmscan
hmmsearch
kofam数据库
uniprot数据库

运行命令：
#-kingdom 控制物种范围，可选Archaea, Bacteria, Fungi, Plants, Animals, Virus, Human
#-Phylum 如果kingdom选择 Animals，可以运行python3 all_fun.py --classList 选择该参数输入，判断详细动物分类
profile=slurmWuhanG
queueq=all.q
samplename=test
kingdom=Plants
Phylum=Plants
pep=`ls *.pep.fa`
out=Result

python3 all_fun.py \
-profile ${profile} \
-run_mode Genome \
-kingdom ${kingdom} \
-Phylum ${Phylum} \
-pep ${pep} \
-regular_out ${out} \
-queue ${queueq} \
-Kegg_mem 10 \
-Nr_mem 10 \
-Uniprot_mem 10 \
-Pfam_mem 10 \
-Interpro_mem 20 \
-sample_name ${samplename}
