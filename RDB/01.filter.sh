raw_data=A1.fastq.gz
sample=A1

java -cp TBtools_JRE1.6.jar biocjava.sRNA.Tools.sRNAseqAdaperRemover --minLen 17 --inFxFile $raw_data --outFaFile 01.filter/$sample.fa
perl bin/deredundancy.pl 01.filter/$sample.fa seq 01.filter/$sample.collapsed.fa