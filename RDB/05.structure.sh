sample=A1
miRNA_hairpin=03.predict/A1/A1.hairpin.fa


mkdir -p $sample/$sample.hairpin_structure/
cd $sample
RNAfold -p -i $miRNA_hairpin >$sample.hairpin_structure/$sample.res

mv *ps $sample.hairpin_structure/
### relplot.pl 可视化二级结构
cd $sample.hairpin_structure/
ls *ss.ps |awk -v FS="_ss." '{print "ViennaRNA-2.6.1/src/Utils/relplot.pl "$1"_ss.ps "$1"_dp.ps >"$1".ps; convert -density 300 "$1".ps "$1".pdf; convert -density 300 "$1".pdf "$1".png"}' |sh