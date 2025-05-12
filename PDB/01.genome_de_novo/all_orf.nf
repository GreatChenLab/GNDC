
//--queueq
//--genome_dddir


Channel
    .fromFilePairs( "${params.genome_dddir}/*.{fa,fasta}", size: 1 )
    .ifEmpty { exit 1, "Cannot find any reads matching: ${params.genome_dddir}."}
    .set {pass_genome2}

soft_bin = "${projectDir}/bin"

process run_orf{
	publishDir "Result/01.orf/${gg}", mode: 'link'
	tag "${gg}"
	executor "slurm"
	errorStrategy "ignore"
	queue "${params.queueq}"
	cpus 30
	input:
		set val(gg),path(genome) from pass_genome2
	output:
		path "${gg}.peptide.fa"
		path "${gg}.peptide.rmdup.fa"
	script:
		"""
		orfipy ${genome} --min 15 --max 1000000 --chunk-size 100 --start ATG,TTG,CTG,GTG --outdir orfipy --bed12 ${genome}.bed --pep ${genome}.peptide.fa --procs 30
		mv orfipy/*.peptide.fa ${genome}.peptide.fa
		python3 ${soft_bin}/PepFilter.py -i ${genome}.peptide.fa -o ${gg}.peptide.fa --start ATG --size 5,75
		cd-hit -i ${gg}.peptide.fa -o ${gg}.peptide.rmdup.fa -c 0.5 -n 3 -l 4 -T 8 -M 20000
		"""
}
