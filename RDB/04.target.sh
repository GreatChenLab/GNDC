mRNA=Homo_sapiens.mRNA.fa
miRNA=03.predict/A1/A1.mature.fa
sample=A1

mkdir 04.target
RNAhybrid -c -p 0.05 -s 3utr_human -t $mRNA -q $miRNA >04.target/$sample.RNAhybrid.out
less 04.target/$sample.RNAhybrid.out |grep -v "target too long" >04.target/$sample.RNAhybrid.target.out
less 04.target/$sample.RNAhybrid.target.out |awk -F ":" '{print $3"\t"$1"\t"$5"\t"$6}'|uniq >04.target/$sample.target.out.xls
sed -i '1i\miRNA\tTarget_mRNA\tEnergy\tpvalue' 04.target/$sample.target.out.xls