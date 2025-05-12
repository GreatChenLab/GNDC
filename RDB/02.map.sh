genome=ath.fa
index=ath
collapsed_data=01.filter/A1.collapsed.fa
sample=A1

mkdir genome_index
mkdir 02.map
mirdeep2/bin/bowtie-build $genome genome_index/$index
perl mirdeep2/bin/mapper.pl $collapsed_data -c -p genome_index/$index -t 02.map/$sample.reads_vs_genome.arf -v