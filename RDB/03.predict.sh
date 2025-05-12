collapsed_data=01.filter/A1.collapsed.fa
genome=ath.fa
mapped=02.map/A1.reads_vs_genome.arf
mature=none
other_mature=plant.mature.fa
hairpin=none
sample=A1


mkdir -p 03.predict/$sample
cd 03.predict/$sample

perl /mirdeep2/bin/miRDeep2.pl $collapsed_data $genome $mapped $mature $other_mature $hairpin 2>$sample.miRDeep2_novel.log 

perl bin/mirdeep2_5p_3p.pl result_*.csv >$sample.novel_miRNA.table
awk '{if($0 !~ /^#/){ if($5 == "5p"){print ">"$1"\n"$2}else if($5 == "3p"){print ">"$1"\n"$3}}}' $sample.novel_miRNA.table >$sample.mature.fa
awk '{if($0 !~ /^#/){ print ">"$1"\n"$4}}' $sample.novel_miRNA.table >$sample.hairpin.fa