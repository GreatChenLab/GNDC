#!/bin/env nextflow
/*
 * print usage
 */
 // v1.0   2022.3.10    first version
 // v1.1   2023.7.26    change kegg kobas to kofamscan
if(params.help || params.h){
log.info """\033[NEXTFLOW SCRIPT]
\033[42;33m                 _____ _   _ _   _  ____ _____ ___ ___  _   _                 \033[1m\033[0m
\033[42;33m                |  ___| | | | \\ | |/ ___|_   _|_ _/ _ \\| \\ | |                \033[1m\033[0m
\033[42;33m                | |_  | | | |  \\| | |     | |  | | | | |  \\| |                \033[1m\033[0m
\033[42;33m                |  _| | |_| | |\\  | |___  | |  | | |_| | |\\  |                \033[1m\033[0m
\033[42;33m                |_|    \\___/|_| \\_|\\____| |_| |___\\___/|_| \\_|                \033[1m\033[0m
\033[42;33m                                                                              \033[1m\033[0m
\033[43;32m              A Nextflow Pipline For function annotation Analysis             \033[1m\033[0m
\033[43;32m                    . Author  : Pengyu Fan                                    \033[1m\033[0m
\033[43;32m                    . Email   : fanpengyu@alumni.hust.edu.cn                  \033[1m\033[0m
\033[43;32m                    . Version : v1.1                                          \033[1m\033[0m
\033[43;32m                    . Update  : 2023.7.26                                     \033[1m\033[0m
\033[40;31m\033[1m
Usage:
nextflow run all_fun.nf --pep in.pep.fa --trans in.trans.fa [] -with-trace -resume
\033[0m
\033[40;36m
Options:
==========Basic==========
  --help/--h       Show this message and exit.
##Choose profile
  -profile         Different servers use different configurations, choose from [sgeWuhan,localNode]
##regularDB Output Dir
  --regular_out    <str>   the regularDB output dir                                              [${params.regular_out}]
##specificDB Output Dir
  --specific_out   <str>   the specificDB output dir                                             [${params.specific_out}]
##element Output Dir
  --element_out    <str>   the element output dir                                                [${params.element_out}]
##Pep Seq file input
  --pep            <str>   input pep file                                                        
  --trans          <str>   input transcript file                                                 [${params.trans}]
  --sample_name    <str>   sample/species name ex: Arabidopsis_thaliana                          [${params.sample_name}]
  --kingdom        <str>   choose from [All, Archaea, Bacteria, Fungi, Plants, Animals, Virus, Human, B_A_V, B_A_F_V]
                           B_A_V = Bacteria+Archaea+Virus;B_A_F_V = Bacteria+Archaea+Virus+Fungi [${params.kingdom}]
  --Phylum         <str>   if kingdom choose Animal,Please select one of the following to enter: [${params.Phylum}]
  --split          <int>   split the input into X file                                           [${params.split}]
  --engine         <str>   which blast use for ardb/vfdb/phi, choose from [diamond,ncbiblast]    [${params.engine}]
  --cpu            <int>   normal blastp/hmmscan use cpu number out of kegg,nr,uniprot,pfam      [${params.cpu}]
  --map_soft       <str>   use blastp or blastx                                                  [${params.map_soft}]
##Kegg annot
  --kegg           <bool>  if run kegg annot ,add --kegg behind command line                     [${params.kegg}]
  --kegg_org       <str>   单个物种注释，输入物种kegg官网上的缩写，例如人类 hsa                      [${params.kegg_org}]
  --kevalue        <str>   kegg evalue                                                           [${params.kevalue}]
  --kegg_map_soft  <str>   use hmmscan or hmmsearch or blastp                                    [${params.kegg_map_soft}]
  --splitk         <int>   split the input into X file for kegg                                  [${params.splitk}]
  --kcpu           <int>   run kegg annot cpu for each blastp (diamond)/kofamscan                [${params.kcpu}]
  --maxF_k         <int>   max num blastp/kofamscan can be executed in local parallel for kegg   [${params.maxF_k}]
  --Kegg_mem       <int>   Kegg use mem                                                          [${params.Kegg_mem}]
##Nr annot
  --nr             <bool>  if run nr annot ,add --nr behind command line                         [${params.nr}]
  --splitn         <int>   split the input into X file for nr                                    [${params.splitn}]
  --ncpu           <int>   run nr annot cpu for each blastp (diamond)                            [${params.ncpu}]
  --maxF_n         <int>   max num blastp can be executed in local parallel for nr               [${params.maxF_n}]
  --Nr_mem         <int>   Nr use mem                                                            [${params.Nr_mem}]
##Uniprot annot
  --uniprot        <bool>  if run uniprot annot ,add --uniprot behind command line               [${params.uniprot}]
  --splitu         <int>   split the input into X file for uniprot                               [${params.splitu}]
  --ucpu           <int>   run uniprot annot cpu for each blastp (diamond)                       [${params.ucpu}]
  --maxF_u         <int>   max num blastp can be executed in local parallel for uniprot          [${params.maxF_u}]
  --Uniprot_mem    <int>   Uniprot use mem                                                       [${params.Uniprot_mem}]
##Go annot
  --go             <bool>  if run go annot ,add --go behind command line                         [${params.go}]
##Eggnog annot
  --eggnog         <str>   if run eggnog for cog and kog                                         [${params.eggnog}]
  --egg_cpu        <int>   run cog/kog annot cpu for eggnog                                      [${params.egg_cpu}]
##Cog annot
  --cog            <bool>  if run cog annot ,add --cog behind command line                       [${params.cog}]
##Kog annot
  --kog            <bool>  if run kog annot ,add --kog behind command line                       [${params.kog}]
##Pfam annot
  --pfam           <bool>  if run pfam annot ,add --pfam behind command line                     [${params.pfam}]
  --splitp         <int>   split the input into X file                                           [${params.splitp}]
  --pcpu           <int>   run pfam annot cpu for each hmmscan                                   [${params.pcpu}]
  --maxF_p         <int>   max num hmmscan can be executed in local parallel for pfam            [${params.maxF_p}]
  --Pfam_mem       <int>   Pfam use mem                                                          [${params.Pfam_mem}]
##Interpro annot
  --interpro       <bool>  if run interpro annot ,add --interpro behind command line             [${params.interpro}]
  --spliti         <int>   split the input into X file                                           [${params.spliti}]
  --cutForS        <int>   use cutf or cuts                                                      [${params.cutForS}]
  --icpu           <int>   cpu for each interproscan                                             [${params.icpu}]
  --maxF_i         <int>   max num interproscan can be executed in local parallel                [${params.maxF_i}]
  --Interpro_mem   <int>   Interpro use mem                                                      [${params.Interpro_mem}]
##Refseq annot
  --refseq         <bool>  if run refseq annot ,add --refseq behind command line                 [${params.refseq}]
  --splitr         <int>   split the input into X file                                           [${params.splitr}]
  --rcpu           <int>   cpu for each refseq                                                   [${params.rcpu}]
  --maxF_r         <int>   max num refseq can be executed in local parallel                      [${params.maxF_r}]
  --Refseq_mem     <int>   Refseq use mem                                                        [${params.Refseq_mem}]
##Tf annot
  --tf             <bool>  if run tf annot ,add --tf behind command line(only for Plants/Animals)[${params.tf}]
==========Only for Meta Or No Ref's Pep==========
##高级蛋白分析
##原核蛋白质数据库
  --tigerfam       <bool>  if run tigerfam annot ,add --tigerfam behind command line             [${params.tigerfam}]
  --splitt         <int>   split the input into X file                                           [${params.splitt}]
  --tcpu           <int>   cpu for each tigerfam                                                 [${params.tcpu}]
  --maxF_t         <int>   max num tigerfam can be executed in local parallel                    [${params.maxF_t}]
##对膜转运蛋白
  --tcdb           <bool>  if run tcdb annot ,add --tcdb behind command line                     [${params.tcdb}]
##关于能够合成或者分解复杂碳水化合物和糖复合物的酶类的数据库
  --cazy           <bool>  if run cazy annot ,add --cazy behind command line                     [${params.cazy}]
##细胞色素酶P450数据库
  --cyped          <bool>  if run cyped annot ,add --cyped behind command line                   [${params.cyped}]
##分泌蛋白注释
  --signalp        <bool>  if run signalp annot ,add --signalp behind command line               [${params.signalp}]
  --signalp_type   <str>   signalp org choose from {euk,gram-,gram+,arch}                        [${params.signalp_type}]
  --pict_Signal    <str>   if get picture for Signalp, choose y or n                             [${params.pict_Signal}]
  --maxF_Sig       <int>   max num signalp can be executed in local parallel                     [${params.maxF_Sig}]
##跨膜蛋白注释
  --tmhmm          <bool>  if run tmhmm annot ,add --tmhmm behind command line                   [${params.tmhmm}]
  --pict_Tmhmm     <str>   if get picture for Tmhmm, choose y or n                               [${params.pict_Tmhmm}]
  --maxF_Tm        <int>   max num Tmhmm can be executed in local parallel                       [${params.maxF_Tm}]
##亚细胞定位注释
  --deeploc        <bool>  if run deeploc annot ,add --deeploc behind command line               [${params.deeploc}]
  --maxF_d         <int>   max num deeploc can be executed in local parallel                     [${params.maxF_d}]
##耐药性
##抗性基因数据库
  --card           <bool>  if run card annot ,add --card behind command line                     [${params.card}]
##微生物抗性基因数据库
  --ardb           <bool>  if run ardb annot ,add --ardb behind command line                     [${params.ardb}]
##病原菌毒力因子(病毒)数据库
  --vfdb           <bool>  if run vfdb annot ,add --vfdb behind command line                     [${params.vfdb}]
##致病基因和效应基因数据库
  --phi            <bool>  if run phi annot ,add --phi behind command line                       [${params.phi}]
##结构注释
##结构注释需要输入gbk文件
  --gbk            <str>   input gbk file                                                        
##细菌和古菌基因岛注释
  --island         <bool>  if run island annot ,add --island behind command line                 [${params.island}]
  --island_len     <int>   min seq length                                                        [${params.island_len}]
##原噬菌体注释
  --phispy         <bool>  if run phispy annot ,add --phispy behind command line                 [${params.phispy}]
  --phispy_len     <int>   min seq length                                                        [${params.phispy_len}]
  ##次级代谢
  --antismash      <bool>  if run antismash annot ,add --antismash behind command line           [${params.antismash}]
  --antimode       <str>   antismash use file gbk or fasta or fasta_gff                          [${params.antimode}]
##结构注释需要输入基因组文件
  --genome         <str>   input genome file
  --gff            <str>   input gff file                                                     
##CRISPRs注释
  --minced         <bool>  if run minced annot ,add --minced behind command line                 [${params.minced}]
\033[0m
"""
exit 0
}else{
log.info """\033[NEXTFLOW SCRIPT]
\033[42;33m                 _____ _   _ _   _  ____ _____ ___ ___  _   _                 \033[1m\033[0m
\033[42;33m                |  ___| | | | \\ | |/ ___|_   _|_ _/ _ \\| \\ | |                \033[1m\033[0m
\033[42;33m                | |_  | | | |  \\| | |     | |  | | | | |  \\| |                \033[1m\033[0m
\033[42;33m                |  _| | |_| | |\\  | |___  | |  | | |_| | |\\  |                \033[1m\033[0m
\033[42;33m                |_|    \\___/|_| \\_|\\____| |_| |___\\___/|_| \\_|                \033[1m\033[0m
\033[42;33m                                                                              \033[1m\033[0m
\033[43;32m              A Nextflow Pipline For function annotation Analysis             \033[1m\033[0m
\033[43;32m                    . Author  : Pengyu Fan                                    \033[1m\033[0m
\033[43;32m                    . Email   : fanpengyu@alumni.hust.edu.cn                  \033[1m\033[0m
\033[43;32m                    . Version : v1.1                                          \033[1m\033[0m
\033[43;32m                    . Update  : 2023.7.26                                     \033[1m\033[0m
""" 
}

script_path = new File(workflow.projectDir.toString(),"bin")

// check the params

////// Print parameters ///////
log.info ''
log.info 'Nextflow Pipline For function annotation Analysis'
log.info '============================================================================='

//pep check
if (params.kegg != false || params.nr != false || params.uniprot != false || params.go != false || params.cog != false || params.kog != false || params.pfam != false || params.interpro != false || params.refseq != false || params.tf != false || params.tigerfam != false || params.tcdb != false || params.cazy != false || params.cyped != false || params.signalp != false || params.tmhmm != false || params.deeploc != false || params.card != false || params.ardb != false || params.vfdb != false || params.phi != false){
log.info "input pep fasta:                      ${params.pep}"
log.info ''

Channel
    .fromPath(params.pep)
    .ifEmpty {ERROR: "Do not find the input file: ${params.pep}"}
    .set{ fastaFile }
fastaFile.collect().set{target_fastaFile}
}

//gbk check
if (params.island != false || params.phispy != false){
log.info "input gbk file:                       ${params.gbk}"
log.info ''

Channel
    .fromPath(params.gbk)
    .ifEmpty {ERROR: "Do not find the input file: ${params.gbk}"}
    .set{ gbkFile }
gbkFile.collect().set{target_gbkFile}
}

//genome check
if (params.minced != false){
log.info "input genome file:                    ${params.genome}"
log.info ''

Channel
    .fromPath(params.genome)
    .ifEmpty {ERROR: "Do not find the input file: ${params.genome}"}
    .set{ genomeFile }
genomeFile.collect().set{target_genomeFile}
}

//##############KEGG Anno##############
if (params.kingdom == 'All'){
    if (params.kegg_map_soft == "blastp"){
    DataChooKegg = params.All_kegg
    } else {
    DataChooKegg = params.All_khmm
    }
    DataChooKo   = params.All_ko
    DataChooNr   = params.All_nr
    DataChooRef  = params.All_refseq
    DataChooUni  = params.All_uniprot
} else if (params.kingdom == 'Archaea'){
    if (params.kegg_map_soft == "blastp"){
    DataChooKegg = params.Archaea_kegg
    } else {
    DataChooKegg = params.Archaea_khmm
    }
    DataChooKo   = params.Archaea_ko
    DataChooNr   = params.Archaea_nr
    DataChooRef  = params.Archaea_refseq
    DataChooUni  = params.uniprot_archaea
} else if (params.kingdom == 'Bacteria'){
    if (params.kegg_map_soft == "blastp"){
    DataChooKegg = params.Bacteria_kegg
    } else {
    DataChooKegg = params.Bacteria_khmm
    }
    DataChooKo   = params.Bacteria_ko
    DataChooNr   = params.Bacteria_nr
    DataChooRef  = params.Bacteria_refseq
    DataChooUni  = params.uniprot_bacteria
} else if (params.kingdom == 'Fungi'){
    if (params.kegg_map_soft == "blastp"){
    DataChooKegg = params.Fungi_kegg
    } else {
    DataChooKegg = params.Fungi_khmm
    }
    DataChooKo   = params.Fungi_ko
    DataChooNr   = params.Fungi_nr
    DataChooRef  = params.Fungi_refseq
    DataChooUni  = params.uniprot_fungi
} else if (params.kingdom == 'Plants'){
    if (params.kegg_map_soft == "blastp"){
    DataChooKegg = params.Plants_kegg
    } else {
    DataChooKegg = params.Plants_khmm
    }
    DataChooKo   = params.Plants_ko
    DataChooNr   = params.Plant_nr
    DataChooRef  = params.Plant_refseq
    DataChooUni  = params.uniprot_plants
} else if (params.kingdom == 'Animals'){
    DataChooNr   = params.Animal_nr
    DataChooRef  = params.Animal_refseq
    DataChooUni  = params.uniprot_animal
    if (params.Phylum == 'Animals'){
    if (params.kegg_map_soft == "blastp"){
    DataChooKegg = params.Animals_kegg
    } else {
    DataChooKegg = params.Animals_khmm
    }
    DataChooKo   = params.Animals_ko
    }else{
    if (params.kegg_map_soft == "blastp"){
    DataChooKegg = "${params.Phylum}.pep.fasta.dmnd"
    } else {
    DataChooKegg = "${params.Phylum}.hmm"
    }
    DataChooKo   = "${params.Phylum}_KoPathways.txt"
    }
} else if (params.kingdom == 'Virus'){
    if (params.kegg_map_soft == "blastp"){
    DataChooKegg = params.All_kegg
    } else {
    DataChooKegg = params.All_khmm
    }
    DataChooKo   = params.All_ko
    DataChooNr   = params.Virus_nr
    DataChooRef  = params.Virus_refseq
    DataChooUni  = params.uniprot_viruses
} else if (params.kingdom == 'Human'){
    if (params.kegg_map_soft == "blastp"){
    DataChooKegg = params.human_kegg
    } else {
    DataChooKegg = params.human_khmm
    }
    DataChooKo   = params.human_ko
    DataChooNr   = params.Animal_nr
    DataChooRef  = params.Animal_refseq
    DataChooUni  = params.uniprot_human
} else if (params.kingdom == 'B_A_V'){
    if (params.kegg_map_soft == "blastp"){
    DataChooKegg = params.B_A_kegg
    } else {
    DataChooKegg = params.B_A_khmm
    }
    DataChooKo   = params.B_A_ko
    DataChooNr   = params.B_A_V_nr
    DataChooRef  = params.B_A_V_refseq
    DataChooUni  = params.uniprot_B_A_V
} else if (params.kingdom == 'B_A_F_V'){
    if (params.kegg_map_soft == "blastp"){
    DataChooKegg = params.B_A_F_kegg
    } else {
    DataChooKegg = params.B_A_F_khmm
    }
    DataChooKo   = params.B_A_F_ko
    DataChooNr   = params.B_A_V_F_nr
    DataChooRef  = params.B_A_V_F_refseq
    DataChooUni  = params.uniprot_B_A_V_F
} else {
    log.info "Please input right kingdom params, choose from [All,Archaea,Bacteria,Fungi,Plants,Animals,Virus,Human,B_A_V,B_A_F_V]"
}

if (params.kegg_org != "None"){
    DataChooKo = "sp_KoPathways/${params.kegg_org}_KoPathways.txt"
}

//##############KEGG Anno##############
if (params.kegg != false){
int ooptsplitk="${params.splitk}".toInteger()

process SplitKegg{
    tag "SplitKegg"
    input:
        file fasta from target_fastaFile
        val optsplitk from ooptsplitk

    output:
        file "${fasta}.cut/${fasta}.*" into subFastaFile_kegg
    script:
        """
        echo \$HOST_Q
        perl ${script_path}/fastaDeal.pl --cutf ${optsplitk} ${fasta}
        """
}

if (params.kegg_map_soft == "hmmscan"){
process KofamScan{
    tag "${fasta}"
    input:
        file fasta from subFastaFile_kegg.flatten()
    
    output:
        file "${fasta}.out" into blastFile
    script:
        if (params.kegg_org == "None"){
        """
        echo \$HOST_Q
        python3 ${script_path}/kegg/sort_same_seq.py ${fasta} use.pep
        hmmscan --cpu ${params.kcpu} -E ${params.kevalue} --tblout ${fasta}.tblout --domtblout ${fasta}.domtblout ${params.kegg_db}/${DataChooKegg} use.pep
        python3 ${script_path}/kegg/split_kegg_hmm.py ${fasta}.domtblout ${fasta}.out
        """
        } else {
        """
        echo \$HOST_Q
        python3 ${script_path}/kegg/sort_same_seq.py ${fasta} use.pep
        ln -s ${params.kegg_db}/sp_K_hmm/${params.kegg_org}.hmm kegg.hmm
        hmmpress kegg.hmm
        hmmscan --cpu ${params.kcpu} -E ${params.kevalue} --tblout ${fasta}.tblout --domtblout ${fasta}.domtblout kegg.hmm use.pep
        python3 ${script_path}/kegg/split_kegg_hmm.py ${fasta}.domtblout ${fasta}.out
        """
        }
}
}

if (params.kegg_map_soft == "hmmsearch"){
process KofamSearch{
    tag "${fasta}"
    input:
        file fasta from subFastaFile_kegg.flatten()
  
    output:
        file "${fasta}.out" into blastFile
    script:
        """
        echo \$HOST_Q
        python3 ${script_path}/kegg/sort_same_seq.py ${fasta} use.pep
        /kofam_scan-1.3.0/kofam_scan -o ${fasta}.out -p ${params.kegg_db}/profiles -k ${params.kegg_db}/ko_list --cpu ${params.kcpu} -E ${params.kevalue} -f mapper use.pep
        """
}
}

if (params.kegg_map_soft == "hmmsearch" || params.kegg_map_soft == "hmmscan"){
process MergeKeggKofam{
    tag "MergeKeggKofam"
    publishDir "${params.regular_out}/kegg", mode: 'copy', overwrite:true
    input:
        file subblast from blastFile.collect()

    output:
        file "kegg_kofam.xls" into kobas_result_pathway_result
    script:
        """
        echo \$HOST_Q
        for m6File in ${subblast}
        do
            cat \$m6File >> kegg_kofam.xls
        done
        """
}
}

if (params.kegg_map_soft == "blastp"){
process BlastKegg{
    tag "${fasta}"
    input:
        file fasta from subFastaFile_kegg.flatten()
    
    output:
        file "*.blastp.out.m6" into blastFile,blastFile_kobas
    script:
        if (params.kegg_org == "None"){
        """
        echo \$HOST_Q
        ${params.diamond} ${params.map_soft} --evalue ${params.kevalue} --max-target-seqs 5 --db ${params.kegg_db}/${DataChooKegg} --query ${fasta} --threads ${params.kcpu} --outfmt 6 'qseqid' 'sseqid' 'pident' 'qcovhsp' 'length' 'mismatch' 'gapopen' 'qstart' 'qend' 'sstart' 'send' 'evalue' 'bitscore' 'stitle' --out ${fasta}.blastp.out.m6
        """
        } else {
        """
        echo \$HOST_Q
        ln -s ${params.kegg_db}/kobas-3.0/seq_pep/${params.kegg_org}.pep.fasta kegg.pep.fasta
        diamond makedb --in kegg.pep.fasta --threads 20 --db kegg.pep.fasta.dmnd
        ${params.diamond} ${params.map_soft} --evalue ${params.kevalue} --max-target-seqs 5 --db kegg.pep.fasta.dmnd --query ${fasta} --threads ${params.kcpu} --outfmt 6 'qseqid' 'sseqid' 'pident' 'qcovhsp' 'length' 'mismatch' 'gapopen' 'qstart' 'qend' 'sstart' 'send' 'evalue' 'bitscore' 'stitle' --out ${fasta}.blastp.out.m6
        """
        }
}

process MergeKeggKobas{
    tag "MergeKegg"
    publishDir "${params.regular_out}/kegg", mode: 'copy', overwrite:true
    input:
        file subblast from blastFile.collect()

    output:
        file "kegg_blast.xls"
    script:
        """
        echo \$HOST_Q
        echo -e '#qseqid\\tsseqid\\tpident\\tqcovhsp\\tlength\\tmismatch\\tgapopen\\tqstart\\tqend\\tsstart\\tsend\\tevalue\\tbitscore\\tstitle' > kegg_blast.xls
        for m6File in ${subblast}
        do
            cat \$m6File >> kegg_blast.xls
        done
        """
}

process KobasResult{
    tag "${blastout}"
    input:
        file blastout from blastFile_kobas
 
    output:
        file "${blastout}_tmp.kobas.xls" into split_kobas
    script:
    def fileObj = blastout.toFile()
    def fileSize = fileObj.length()
    if (fileSize > 0){
        """
        echo \$HOST_Q
        #!/usr/bin/bash
        set PYTHONPATH
        #sed '1,1d' ${blastout} | awk 'BEGIN { OFS="\\t"} {print \$1 , \$2 , \$3 , \$5 , \$6 , \$7 , \$8 , \$9 , \$10 , \$11 , \$12 , \$13}' > ${blastout}.tmp
        less ${blastout} | awk 'BEGIN { OFS="\\t"} {print \$1 , \$2 , \$3 , \$5 , \$6 , \$7 , \$8 , \$9 , \$10 , \$11 , \$12 , \$13}' > ${blastout}.tmp
        export PYTHONPATH=${params.kegg_db}/kobas-3.0/src && python ${params.kegg_db}/kobas-3.0/scripts/annotate.py -i ${blastout}.tmp -t blastout:tab -s ko -o ${blastout}.kobas.xls -e ${params.kevalue} -r 5
        python3 ${script_path}/kegg/format_kobas.py ${blastout}.kobas.xls ${blastout}_tmp.kobas.xls
        """
    } else {
        """
        echo \$HOST_Q
        touch ${blastout}_tmp.kobas.xls
        """
    }
}

process KobasResultMerge{
    tag "KobasResultMerge"
    input:
        file kobas_file from split_kobas.collect()
 
    output:
        file "kegg.kobas.xls" into kobas_result_pathway_result
    script:
        """
        echo \$HOST_Q
        for m6File in ${kobas_file}
        do
            cat \$m6File >> kegg.kobas.xls
        done
        """
}
}

//process KobasResult{
//    tag "KobasResult"
//    input:
//        file blastout from blastOut
//    output:
//        file "kegg.kobas.xls" into kobas_result_pathway_result
//    script:
//        """
//        echo \$HOST_Q
//        #!/usr/bin/bash
//        set PYTHONPATH
//        sed '1,1d' ${blastout} | awk 'BEGIN { OFS="\\t"} {print \$1 , \$2 , \$3 , \$5 , \$6 , \$7 , \$8 , \$9 , \$10 , \$11 , \$12 , \$13}' > ${blastout}.tmp
//        export PYTHONPATH=${params.kegg_db}/kobas-3.0/src && python ${params.kegg_db}/kobas-3.0/scripts/annotate.py -i ${blastout}.tmp -t blastout:tab -s ko -o kegg.kobas.xls -e 1e-5 -r 5
//        """
//}

process PathwayResult{
    tag "PathwayResult"
    publishDir "${params.regular_out}/kegg", mode: 'copy', overwrite:true
    input:
        file infile from kobas_result_pathway_result
 
    output:
        file "*kegg.xls" into kegg_pathway_result_summary,kegg_pathway_result_summary_upset
        file "*pathway.xls" into KoClassResult_DrawKo,pathway_pathway_result_summary,pathway_pathway_result_summary_upset
        file "*id2K_ko.xls"
        file "*kegg_summary.xls" into nextKegg
    script:
        if (params.sample_name == 'None'){
            if (params.kegg_map_soft == "blastp"){
                """
                echo \$HOST_Q
                python3 ${script_path}/kegg/kobas2keggko.py ${infile} ${params.kegg_db}/${DataChooKo} ${params.kegg_db}/PathwayHtext.txt ${params.kegg_db}/K_info.txt kegg.xls pathway.xls
                python3 ${script_path}/kegg/kegg_summary.py kegg.xls ${params.kegg_db}/${DataChooKo} ${params.kegg_db}/PathwayHtext.txt id2K_ko.xls kegg_summary.xls
                #perl ${script_path}/kegg/mk_id2K2ko.pl kegg.xls ${params.kegg_db}/${DataChooKo} > id2K_ko.xls
                #python3 ${script_path}/kegg/Ko-pathway_summary.py kegg.xls pathway.xls id2K_ko.xls kegg_summary.xls
                """
            }else{
                """
                echo \$HOST_Q
                python3 ${script_path}/kegg/kofam2keggko.py ${infile} ${params.kegg_db}/${DataChooKo} ${params.kegg_db}/PathwayHtext.txt ${params.kegg_db}/K_info.txt kegg.xls pathway.xls
                python3 ${script_path}/kegg/kegg_summary.py kegg.xls ${params.kegg_db}/${DataChooKo} ${params.kegg_db}/PathwayHtext.txt id2K_ko.xls kegg_summary.xls
                #perl ${script_path}/kegg/mk_id2K2ko.pl kegg.xls ${params.kegg_db}/${DataChooKo} > id2K_ko.xls
                #python3 ${script_path}/kegg/Ko-pathway_summary.py kegg.xls pathway.xls id2K_ko.xls kegg_summary.xls
                """
            }
        } else {
            if (params.kegg_map_soft == "blastp"){
            """
            echo \$HOST_Q
              python3 ${script_path}/kegg/kobas2keggko.py ${infile} ${params.kegg_db}/${DataChooKo} ${params.kegg_db}/PathwayHtext.txt ${params.kegg_db}/K_info.txt ${params.sample_name}.kegg.xls ${params.sample_name}.pathway.xls
              python3 ${script_path}/kegg/kegg_summary.py ${params.sample_name}.kegg.xls ${params.kegg_db}/${DataChooKo} ${params.kegg_db}/PathwayHtext.txt ${params.sample_name}.id2K_ko.xls ${params.sample_name}.kegg_summary.xls
              #perl ${script_path}/kegg/mk_id2K2ko.pl ${params.sample_name}.kegg.xls ${params.kegg_db}/${DataChooKo} > ${params.sample_name}.id2K_ko.xls
              #python3 ${script_path}/kegg/Ko-pathway_summary.py ${params.sample_name}.kegg.xls ${params.sample_name}.pathway.xls ${params.sample_name}.id2K_ko.xls ${params.sample_name}.kegg_summary.xls
              """
            }else{
              """
              echo \$HOST_Q
              python3 ${script_path}/kegg/kofam2keggko.py ${infile} ${params.kegg_db}/${DataChooKo} ${params.kegg_db}/PathwayHtext.txt ${params.kegg_db}/K_info.txt ${params.sample_name}.kegg.xls ${params.sample_name}.pathway.xls
              python3 ${script_path}/kegg/kegg_summary.py ${params.sample_name}.kegg.xls ${params.kegg_db}/${DataChooKo} ${params.kegg_db}/PathwayHtext.txt ${params.sample_name}.id2K_ko.xls ${params.sample_name}.kegg_summary.xls
              #perl ${script_path}/kegg/mk_id2K2ko.pl ${params.sample_name}.kegg.xls ${params.kegg_db}/${DataChooKo} > ${params.sample_name}.id2K_ko.xls
              #python3 ${script_path}/kegg/Ko-pathway_summary.py ${params.sample_name}.kegg.xls ${params.sample_name}.pathway.xls ${params.sample_name}.id2K_ko.xls ${params.sample_name}.kegg_summary.xls
              """
            }
        }
}

process DrawKo{
    tag "DrawKo"
    publishDir "${params.regular_out}/kegg", mode: 'copy', overwrite:true
    input:
        file txt from KoClassResult_DrawKo
        file claas from nextKegg

    output:
        file "pathway.pdf"
        file "pathway.png"
        file "pathway.svg"
        file "pathway_class_num.xls"
        file "pathway_class_genelist.xls"
    script:
        """
        echo \$HOST_Q
        Rscript ${script_path}/kegg/ko.R ${txt} ${params.kingdom}
        python3 ${script_path}/kegg/pathway_genelist.py ${claas} pathway_class_num.xls pathway_class_genelist.xls
        """
}
} else {
process PathwayResultNo{
    tag "PathwayResultNo"
 
    output:
        file "*kegg.xls" into kegg_pathway_result_summary,kegg_pathway_result_summary_upset
        file "*pathway.xls" into pathway_pathway_result_summary,pathway_pathway_result_summary_upset
    script:
        """
        echo \$HOST_Q
        touch kegg.xls
        touch pathway.xls
        """
}
}

//##############NR Anno##############
if (params.nr != false){
int ooptsplitn="${params.splitn}".toInteger()

process SplitNr{
    tag "SplitNr"
    input:
        file fasta from target_fastaFile
        val optsplitn from ooptsplitn

    output:
        file "${fasta}.cut/${fasta}.*" into subFastaFile_nr
    script:
        """
        echo \$HOST_Q
        perl ${script_path}/fastaDeal.pl --cutf ${optsplitn} ${fasta}
        """
}

process BlastNr{
    tag "${fasta}"
    input:
        file fasta from subFastaFile_nr.flatten()
    
    output:
        file "*.blastp.out.m6" into nrFile
    script:
        """
        echo \$HOST_Q
        ${params.diamond} ${params.map_soft} --evalue 1e-05 --max-target-seqs 1 --db ${params.nr_db}/${DataChooNr} --query ${fasta} --threads ${params.ncpu} --outfmt 6 'qseqid' 'sseqid' 'pident' 'qcovhsp' 'length' 'mismatch' 'gapopen' 'qstart' 'qend' 'sstart' 'send' 'evalue' 'bitscore' 'stitle' --out ${fasta}.blastp.out.m6
        """
}

process MergeNr{
    tag "MergeNr"
    publishDir "${params.regular_out}/nr", mode: 'copy', overwrite:true
    input:
        file subnr from nrFile.collect()

    output:
        file "nr_blast.xls" into nrOut
    script:
        """
        echo \$HOST_Q
        echo -e '#qseqid\\tsseqid\\tpident\\tqcovhsp\\tlength\\tmismatch\\tgapopen\\tqstart\\tqend\\tsstart\\tsend\\tevalue\\tbitscore\\tstitle' > nr_blast.xls
        for m6File in ${subnr}
        do
            cat \$m6File >> nr_blast.xls
        done
        """
}

process NrResult{
    tag "NrResult"
    publishDir "${params.regular_out}/nr", mode: 'copy', overwrite:true
    input:
        file nr from nrOut

    output:
        file "*nr.xls" into nr_result_draw_nr,nr_result_summary,nr_result_summary_upset
    script:
        if (params.sample_name == 'None'){
            """
            echo \$HOST_Q
            python ${script_path}/nr/nr_result.py -n ${nr} -o nr.xls
            """
        } else {
            """
            echo \$HOST_Q
            python ${script_path}/nr/nr_result.py -n ${nr} -o ${params.sample_name}.nr.xls
            """
        }
}

process DrawNr{
    tag "DrawNr"
    publishDir "${params.regular_out}/nr", mode: 'copy', overwrite:true
    input:
        file nr_sp from nr_result_draw_nr

    output:
        file "Nr_Species_distribution.pdf"
        file "Nr_Species_distribution.png"
        file "Nr_Species_distribution.svg"
        file "Nr_Species_distribution.xls"
        file "Nr_Species_distribution.html"
    script:
        """
        echo \$HOST_Q
        python ${script_path}/nr/species_num.py ${nr_sp}
        head -n 11 Nr_Species_distribution.xls > head_10_Nr_Species_distribution.txt
        Rscript ${script_path}/nr/nr.R head_10_Nr_Species_distribution.txt
        export LANG=en_US.UTF-8 && python3 ${script_path}/pie.py -i head_10_Nr_Species_distribution.txt -o Nr_Species_distribution -l Species -n Number
        #python3 ${script_path}/pie.py -i head_10_Nr_Species_distribution.txt -o Nr_Species_distribution
        """
}
} else {
process NrResultNo{
    tag "NrResultNo"

    output:
        file "*nr.xls" into nr_result_summary,nr_result_summary_upset
    script:
        """
        echo \$HOST_Q
        touch nr.xls
        """
}
}

//##############Uniprot Anno##############
if (params.uniprot != false || params.go != false || params.cog != false || params.kog != false){
int ooptsplitu="${params.splitu}".toInteger()

process SplitUniprot{
    tag "SplitUniprot"
    input:
        file fasta from target_fastaFile
        val optsplitu from ooptsplitu

    output:
        file "${fasta}.cut/${fasta}.*" into subFastaFile_uniprot
    script:
        """
        echo \$HOST_Q
        perl ${script_path}/fastaDeal.pl --cutf ${optsplitu} ${fasta}
        """
}

process BlastUniprot{
    tag "${fasta}"
    input:
        file fasta from subFastaFile_uniprot.flatten()
    
    output:
        file "*.blastp.out.m6" into uniprotFile
    script:
        """
        echo \$HOST_Q
        ${params.diamond} ${params.map_soft} --evalue 1e-05 --max-target-seqs 1 --db ${params.uniprot_db}/${DataChooUni} --query ${fasta} --threads ${params.ucpu} --outfmt 6 'qseqid' 'sseqid' 'pident' 'qcovhsp' 'length' 'mismatch' 'gapopen' 'qstart' 'qend' 'sstart' 'send' 'evalue' 'bitscore' 'stitle' --out ${fasta}.blastp.out.m6
        """
}

process MergeUniprot{
    tag "MergeUniprot"
    publishDir "${params.regular_out}/uniprot", mode: 'copy', overwrite:true
    input:
        file uniprot from uniprotFile.collect()

    output:
        file "uniprot_blast.xls" into uniprotOut,uniprotgo,uniprotcog,uniprotkog
    script:
        """
        echo \$HOST_Q
        echo -e '#qseqid\\tsseqid\\tpident\\tqcovhsp\\tlength\\tmismatch\\tgapopen\\tqstart\\tqend\\tsstart\\tsend\\tevalue\\tbitscore\\tstitle' > uniprot_blast.xls
        for m6File in ${uniprot}
        do
            cat \$m6File >> uniprot_blast.xls
        done
        """
}

process UniprotResult{
    tag "UniprotResult"
    publishDir "${params.regular_out}/uniprot", mode: 'copy', overwrite:true
    input:
        file uniprot from uniprotOut

    output:
        file "*uniprot.xls" into uniprot_result_summary,uniprot_result_summary_upset
    script:
        if (params.sample_name == 'None'){
            """
            echo \$HOST_Q
            python ${script_path}/uniprot/get_uniprot.py ${uniprot} uniprot.xls
            """
        } else {
            """
            echo \$HOST_Q
            python ${script_path}/uniprot/get_uniprot.py ${uniprot} ${params.sample_name}.uniprot.xls
            """
        }
}
} else {
process UniprotResultNo{
    tag "UniprotResultNo"

    output:
        file "*uniprot.xls" into uniprot_result_summary,uniprot_result_summary_upset
    script:
        """
        echo \$HOST_Q
        touch uniprot.xls
        """
}
}

//##############GO Anno##############
if (params.go != false){
process GoResult{
    tag "GoResult"
    publishDir "${params.regular_out}/go", mode: 'copy', overwrite:true
    input:
        file ugo from uniprotgo

    output:
        file "*go.xls" into GoClassResult_DrawGO,go_result_summary,go_result_summary_upset
        file "*weGO.xls"
        file "*go_stat.xls"
    script:
        if (params.sample_name == 'None'){
            """
            echo \$HOST_Q
            python ${script_path}/uniprot/get_go.py ${params.uniprot_db}/go.txt ${ugo} go.xls weGO.xls go_stat.xls
            """
        } else {
            """
            echo \$HOST_Q
            python ${script_path}/uniprot/get_go.py ${params.uniprot_db}/go.txt ${ugo} ${params.sample_name}.go.xls ${params.sample_name}.weGO.xls ${params.sample_name}.go_stat.xls
            """
        }
}

process DrawGO{
    tag "DrawGO"
    publishDir "${params.regular_out}/go", mode: 'copy', overwrite:true
    input:
        file txt from GoClassResult_DrawGO

    output:
        file "go.pdf"
        file "go.png"
        file "go.svg"
    script:
        """
        echo \$HOST_Q
        Rscript ${script_path}/uniprot/go.R ${txt}
        """
}
} else {
process GoResultNo{
    tag "GoResultNo"

    output:
        file "*go.xls" into go_result_summary,go_result_summary_upset
    script:
        """
        echo \$HOST_Q
        touch go.xls
        """
}
}

//##############EggNog Anno##############
if ((params.kog != false || params.cog != false) && params.eggnog != false){
process EggNogRun{
    tag "EggNogRun"
    input:
        file fasta from target_fastaFile

    output:
        file "*emapper.annotations" into CogResult_Fuck,KogResult_Fuck
    script:
        """
        echo \$HOST_Q
        emapper.py -i ${fasta} --cpu ${params.egg_cpu} --output tmp --data_dir ${params.egg_db}
        """
}
}

//##############COG Anno##############
if (params.cog != false && (params.kingdom == 'All' || params.kingdom == 'Archaea' || params.kingdom == 'Bacteria' || params.kingdom == 'Virus' || params.kingdom == 'B_A_V' || params.kingdom == 'B_A_F_V')){
if (params.eggnog == false){
process CogResult{
    tag "CogResult"
    publishDir "${params.regular_out}/cog", mode: 'copy', overwrite:true
    input:
        file ucog from uniprotcog

    output:
        file "*.xls" into CogResult_DrawCog,cog_result_summary,cog_result_summary_upset
    script:
        if (params.sample_name == 'None'){
            """
            echo \$HOST_Q
            python3 ${script_path}/uniprot/blast_uniprot2cog.py -f ${ucog} -r ${params.uniprot_db}/uniprot2cog.txt -n ${params.uniprot_db}/CogClass.txt -c ${params.uniprot_db}/cog.txt -o cog.xls
            """
        } else {
            """
            echo \$HOST_Q
            python3 ${script_path}/uniprot/blast_uniprot2cog.py -f ${ucog} -r ${params.uniprot_db}/uniprot2cog.txt -n ${params.uniprot_db}/CogClass.txt -c ${params.uniprot_db}/cog.txt -o ${params.sample_name}.cog.xls
            """
        }
}
} else {
process CogResultE{
    tag "CogResult"
    publishDir "${params.regular_out}/cog", mode: 'copy', overwrite:true
    input:
        file txt from CogResult_Fuck

    output:
        file "*.xls" into CogResult_DrawCog,cog_result_summary,cog_result_summary_upset
    script:
        if (params.sample_name == 'None'){
            """
            echo \$HOST_Q
            python3 ${script_path}/uniprot/cogData.py ${txt} ${params.uniprot_db}/cog.txt ${params.uniprot_db}/CogClass.txt cog.xls
            """
        } else {
            """
            echo \$HOST_Q
            python3 ${script_path}/uniprot/cogData.py ${txt} ${params.uniprot_db}/cog.txt ${params.uniprot_db}/CogClass.txt ${params.sample_name}.cog.xls
            """
        }
}
}

process DrawCog{
    tag "DrawCog"
    publishDir "${params.regular_out}/cog", mode: 'copy', overwrite:true
    input:
        file txt from CogResult_DrawCog

    output:
        file "*g.png"
        file "*g.pdf"
        file "*g.svg"
    script:
        """
        echo \$HOST_Q
        python3 ${script_path}/uniprot/kong_remove.py ${txt} 'Rscript ${script_path}/uniprot/cog.R ${txt} cog' ${script_path}/uniprot
        #Rscript ${script_path}/uniprot/cog.R ${txt} cog
        """
}
} else {
process CogResultNo{
    tag "CogResultNo"

    output:
        file "*cog.xls" into cog_result_summary,cog_result_summary_upset
    script:
        """
        echo \$HOST_Q
        touch cog.xls
        """
}
}

//##############KOG Anno##############
if (params.kog != false && (params.kingdom == 'All' || params.kingdom == 'Plants' || params.kingdom == 'Fungi' || params.kingdom == 'Animals' || params.kingdom == 'Human' || params.kingdom == 'B_A_F_V')){
if (params.eggnog == false){
process KogResult{
    tag "KogResult"
    publishDir "${params.regular_out}/kog", mode: 'copy', overwrite:true
    input:
        file ukog from uniprotkog

    output:
        file "*.xls" into KogResult_DrawKog,kog_result_summary,kog_result_summary_upset
    script:
        if (params.sample_name == 'None'){
            """
            echo \$HOST_Q
            python3 ${script_path}/uniprot/blast_uniprot2cog.py -f ${ukog} -r ${params.uniprot_db}/uniprot2kog.txt -n ${params.uniprot_db}/CogClass.txt -c ${params.uniprot_db}/kog.txt -o kog.xls
            """
        } else {
            """
            echo \$HOST_Q
            python3 ${script_path}/uniprot/blast_uniprot2cog.py -f ${ukog} -r ${params.uniprot_db}/uniprot2kog.txt -n ${params.uniprot_db}/CogClass.txt -c ${params.uniprot_db}/kog.txt -o ${params.sample_name}.kog.xls
            """
        }
}
} else {
process KogResultE{
    tag "KogResult"
    publishDir "${params.regular_out}/kog", mode: 'copy', overwrite:true
    input:
        file txt from KogResult_Fuck

    output:
        file "*.xls" into KogResult_DrawKog,kog_result_summary,kog_result_summary_upset
    script:
        if (params.sample_name == 'None'){
            """
            echo \$HOST_Q
            python3 ${script_path}/uniprot/cogData.py ${txt} ${params.uniprot_db}/kog.txt ${params.uniprot_db}/CogClass.txt kog.xls
            """
        } else {
            """
            echo \$HOST_Q
            python3 ${script_path}/uniprot/cogData.py ${txt} ${params.uniprot_db}/kog.txt ${params.uniprot_db}/CogClass.txt ${params.sample_name}.kog.xls
            """
        }
}
}

process DrawKog{
    tag "DrawKog"
    publishDir "${params.regular_out}/kog", mode: 'copy', overwrite:true
    input:
        file txt from KogResult_DrawKog

    output:
        file "*g.png"
        file "*g.pdf"
        file "*g.svg"
    script:
        """
        echo \$HOST_Q
        python3 ${script_path}/uniprot/kong_remove.py ${txt} 'Rscript ${script_path}/uniprot/kog.R ${txt} kog' ${script_path}/uniprot
        #Rscript ${script_path}/uniprot/kog.R ${txt} kog
        """
}
} else {
process KogResultNo{
    tag "KogResultNo"

    output:
        file "*kog.xls" into kog_result_summary,kog_result_summary_upset
    script:
        """
        echo \$HOST_Q
        touch kog.xls
        """
}
}

//##############PFAM Anno##############
if (params.pfam != false){
int ooptsplitp="${params.splitp}".toInteger()

process SplitPfam{
    tag "split_pfam"
    input:
        file fasta from target_fastaFile
        val optsplitp from ooptsplitp

    output:
        file "${fasta}.cut/${fasta}.*" into subFastaFile_pfam
    script:
        """
        echo \$HOST_Q
        perl ${script_path}/fastaDeal.pl --cutf ${optsplitp} ${fasta}
        """
}

process HmmPfam{
    tag "${fasta}"
    input:
        file fasta from subFastaFile_pfam.flatten()
    
    output:
        file "${fasta}.domtblout" into pfamFile
    script:
        """
        echo \$HOST_Q
        ${params.hmmscan} --cpu ${params.pcpu} -E 0.01 --tblout ${fasta}.tblout --domtblout ${fasta}.domtblout ${params.pfam_db}/Pfam-A.hmm ${fasta}
        """
}

process MergePfam{
    tag "MergePfam"
    input:
        file pfam from pfamFile.collect()

    output:
        file "pfam_tmp_hmm.xls" into pfamOut,FormatPfam
    script:
        """
        echo \$HOST_Q
        for m6File in ${pfam}
        do
            cat \$m6File >> pfam_all.xls
        done
        awk 'NR<4||\$0 !~/^#/ ' pfam_all.xls > pfam_tmp_hmm.xls
        """
}

process FMergePfam{
    tag "FMergePfam"
    publishDir "${params.regular_out}/pfam", mode: 'copy', overwrite:true
    input:
        file pfam from FormatPfam

    output:
        file "pfam_hmm.xls"
    script:
        """
        echo \$HOST_Q
        sed 1d ${pfam} | sed 's/^# //g' |sed 2d |sed 's/target name/target_name/g' |sed 's/query name/query_name/g' |sed 's/description of target/description_of_target/g' |sed 's/[[:space:]]\\{1,100\\}/\\t/g' > pfam_hmm.xls
        """
}

process PfamResult{
    tag "PfamResult"
    publishDir "${params.regular_out}/pfam", mode: 'copy', overwrite:true
    input:
        file pfam from pfamOut

    output:
        file "*pfam.xls" into pfam_result_draw_pfam,pfam_result_summary,pfam_result_summary_upset
        file "*pfam_stringent_hmm.xls"
    script:
        if (params.sample_name == 'None'){
            """
            echo \$HOST_Q
            python3 ${script_path}/pfam/pfam-hmmscan-parser.py ${pfam} 1e-5 0.35 > pfam_stringent_hmm.xls
            cat pfam_stringent_hmm.xls|sed 's/#Seq ID/Seq ID/'|awk -F'\\t' '{print \$1"\\t"\$3"\\t"\$4"\\t"\$12}' > pfam.xls
            #python ${script_path}/pfam/pfam2result.py -f ${pfam} -e 0.01 -o pfam.xls
            """
        } else {
            """
            echo \$HOST_Q
            python3 ${script_path}/pfam/pfam-hmmscan-parser.py ${pfam} 1e-5 0.35 > ${params.sample_name}.pfam_stringent_hmm.xls
            cat ${params.sample_name}.pfam_stringent_hmm.xls|sed 's/#Seq ID/Seq ID/'|awk -F'\\t' '{print \$1"\\t"\$3"\\t"\$4"\\t"\$12}' > ${params.sample_name}.pfam.xls
            #python ${script_path}/pfam/pfam2result.py -f ${pfam} -e 0.01 -o ${params.sample_name}.pfam.xls
            """
        }
}

process DrawPfam{
    tag "DrawPfam"
    publishDir "${params.regular_out}/pfam", mode: 'copy', overwrite:true
    input:
        file txt from pfam_result_draw_pfam

    output:
        file "pfam.pdf"
        file "pfam.png"
        file "pfam.svg"
    script:
        """
        echo \$HOST_Q
        Rscript ${script_path}/pfam/pfam.R ${txt}
        """
}
} else {
process PfamResultNo{
    tag "PfamResultNo"

    output:
        file "*pfam.xls" into pfam_result_summary,pfam_result_summary_upset
    script:
        """
        echo \$HOST_Q
        touch pfam.xls
        """
}
}

//##############Interpro Anno##############
if (params.interpro != false){
int ooptspliti="${params.spliti}".toInteger()
process SplitInterpro{
    tag "SplitInterpro"
    input:
        file fasta from target_fastaFile
        val optspliti from ooptspliti

    output:
        file "${fasta}.cut/${fasta}.*" into subFastaFile_interpro
    script:
        """
        echo \$HOST_Q
        perl ${script_path}/fastaDeal.pl --${params.cutForS} ${optspliti} ${fasta}
        """
}

process Interpro{
    tag "${fasta}"
    input:
        file fasta from subFastaFile_interpro.flatten()
    
    output:
        file "*.tsv" into interproFile
        file "*.gff3" into interprogffFile
    script:
        """
        echo \$HOST_Q
        cat ${fasta} |sed 's/*//g' > ${fasta}.tmp
        export LANG=en_US.UTF-8 && ${params.interpro_db}/interproscan.sh --input ${fasta}.tmp --output-file-base ${fasta} -goterms -pa -dp -verbose -cpu ${params.icpu}
        """
}

process MergeInterproTsv{
    tag "MergeInterproTsv"
    publishDir "${params.regular_out}/iprscan", mode: 'copy', overwrite:true
    input:
        file subinterpro from interproFile.collect()

    output:
        file "*iprscan.tsv.xls" into merge_interpro_tsv_summary,merge_interpro_tsv_summary_upset
    script:
        if (params.sample_name == 'None'){
            """
            echo \$HOST_Q
            for goFile in ${subinterpro}
            do
                cat \$goFile >> iprscan.tsv.xls
            done
            """
        } else {
            """
            echo \$HOST_Q
            for goFile in ${subinterpro}
            do
                cat \$goFile >> ${params.sample_name}.iprscan.tsv.xls
            done
            """
        }
}

process MergeInterproGff{
    tag "MergeInterproGff"
    publishDir "${params.regular_out}/iprscan", mode: 'copy', overwrite:true
    input:
        file subinterpro from interprogffFile.collect()

    output:
        file "*iprscan.gff3"
    script:
        if (params.sample_name == 'None'){
            """
            echo \$HOST_Q
            for goFile in ${subinterpro}
            do
                cat \$goFile >> iprscan.gff3
            done
            """
        } else {
            """
            echo \$HOST_Q
            for goFile in ${subinterpro}
            do
                cat \$goFile >> ${params.sample_name}.iprscan.gff3
            done
            """
        }
}
} else {
process MergeInterproTsvNo{
    tag "MergeInterproTsvNo"

    output:
        file "*iprscan.tsv.xls" into merge_interpro_tsv_summary,merge_interpro_tsv_summary_upset
    script:
        """
        echo \$HOST_Q
        touch iprscan.tsv.xls
        """
}
}

//##############Refseq Anno##############
if (params.refseq != false){
int ooptsplitr="${params.splitr}".toInteger()

process SplitRefseq{
    tag "SplitRefseq"
    input:
        file fasta from target_fastaFile
        val optsplitr from ooptsplitr

    output:
        file "${fasta}.cut/${fasta}.*" into subFastaFile_refseq
    script:
        """
        echo \$HOST_Q
        perl ${script_path}/fastaDeal.pl --cutf ${optsplitr} ${fasta}
        """
}

process BlastRefseq{
    tag "${fasta}"
    input:
        file fasta from subFastaFile_refseq.flatten()
    
    output:
        file "*.blastp.out.m6" into refseqFile
    script:
        """
        echo \$HOST_Q
        ${params.diamond} ${params.map_soft} --evalue 1e-05 --max-target-seqs 1 --db ${params.refseq_db}/${DataChooRef} --query ${fasta} --threads ${params.rcpu} --outfmt 6 'qseqid' 'sseqid' 'pident' 'qcovhsp' 'length' 'mismatch' 'gapopen' 'qstart' 'qend' 'sstart' 'send' 'evalue' 'bitscore' 'stitle' --out ${fasta}.blastp.out.m6
        """
}

process MergeRefseq{
    tag "MergeRefseq"
    publishDir "${params.regular_out}/refseq", mode: 'copy', overwrite:true
    input:
        file refseq from refseqFile.collect()

    output:
        file "refseq_blast.xls" into refseqOut
    script:
        """
        echo \$HOST_Q
        echo -e '#qseqid\\tsseqid\\tpident\\tqcovhsp\\tlength\\tmismatch\\tgapopen\\tqstart\\tqend\\tsstart\\tsend\\tevalue\\tbitscore\\tstitle' > refseq_blast.xls
        for m6File in ${refseq}
        do
            cat \$m6File >> refseq_blast.xls
        done
        """
}

process RefseqResult{
    tag "RefseqResult"
    publishDir "${params.regular_out}/refseq", mode: 'copy', overwrite:true
    input:
        file refseq from refseqOut

    output:
        file "*refseq.xls" into refseq_result_summary,refseq_result_summary_upset
    script:
        if (params.sample_name == 'None'){
            """
            echo \$HOST_Q
            python ${script_path}/refseq/get_refseq.py -n ${refseq} -o refseq.xls
            """
        } else {
            """
            echo \$HOST_Q
            python ${script_path}/refseq/get_refseq.py -n ${refseq} -o ${params.sample_name}.refseq.xls
            """
        }
}
} else {
process RefseqResultNo{
    tag "RefseqResultNo"

    output:
        file "*refseq.xls" into refseq_result_summary,refseq_result_summary_upset
    script:
        """
        echo \$HOST_Q
        touch refseq.xls
        """
}
}

//##############all pep split##############
if (params.tf != false || params.tigerfam != false || params.tcdb != false || params.cazy != false || params.cyped != false || params.card != false || params.ardb != false || params.vfdb != false || params.phi != false){
int ooptsplit="${params.split}".toInteger()
process Split{
    input:
        file fasta from target_fastaFile
        val optsplit from ooptsplit

    output:
        file "${fasta}.cut/${fasta}.*" into subFastaFile_tf
        //file "${fasta}.cut/${fasta}.*" into subFastaFile_tigerfam
        file "${fasta}.cut/${fasta}.*" into subFastaFile_tcdb
        file "${fasta}.cut/${fasta}.*" into subFastaFile_cazy
        file "${fasta}.cut/${fasta}.*" into subFastaFile_cyped
        file "${fasta}.cut/${fasta}.*" into subFastaFile_card
        file "${fasta}.cut/${fasta}.*" into subFastaFile_ardb
        file "${fasta}.cut/${fasta}.*" into subFastaFile_vfdb
        file "${fasta}.cut/${fasta}.*" into subFastaFile_phi
    script:
        """
        echo \$HOST_Q
        perl ${script_path}/fastaDeal.pl --cutf ${optsplit} ${fasta}
        """
}
}

//##############Tf Anno##############
if (params.tf != false){
if (params.kingdom == "Animals" || params.kingdom == "Plants" || params.kingdom == "Human"){
process BlastTf{
    tag "${fasta}"
    input:
        file fasta from subFastaFile_tf.flatten()
    
    output:
        file "${fasta}.out.*" into tfFile
    script:
        if (params.kingdom == 'Animals' || params.kingdom == 'Human'){
            """
            ${params.diamond} blastp --evalue 1e-05 --max-target-seqs 1 --db ${params.anim_tf_db}/TF.dmnd --query ${fasta} --threads ${params.cpu} --outfmt 6 'qseqid' 'sseqid' 'pident' 'qcovhsp' 'length' 'mismatch' 'gapopen' 'qstart' 'qend' 'sstart' 'send' 'evalue' 'bitscore' 'stitle' --out ${fasta}.out.m6
            """
        } else {
            """
            echo \$HOST_Q
            ${params.hmmscan} --cpu ${params.tcpu} -E 1e-5 --tblout ${fasta}.tblout --domtblout ${fasta}.out.domtblout ${params.plant_tf_db}/TF.hmm ${fasta}
            """
        }
}

process MergeTf{
    tag "MergeTf"
    publishDir "${params.regular_out}/tf", mode: 'copy', overwrite:true
    input:
        file subtf from tfFile.collect()

    output:
        file "tf_*.xls" into tfOut
    script:
        if (params.kingdom == 'Animals' || params.kingdom == 'Human'){
            """
            echo \$HOST_Q
            echo -e '#qseqid\\tsseqid\\tpident\\tqcovhsp\\tlength\\tmismatch\\tgapopen\\tqstart\\tqend\\tsstart\\tsend\\tevalue\\tbitscore\\tstitle' > tf_blast.xls
            for m6File in ${subtf}
            do
                cat \$m6File >> tf_blast.xls
            done
            """
        } else {
            """
            echo \$HOST_Q
            for m6File in ${subtf}
            do
                cat \$m6File >> all_tf.xls
            done
            awk 'NR<4||\$0 !~/^#/ ' all_tf.xls > tf_hmm.xls
            """
        }
}

process TfResult{
    tag "TfResult"
    publishDir "${params.regular_out}/tf", mode: 'copy', overwrite:true
    input:
        file tf from tfOut

    output:
        file "*tf.xls" into TfResult_DrawTf,tf_result_summary,tf_result_summary_upset
    script:
        if (params.sample_name == 'None'){
        if (params.kingdom == 'Animals' || params.kingdom == 'Human'){
            """
            python3 ${script_path}/tf/get_animal_family.py ${tf} tf.xls ${params.anim_tf_db}/all_TF.txt
            """
        } else {
            """
            echo \$HOST_Q
            python3 ${script_path}/tf/tf-hmmscan-parser.py ${tf} 1e-5 0.35 > tf_stringent_hmm.xls
            cat tf_stringent_hmm.xls|sed 's/#Seq ID/Seq ID/'|awk -F'\\t' '{print \$1"\\t"\$4"\\t"\$12}' > tf.xls
            """
        }
        } else {
        if (params.kingdom == 'Animals' || params.kingdom == 'Human'){
            """
            python3 ${script_path}/tf/get_animal_family.py ${tf} ${params.sample_name}.tf.xls ${params.anim_tf_db}/all_TF.txt
            """
        } else {
            """
            echo \$HOST_Q
            python3 ${script_path}/tf/tf-hmmscan-parser.py ${tf} 1e-5 0.35 > ${params.sample_name}.tf_stringent_hmm.xls
            cat ${params.sample_name}.tf_stringent_hmm.xls|sed 's/#Seq ID/Seq ID/'|awk -F'\\t' '{print \$1"\\t"\$4"\\t"\$12}' > ${params.sample_name}.tf.xls
            """
        }
        }
}

process DrawTf{
    tag "DrawTf"
    publishDir "${params.regular_out}/tf", mode: 'copy', overwrite:true
    input:
        file txt from TfResult_DrawTf

    output:
        file "TF.pdf"
        file "TF.png"
        file "TF.svg"
        file "TF.xls"
        file "TF.html"
    script:
        """
        echo \$HOST_Q
        Rscript ${script_path}/tf/plot_tf.R ${txt} TF
        export LANG=en_US.UTF-8 && python3 ${script_path}/pie.py -i ${txt} -o TF -l TfFamily
        """
}
} else {
process TfResultNoK{
    tag "TfResultNoK"

    output:
        file "*tf.xls" into tf_result_summary,tf_result_summary_upset
    script:
        """
        echo \$HOST_Q
        touch tf.xls
        """
}
}
} else {
process TfResultNo{
    tag "TfResultNo"

    output:
        file "*tf.xls" into tf_result_summary,tf_result_summary_upset
    script:
        """
        echo \$HOST_Q
        touch tf.xls
        """
}
}

//##############Tigerfam Anno##############
if (params.tigerfam != false){
int ooptsplitt="${params.splitt}".toInteger()

process SplitTigerfam{
    tag "SplitTigerfam"
    input:
        file fasta from target_fastaFile
        val optsplitt from ooptsplitt

    output:
        file "${fasta}.cut/${fasta}.*" into subFastaFile_tigerfam
    script:
        """
        echo \$HOST_Q
        perl ${script_path}/fastaDeal.pl --cutf ${optsplitt} ${fasta}
        """
}

process HmmTigerfam{
    tag "${fasta}"
    input:
        file fasta from subFastaFile_tigerfam.flatten()
    
    output:
        file "${fasta}.domtblout" into subFastaFile_tigerfamFile
    script:
        """
        echo \$HOST_Q
        ${params.hmmscan} --cpu ${params.tcpu} -E 0.01 --tblout ${fasta}.tblout --domtblout ${fasta}.domtblout ${params.tigerfam_db}/TIGRFAMs.hmm ${fasta}
        """
}

process MergeTigerfam{
    tag "MergeTigerfam"
    input:
        file tigerfam from subFastaFile_tigerfamFile.collect()

    output:
        file "tigerfam_tmp_hmm.xls" into tigerfamOut,FormatTigerfam
    script:
        """
        echo \$HOST_Q
        for m6File in ${tigerfam}
        do
            cat \$m6File >> tigerfam_all.xls
        done
        awk 'NR<4||\$0 !~/^#/ ' tigerfam_all.xls > tigerfam_tmp_hmm.xls
        """
}

process FMergeTigerfam{
    tag "FMergeTigerfam"
    publishDir "${params.regular_out}/tigerfam", mode: 'copy', overwrite:true
    input:
        file tigerfam from FormatTigerfam

    output:
        file "tigerfam_hmm.xls"
    script:
        """
        echo \$HOST_Q
        sed 1d ${tigerfam} | sed 's/^# //g' |sed 2d |sed 's/target name/target_name/g' |sed 's/query name/query_name/g' |sed 's/description of target/description_of_target/g' |sed 's/[[:space:]]\\{1,100\\}/\\t/g' > tigerfam_hmm.xls
        """
}

process TigerfamResult{
    tag "TigerfamResult"
    publishDir "${params.regular_out}/tigerfam", mode: 'copy', overwrite:true
    input:
        file tigerfam from tigerfamOut

    output:
        file "*tigerfam.xls" into TigerfamResult_Draw,tigerfam_result_summary,tigerfam_result_summary_upset
        file "*tigerfam_stringent_hmm.xls"
    script:
        if (params.sample_name == 'None'){
            """
            echo \$HOST_Q
            python3 ${script_path}/tigerfam/tigerfam-hmmscan-parser.py ${tigerfam} 1e-5 0.35 > tigerfam_stringent_hmm.xls
            cat tigerfam_stringent_hmm.xls|sed 's/#Seq ID/Seq ID/'|awk -F'\\t' '{print \$1"\\t"\$3"\\t"\$4"\\t"\$12}' > tigerfam.xls
            #python ${script_path}/tigerfam/tigerfam2result.py -f ${tigerfam} -e 0.01 -o tigerfam.xls
            """
        } else {
            """
            echo \$HOST_Q
            python3 ${script_path}/tigerfam/tigerfam-hmmscan-parser.py ${tigerfam} 1e-5 0.35 > ${params.sample_name}.tigerfam_stringent_hmm.xls
            cat ${params.sample_name}.tigerfam_stringent_hmm.xls|sed 's/#Seq ID/Seq ID/'|awk -F'\\t' '{print \$1"\\t"\$3"\\t"\$4"\\t"\$12}' > ${params.sample_name}.tigerfam.xls
            #python ${script_path}/tigerfam/tigerfam2result.py -f ${tigerfam} -e 0.01 -o ${params.sample_name}.tigerfam.xls
            """
        }
}

process DrawTigerfam{
    tag "DrawTigerfam"
    publishDir "${params.regular_out}/tigerfam", mode: 'copy', overwrite:true
    input:
        file txt from TigerfamResult_Draw

    output:
        file "tigerfam.pdf"
        file "tigerfam.png"
        file "tigerfam.svg"
    script:
        """
        echo \$HOST_Q
        Rscript ${script_path}/tigerfam/tigerfam.R ${txt}
        """
}
} else {
process TigerfamResultNo{
    tag "TigerfamResultNo"

    output:
        file "*tigerfam.xls" into tigerfam_result_summary,tigerfam_result_summary_upset
    script:
        """
        echo \$HOST_Q
        touch tigerfam.xls
        """
}
}

//##############Anno Summary##############
if (params.kegg != false || params.nr != false || params.uniprot != false || params.go != false || params.cog != false || params.kog != false || params.pfam != false || params.interpro != false || params.refseq != false || params.tf != false || params.tigerfam != false){
if (params.trans != "None"){
Channel
    .fromPath(params.trans)
    .ifEmpty {ERROR: "Do not find the input file: ${params.trans}"}
    .set{ trans_fastaFile }
trans_fastaFile.collect().set{target_trans_fastaFile}

process AnnoSummaryT{
    tag "AnnoSummaryT"
    publishDir "${params.regular_out}", mode: 'copy', overwrite:true
    input:
        file fasta from target_trans_fastaFile
        file kegg from kegg_pathway_result_summary
        file pathway from pathway_pathway_result_summary
        file nr from nr_result_summary
        file uniprot from uniprot_result_summary
        file go from go_result_summary
        file cog from cog_result_summary
        file kog from kog_result_summary
        file pfam from pfam_result_summary
        file interpro from merge_interpro_tsv_summary
        file refseq from refseq_result_summary
        file tf from tf_result_summary
        file tigerfam from tigerfam_result_summary

    output:
        file "*all_annotation.xls"
        file "*stat.xls"
    script:
        if (params.sample_name == 'None'){
            """
            echo \$HOST_Q
            python3 ${script_path}/all_anno_result.py -seq ${fasta} -kegg ${kegg} -ko ${pathway} -nr ${nr} -uniprot ${uniprot} -go ${go} -cog ${cog} -kog ${kog} -pfam ${pfam} -interpro ${interpro} -refseq ${refseq} -tf ${tf} -tigerfam ${tigerfam} -o ./
            """
        } else {
            """
            echo \$HOST_Q
            python3 ${script_path}/all_anno_result.py -seq ${fasta} -kegg ${kegg} -ko ${pathway} -nr ${nr} -uniprot ${uniprot} -go ${go} -cog ${cog} -kog ${kog} -pfam ${pfam} -interpro ${interpro} -refseq ${refseq} -tf ${tf} -tigerfam ${tigerfam} -o ./
            mv stat.xls ${params.sample_name}.stat.xls
            mv all_annotation.xls ${params.sample_name}.all_annotation.xls
            """
        }
} 
} else {
process AnnoSummary{
    tag "AnnoSummary"
    publishDir "${params.regular_out}", mode: 'copy', overwrite:true
    input:
        file fasta from target_fastaFile
        file kegg from kegg_pathway_result_summary
        file pathway from pathway_pathway_result_summary
        file nr from nr_result_summary
        file uniprot from uniprot_result_summary
        file go from go_result_summary
        file cog from cog_result_summary
        file kog from kog_result_summary
        file pfam from pfam_result_summary
        file interpro from merge_interpro_tsv_summary
        file refseq from refseq_result_summary
        file tf from tf_result_summary
        file tigerfam from tigerfam_result_summary

    output:
        file "*all_annotation.xls"
        file "*stat.xls"
    script:
        if (params.sample_name == 'None'){
            """
            echo \$HOST_Q
            python3 ${script_path}/all_anno_result.py -seq ${fasta} -kegg ${kegg} -ko ${pathway} -nr ${nr} -uniprot ${uniprot} -go ${go} -cog ${cog} -kog ${kog} -pfam ${pfam} -interpro ${interpro} -refseq ${refseq} -tf ${tf} -tigerfam ${tigerfam} -o ./
            """
        } else {
            """
            echo \$HOST_Q
            python3 ${script_path}/all_anno_result.py -seq ${fasta} -kegg ${kegg} -ko ${pathway} -nr ${nr} -uniprot ${uniprot} -go ${go} -cog ${cog} -kog ${kog} -pfam ${pfam} -interpro ${interpro} -refseq ${refseq} -tf ${tf} -tigerfam ${tigerfam} -o ./
            mv stat.xls ${params.sample_name}.stat.xls
            mv all_annotation.xls ${params.sample_name}.all_annotation.xls
            """
        }
}
}
}

fuck_num = 0
if (params.kegg != false){
    fuck_num = fuck_num + 1
}
if (params.nr != false){
    fuck_num = fuck_num + 1
}
if (params.uniprot != false){
    fuck_num = fuck_num + 1
}
if (params.go != false){
    fuck_num = fuck_num + 1
}
if (params.cog != false){
    fuck_num = fuck_num + 1
}
if (params.kog != false){
    fuck_num = fuck_num + 1
}
if (params.pfam != false){
    fuck_num = fuck_num + 1
}
if (params.interpro != false){
    fuck_num = fuck_num + 1
}
if (params.refseq != false){
    fuck_num = fuck_num + 1
}
if (params.tf != false){
    fuck_num = fuck_num + 1
}
if (params.tigerfam != false){
    fuck_num = fuck_num + 1
}
if (fuck_num > 1){
if (params.kegg != false || params.nr != false || params.uniprot != false || params.go != false || params.cog != false || params.kog != false || params.pfam != false || params.interpro != false || params.refseq != false || params.tf != false || params.tigerfam != false){
process AnnoSummaryUpset{
    tag "AnnoSummaryUpset"
    publishDir "${params.regular_out}", mode: 'copy', overwrite:true
    input:
        file kegg from kegg_pathway_result_summary_upset
        file pathway from pathway_pathway_result_summary_upset
        file nr from nr_result_summary_upset
        file uniprot from uniprot_result_summary_upset
        file go from go_result_summary_upset
        file cog from cog_result_summary_upset
        file kog from kog_result_summary_upset
        file pfam from pfam_result_summary_upset
        file interpro from merge_interpro_tsv_summary_upset
        file refseq from refseq_result_summary_upset
        file tf from tf_result_summary_upset
        file tigerfam from tigerfam_result_summary_upset

    output:
        file "all_annotation*"
    script:
        """
        echo \$HOST_Q
        python3 ${script_path}/all_anno_upset.py -kegg ${kegg} -ko ${pathway} -nr ${nr} -uniprot ${uniprot} -go ${go} -cog ${cog} -kog ${kog} -pfam ${pfam} -interpro ${interpro} -refseq ${refseq} -tf ${tf} -tigerfam ${tigerfam} -o ./
        """
}
}
}

//##############Tcdb Anno##############
if (params.tcdb != false){
process BlastTcdb{
    tag "${fasta}"
    input:
        file fasta from subFastaFile_tcdb.flatten()
    
    output:
        file "*.blastp.out.m6" into tcdbFile
    script:
        """
        echo \$HOST_Q
        ${params.diamond} blastp --evalue 1e-05 --max-target-seqs 1 --db ${params.tcdb_db}/tcdb.fa.dmnd --query ${fasta} --threads ${params.cpu} --outfmt 6 'qseqid' 'sseqid' 'pident' 'qcovhsp' 'length' 'mismatch' 'gapopen' 'qstart' 'qend' 'sstart' 'send' 'evalue' 'bitscore' 'stitle' --out ${fasta}.blastp.out.m6
        """
}

process MergeTcdb{
    tag "MergeTcdb"
    publishDir "${params.specific_out}/tcdb", mode: 'copy', overwrite:true
    input:
        file tcdb from tcdbFile.collect()

    output:
        file "tcdb_blast.xls" into tcdbOut
    script:
        """
        echo \$HOST_Q
        echo -e '#qseqid\\tsseqid\\tpident\\tqcovhsp\\tlength\\tmismatch\\tgapopen\\tqstart\\tqend\\tsstart\\tsend\\tevalue\\tbitscore\\tstitle' > tcdb_blast.xls
        for m6File in ${tcdb}
        do
            cat \$m6File >> tcdb_blast.xls
        done
        """
}

process TcdbResult{
    tag "TcdbResult"
    publishDir "${params.specific_out}/tcdb", mode: 'copy', overwrite:true
    input:
        file tcdb from tcdbOut

    output:
        file "*tcdb.xls" into TcdbResult_DrawTcdb,tcdb_result_summary
    script:
        if (params.sample_name == 'None'){
            """
            echo \$HOST_Q
            python3 ${script_path}/tcdb/get_tcdb.py ${tcdb} tcdb.xls
            """
        } else {
            """
            echo \$HOST_Q
            python3 ${script_path}/tcdb/get_tcdb.py ${tcdb} ${params.sample_name}.tcdb.xls
            """
        }
}

process DrawTcdb{
    tag "DrawTcdb"
    publishDir "${params.specific_out}/tcdb", mode: 'copy', overwrite:true
    input:
        file tcdb from TcdbResult_DrawTcdb

    output:
        file "TCDB.pdf"
        file "TCDB.png"
        file "TCDB.svg"
    script:
        """
        echo \$HOST_Q
        Rscript ${script_path}/tcdb/TCDB_plot.R ${tcdb}
        """
}
}

//##############Cazy Anno##############
if (params.cazy != false){
process HmmCazy{
    tag "${fasta}"
    input:
        file fasta from subFastaFile_cazy.flatten()
    
    output:
        file "${fasta}.domtblout" into cazyFile
    script:
        """
        echo \$HOST_Q
        hmmscan --domtblout ${fasta}.domtblout --cpu 16 ${params.cazy_db}/dbCAN.txt ${fasta}
        """
}

process MergeCazy{
    tag "MergeCazy"
    input:
        file cazy from cazyFile.collect()

    output:
        file "cazy_tmp_hmm.xls" into cazyOut,Formatcazy
    script:
        """
        echo \$HOST_Q
        for m6File in ${cazy}
        do
            cat \$m6File >> cazy_tmp_hmm.xls
        done
        """
}

process FMergeCazy{
    tag "FMergeCazy"
    publishDir "${params.specific_out}/cazy", mode: 'copy', overwrite:true
    input:
        file cazy from Formatcazy

    output:
        file "cazy_hmm.xls"
    script:
        """
        echo \$HOST_Q
        sed 1d ${cazy} | sed 's/^# //g' |sed 2d |sed 's/target name/target_name/g' |sed 's/query name/query_name/g' |sed 's/description of target/description_of_target/g' |sed 's/[[:space:]]\\{1,100\\}/\\t/g' > cazy_hmm.xls
        """
}

process CazyResult{
    tag "CazyResult"
    publishDir "${params.specific_out}/cazy", mode: 'copy', overwrite:true
    input:
        file cazy from cazyOut

    output:
        file "*cazy.xls" into cazy_result_summary
        file "*cazy_stringent_hmm.xls"
        file "*cazy_class_stat.xls" into CazyResult_DrawCazy
    script:
        if (params.sample_name == 'None'){
            """
            echo \$HOST_Q
            python3 ${script_path}/cazy/hmmscan-parser.py ${cazy} 1e-18 0.35 > cazy_stringent_hmm.xls
            python3 ${script_path}/cazy/get_cazy.py ${params.cazy_db}/domin_type.txt cazy_stringent_hmm.xls cazy.xls cazy_class_stat.xls
            """
        } else {
            """
            echo \$HOST_Q
            python3 ${script_path}/cazy/hmmscan-parser.py ${cazy} 1e-18 0.35 > ${params.sample_name}.cazy_stringent_hmm.xls
            python3 ${script_path}/cazy/get_cazy.py ${params.cazy_db}/domin_type.txt ${params.sample_name}.cazy_stringent_hmm.xls ${params.sample_name}.cazy.xls ${params.sample_name}.cazy_class_stat.xls
            """
        }
}

process DrawCazy{
    tag "DrawCazy"
    publishDir "${params.specific_out}/cazy", mode: 'copy', overwrite:true
    input:
        file cazy from CazyResult_DrawCazy

    output:
        file "CAZY*pdf"
        file "CAZY*png"
        file "CAZY*svg"
    script:    
        """
        Rscript ${script_path}/cazy/CAZY_plot.R ${cazy}
        """
}
}

//##############Cyped Anno##############
if (params.cyped != false){
process BlastCyped{
    tag "${fasta}"
    input:
        file fasta from subFastaFile_cyped.flatten()
    
    output:
        file "*.blastp.out.m6" into cypedFile
    script:
        """
        echo \$HOST_Q
        ${params.diamond} blastp --evalue 1e-05 --max-target-seqs 1 --db ${params.cyped_db}/cyped.fa.dmnd --query ${fasta} --threads ${params.cpu} --outfmt 6 'qseqid' 'sseqid' 'pident' 'qcovhsp' 'length' 'mismatch' 'gapopen' 'qstart' 'qend' 'sstart' 'send' 'evalue' 'bitscore' 'stitle' --out ${fasta}.blastp.out.m6
        """
}

process MergeCyped{
    tag "MergeCyped"
    publishDir "${params.specific_out}/cyped", mode: 'copy', overwrite:true
    input:
        file cyped from cypedFile.collect()

    output:
        file "cyped_blast.xls" into cypedOut
    script:
        """
        echo \$HOST_Q
        echo -e '#qseqid\\tsseqid\\tpident\\tqcovhsp\\tlength\\tmismatch\\tgapopen\\tqstart\\tqend\\tsstart\\tsend\\tevalue\\tbitscore\\tstitle' > cyped_blast.xls
        for m6File in ${cyped}
        do
            cat \$m6File >> cyped_blast.xls
        done
        """
}

process CypedResult{
    tag "CypedResult"
    publishDir "${params.specific_out}/cyped", mode: 'copy', overwrite:true
    input:
        file cyped from cypedOut

    output:
        file "*cyped.xls" into cyped_result_summary
    script:
        if (params.sample_name == 'None'){
            """
            echo \$HOST_Q
            python3 ${script_path}/cyped/get_cyped.py ${cyped} cyped.xls
            """
        } else {
            """
            echo \$HOST_Q
            python3 ${script_path}/cyped/get_cyped.py ${cyped} ${params.sample_name}.cyped.xls
            """
        }
}
}

//##############Tmhmm Anno##############
if (params.tmhmm != false){
process TmhmmResult{
    tag "TmhmmResult"
    input:
        file fasta from target_fastaFile

    output:
        file "ss.result" into TmhmmResult_TmhmmResultShort,TmhmmResult_TmhmmResultLong,TmhmmResult_TmhmmResultHtml
    script:
        """
        echo \$HOST_Q
        cat ${fasta} |sed 's/*//g' > seq.fasta
        python3 ${script_path}/tmhmm/test.py 'cat seq.fasta | ${params.tmhmmDir}/bin/decodeanhmm.Linux_x86_64 -f ${params.tmhmmDir}/lib/TMHMM2.0.options -modelfile ${params.tmhmmDir}/lib/TMHMM2.0.model -N1 -PrintNumbers -PrintScore -PrintStat -plp > ss.result'
        """
}

process TmhmmResultShort{
    tag "TmhmmResultShort"
    publishDir "${params.specific_out}/tmhmm", mode: 'copy', overwrite:true
    input:
        file result_tm from TmhmmResult_TmhmmResultShort

    output:
        file "TMHMM_short_result.xls" into gene_short
        file "TMHMM_result.xls" into TmhmmResultShort_ss
        file "TMHMM_num.xls"
    script:
        """
        echo \$HOST_Q
        cat ${result_tm} | ${params.tmhmmDir}/bin/tmhmmFormat.pl -short > tmp_short_result.xls
        python3 ${script_path}/tmhmm/get_short_result.py tmp_short_result.xls TMHMM_short_result.xls
        awk -F'\\t' '\$5>0{print \$0}' TMHMM_short_result.xls > TMHMM_result.xls
        python3 ${script_path}/tmhmm/get_tmhmm_num.py TMHMM_result.xls TMHMM_num.xls
        """
}

process TmhmmResultLongTemp{
    tag "TmhmmResultLongTemp"
    input:
        file result_tm from TmhmmResult_TmhmmResultLong

    output:
        file "TMHMM_long_result.tmp.xls" into TmhmmResultLongTemp_TmhmmResultLong
        file "*.eps" into tmhmmP
    script:
        """
        echo \$HOST_Q
        cat ${result_tm} | ${params.tmhmmDir}/bin/tmhmmFormat.pl > TMHMM_long_result.tmp.xls
        """
}

process TmhmmResultLong{
    tag "TmhmmResultLong"
    publishDir "${params.specific_out}/tmhmm", mode: 'copy', overwrite:true
    input:
        file result_tm from TmhmmResultLongTemp_TmhmmResultLong

    output:
        file "TMHMM_long_result.xls" into gene_long
    script:
        """
        echo \$HOST_Q
        ln -s ${result_tm} TMHMM_long_result.xls
        """
}

if (params.pict_Tmhmm != 'n'){
int optMaxF_Tm="${params.maxF_Tm}".toInteger()

process TmhmmResultPicture{
    tag "TmhmmResultPicture"
    maxForks optMaxF_Tm
    publishDir "${params.specific_out}/tmhmm/TMHMM_plot", mode: 'copy', overwrite:true
    input:
        file result_tm from tmhmmP.collect()

    output:
        file "*.pdf"
        file "*.png"
    script:
        """
        echo \$HOST_Q
        python3 ${script_path}/tmhmm/get_plot_result.py
        """
}

process TmhmmResultHtml{
    tag "TmhmmResultHtml"
    publishDir "${params.specific_out}/tmhmm", mode: 'copy', overwrite:true
    input:
        file result_tm from TmhmmResult_TmhmmResultHtml

    output:
        file "TMHMM_result.html"
    script:
        """
        echo \$HOST_Q
        cat ${result_tm} | ${params.tmhmmDir}/bin/tmhmmFormat.pl -html > TMHMM_result.html
        """
}
}
}

//##############Signal Anno##############
if (params.signalp != false){
int optMaxF_Sig="${params.maxF_Sig}".toInteger()

process SplitSignal{
    tag "SplitSignal"
    input:
        file fasta from target_fastaFile

    output:
        file "${fasta}.cut/${fasta}.*" into subFastaFile_Signal
    script:
        """
        echo \$HOST_Q
        perl ${script_path}/fastaDeal.pl --cutf 100 ${fasta}
        """
}

process SignalResultRun{
    tag "${fasta}"
    maxForks optMaxF_Sig
    input:
        file fasta from subFastaFile_Signal.flatten()

    output:
        file "Tmp/${fasta}_summary.signalp5" into Signal_summary_split
        file "Tmp/${fasta}.gff3" into Signal_gff_split
        file "Tmp/${fasta}_mature.fasta" into Signal_fasta_split
        file "Signalp_plot_tmp/*" into SignalP
    script:
        """
        echo \$HOST_Q
        mkdir Tmp
        cd Tmp
        ${params.signalpP} -fasta ../${fasta} -batch 50 -gff3 -mature -format long -prefix ${fasta} -tmp ./ -plot eps -org ${params.signalp_type}
        sed -i '1,1d' ${fasta}.gff3
        cd ..
        python3 ${script_path}/signalp/get_plot_signal_tmp.py Tmp/${fasta}_summary.signalp5 ${fasta} all
        touch Signalp_plot_tmp/${fasta}.txt
        """
}

process SignalResultTemp{
    tag "SignalResultTemp"
    input:
        file signalp from Signal_summary_split.collect()
        file gff from Signal_gff_split.collect()
        file fasta from Signal_fasta_split.collect()

    output:
        file "all_summary.signalp5" into Signal_summary
        file "all.gff3" into Signal_gff
        file "all_mature.fasta" into Signal_fasta
    script:
        """
        echo \$HOST_Q
        cat *_summary.signalp5 > all_summary.signalp5
        echo -e '##gff-version 3' > all_tmp.gff3
        cat all_tmp.gff3 *.gff3 >> all.gff3
        cat *_mature.fasta > all_mature.fasta
        """
}

process SignalResult{
    tag "SignalResult"
    publishDir "${params.specific_out}/signalp", mode: 'copy', overwrite:true
    input:
        file aa from Signal_summary
        file bb from Signal_gff
        file cc from Signal_fasta

    output:
        file "Signalp_summary.xls" into fuck_you
        file "Signalp_result.xls" into SignalResult_ss
        file "Signalp.gff3" into signal_gene_gff
        file "Signalp_mature.fasta" into signal_gene_mmfa
        file "Signalp_num.xls"
    script:
        """
        echo \$HOST_Q
        #python3 ${script_path}/signalp/get_siggg.py ${aa} Signalp_summary.xls
        ln -s ${bb} Signalp.gff3
        ln -s ${cc} Signalp_mature.fasta
        #grep -v 'OTHER' Signalp_summary.xls | sed '1i ID\\tPrediction\\tSP(Sec/SPI)\\tOTHER\\tCS Position' > Signalp_result.xls
        python3 ${script_path}/signalp/get_Sigsum.py ${aa} Signalp_summary.xls Signalp_result.xls
        python3 ${script_path}/signalp/get_signal_num.py Signalp_result.xls Signalp_num.xls
        """
}

if (params.pict_Signal != 'n'){
process SignalResultPicture{
    tag "SignalResultPicture"
    maxForks optMaxF_Sig
    publishDir "${params.specific_out}/signalp/Signalp_plot", mode: 'copy', overwrite:true
    input:
        file result_si from SignalP.collect()
        file aa from fuck_you.collect()

    output:
        file "*.pdf"
        file "*.png"
    script:
        """
        echo \$HOST_Q
        python3 ${script_path}/signalp/get_plot_signal.py all
        """
}
}
}

//##############Deeploc Anno##############
if (params.deeploc != false){
process SplitDeeploc{
    tag "SplitDeeploc"
    input:
        file fasta from target_fastaFile

    output:
        file "${fasta}.cut/${fasta}.*" into subFastaFile_deep
    script:
        """
        echo \$HOST_Q
        perl ${script_path}/fastaDeal.pl --cutf 500 ${fasta}
        """
}

process Deeploc{
    tag "${fasta}"
    input:
        file fasta from subFastaFile_deep.flatten()
    
    output:
        file "${fasta}.txt" into DeeplocFile
    script:
        """
        echo \$HOST_Q
        python3 ${script_path}/deeploc/get_short.py ${fasta} bb
        export PYTHON_EGG_CACHE=\$PWD
        ${params.deeplocP} -f bb -o ${fasta}
        sed -i '1,1d' ${fasta}.txt
        """
}

process DeeplocResult{
    tag "DeeplocResult"
    publishDir "${params.specific_out}/deeploc", mode: 'copy', overwrite:true
    input:
        file subtf from DeeplocFile.collect()

    output:
        file "Deeploc.xls"
    script:
        """
        echo \$HOST_Q
        for m6File in ${subtf}
        do
            cat \$m6File >> ${params.sample_name}.txt
        done

        python3 ${script_path}/deeploc/add_head.py ${params.sample_name}.txt Deeploc.xls
        """
}
}

//##############Card Anno##############
if (params.card != false){
process Rgi{
    tag "${fasta}"
    input:
        file fasta from subFastaFile_card.flatten()
    
    output:
        file "${fasta}_rgi.txt" into cardFile
    script:
        """
        echo \$HOST_Q
        python3 ${script_path}/card/format_fasta.py ${fasta} tmp_${fasta}
        ${params.rgi} load --card_json ${params.card_db}/card.json --local && ${params.rgi} main -i tmp_${fasta} -o ${fasta}_rgi -t protein -a BLAST -n ${params.cpu} --clean --local --include_loose
        """
}

process MergeRgi{
    tag "MergeRgi"
    publishDir "${params.specific_out}/card", mode: 'copy', overwrite:true
    input:
        file card from cardFile.collect()

    output:
        file "card_rgi.xls" into cardOut
    script:
        """
        echo \$HOST_Q
        for m6File in ${card}
        do
            cat \$m6File >> tmp_card_rgi.xls
        done
        python3 ${script_path}/card/remove_kong.py tmp_card_rgi.xls card_rgi.xls
        """
}

process RgiResult{
    tag "RgiResult"
    publishDir "${params.specific_out}/card", mode: 'copy', overwrite:true
    input:
        file card from cardOut

    output:
        file "*card.xls" into card_result_summary
    script:
        if (params.sample_name == 'None'){
            """
            echo \$HOST_Q
            python3 ${script_path}/card/get_card.py ${card} card.xls
            """
        } else {
            """
            echo \$HOST_Q
            python3 ${script_path}/card/get_card.py ${card} ${params.sample_name}.card.xls
            """
        }
}
}

//##############Ardb Anno##############
if (params.ardb != false){
process BlastArdb{
    tag "${fasta}"
    input:
        file fasta from subFastaFile_ardb.flatten()
    
    output:
        file "*.blastp.out.m6" into ardbFile
    script:
        if (params.engine == "ncbiblast"){
            """
            echo \$HOST_Q
            ${params.blastp} -evalue 1e-05  -max_target_seqs 1 -db ${params.ardb_db}/ardb.fa -query ${fasta} -num_threads ${params.cpu} -outfmt '6 qseqid sseqid pident qcovs length mismatch gapopen qstart qend sstart send evalue bitscore stitle' -out ${fasta}.blastp.out.m6
            """
        } else {
            """
            echo \$HOST_Q
            ${params.diamond} blastp --evalue 1e-05 --max-target-seqs 1 --db ${params.ardb_db}/ardb.fa.dmnd --query ${fasta} --threads ${params.cpu} --outfmt 6 'qseqid' 'sseqid' 'pident' 'qcovhsp' 'length' 'mismatch' 'gapopen' 'qstart' 'qend' 'sstart' 'send' 'evalue' 'bitscore' 'stitle' --out ${fasta}.blastp.out.m6
            """
        }
}

process MergeArdb{
    tag "MergeArdb"
    publishDir "${params.specific_out}/ardb", mode: 'copy', overwrite:true
    input:
        file ardb from ardbFile.collect()

    output:
        file "ardb_blast.xls" into ardbOut
    script:
        """
        echo \$HOST_Q
        echo -e '#qseqid\\tsseqid\\tpident\\tqcovs\\tlength\\tmismatch\\tgapopen\\tqstart\\tqend\\tsstart\\tsend\\tevalue\\tbitscore\\tstitle' > ardb_blast.xls
        for m6File in ${ardb}
        do
            cat \$m6File >> ardb_blast.xls
        done
        """
}

process ArdbResult{
    tag "ArdbResult"
    publishDir "${params.specific_out}/ardb", mode: 'copy', overwrite:true
    input:
        file ardb from ardbOut

    output:
        file "*ardb.xls" into ardb_result_summary
        file "*ardb_type.xls"
    script:
        if (params.sample_name == 'None'){
            """
            echo \$HOST_Q
            python3 ${script_path}/ardb/get_ardb.py ${params.ardb_db}/ardb.txt ${ardb} ardb.xls ardb_type.xls
            """
        } else {
            """
            echo \$HOST_Q
            python3 ${script_path}/ardb/get_ardb.py ${params.ardb_db}/ardb.txt ${ardb} ${params.sample_name}.ardb.xls ${params.sample_name}.ardb_type.xls
            """
        }
}
}

//##############Vfdb Anno##############
if (params.vfdb != false){
process BlastVfdb{
    tag "${fasta}"
    input:
        file fasta from subFastaFile_vfdb.flatten()
    
    output:
        file "*.blastp.out.m6" into vfdbFile
    script:
        if (params.engine == "ncbiblast"){
            """
            echo \$HOST_Q
            ${params.blastp} -evalue 1e-05  -max_target_seqs 1 -db ${params.vfdb_db}/VFDB.fa -query ${fasta} -num_threads ${params.cpu} -outfmt '6 qseqid sseqid pident qcovs length mismatch gapopen qstart qend sstart send evalue bitscore stitle' -out ${fasta}.blastp.out.m6
            """
        } else {
            """
            echo \$HOST_Q
            ${params.diamond} blastp --evalue 1e-05 --max-target-seqs 1 --db ${params.vfdb_db}/VFDB.fa.dmnd --query ${fasta} --threads ${params.cpu} --outfmt 6 'qseqid' 'sseqid' 'pident' 'qcovhsp' 'length' 'mismatch' 'gapopen' 'qstart' 'qend' 'sstart' 'send' 'evalue' 'bitscore' 'stitle' --out ${fasta}.blastp.out.m6
            """
        }
}

process MergeVfdb{
    tag "MergeVfdb"
    publishDir "${params.specific_out}/vfdb", mode: 'copy', overwrite:true
    input:
        file vfdb from vfdbFile.collect()

    output:
        file "vfdb_blast.xls" into vfdbOut
    script:
        """
        echo \$HOST_Q
        echo -e '#qseqid\\tsseqid\\tpident\\tqcovs\\tlength\\tmismatch\\tgapopen\\tqstart\\tqend\\tsstart\\tsend\\tevalue\\tbitscore\\tstitle' > vfdb_blast.xls
        for m6File in ${vfdb}
        do
            cat \$m6File >> vfdb_blast.xls
        done
        """
}

process VfdbResult{
    tag "VfdbResult"
    publishDir "${params.specific_out}/vfdb", mode: 'copy', overwrite:true
    input:
        file vfdb from vfdbOut

    output:
        file "*vfdb.xls" into vfdb_result_summary
    script:
        if (params.sample_name == 'None'){
            """
            echo \$HOST_Q
            python3 ${script_path}/vfdb/get_vfdb.py ${vfdb} vfdb.xls
            """
        } else {
            """
            echo \$HOST_Q
            python3 ${script_path}/vfdb/get_vfdb.py ${vfdb} ${params.sample_name}.vfdb.xls
            """
        }
}
}

//##############Phi Anno##############
if (params.phi != false){
process BlastPhi{
    tag "${fasta}"
    input:
        file fasta from subFastaFile_phi.flatten()
    
    output:
        file "*.blastp.out.m6" into phiFile
    script:
        if (params.engine == "ncbiblast"){
            """
            echo \$HOST_Q
            ${params.blastp} -evalue 1e-05  -max_target_seqs 1 -db ${params.phi_db}/phi-base.fa -query ${fasta} -num_threads ${params.cpu} -outfmt '6 qseqid sseqid pident qcovs length mismatch gapopen qstart qend sstart send evalue bitscore stitle' -out ${fasta}.blastp.out.m6
            """
        } else {
            """
            echo \$HOST_Q
            ${params.diamond} blastp --evalue 1e-05 --max-target-seqs 1 --db ${params.phi_db}/phi-base.fa.dmnd --query ${fasta} --threads ${params.cpu} --outfmt 6 'qseqid' 'sseqid' 'pident' 'qcovhsp' 'length' 'mismatch' 'gapopen' 'qstart' 'qend' 'sstart' 'send' 'evalue' 'bitscore' 'stitle' --out ${fasta}.blastp.out.m6
            """
        }
}

process MergePhi{
    tag "MergePhi"
    publishDir "${params.specific_out}/phi", mode: 'copy', overwrite:true
    input:
        file phi from phiFile.collect()

    output:
        file "phi_blast.xls" into phiOut
    script:
        """
        echo \$HOST_Q
        echo -e '#qseqid\\tsseqid\\tpident\\tqcovs\\tlength\\tmismatch\\tgapopen\\tqstart\\tqend\\tsstart\\tsend\\tevalue\\tbitscore\\tstitle' > phi_blast.xls
        for m6File in ${phi}
        do
            cat \$m6File >> phi_blast.xls
        done
        """
}

process PhiResult{
    tag "PhiResult"
    publishDir "${params.specific_out}/phi", mode: 'copy', overwrite:true
    input:
        file phi from phiOut

    output:
        file "*phi.xls" into phi_result_summary
    script:
        if (params.sample_name == 'None'){
            """
            echo \$HOST_Q
            python ${script_path}/phi/get_phi.py ${phi} phi.xls
            """
        } else {
            """
            echo \$HOST_Q
            python ${script_path}/phi/get_phi.py ${phi} ${params.sample_name}.phi.xls
            """
        }
}
}

//##############Island Anno##############
if (params.island != false){
process SplitDimob{
    tag "SplitDimob"
    input:
        file gbk from target_gbkFile

    output:
        file "tmp/*.gbk" into SplitDimob_Dimob
        file "tmp/repp_name.txt" into get_ok_all
    script:
        """
        echo \$HOST_Q
        python3 ${script_path}/island/split_gbkDimob.py -i ${gbk} -o tmp -s ${params.island_len}
        """
}

process Dimob{
    tag "${gbk}"
    input:
        file gbk from SplitDimob_Dimob.flatten()

    output:
        file "*GI_all.txt" into Dimob_Island
    script:
        """
        echo \$HOST_Q
        python3 ${script_path}/island/Dimob.py -i ${gbk} -d ${params.Dimobp} -o ./
        """
}

process Island{
    tag "Island"
    publishDir "${params.element_out}/island", mode: 'copy', overwrite:true
    input:
        file gbkcsv from Dimob_Island.collect()
        file txt from get_ok_all.collect()

    output:
        file "island.xls"
    script:
        """
        echo \$HOST_Q
        python3 ${script_path}/island/ganDimob.py island.xls ${txt}
        """
}
}

//##############Phispy Anno##############
if (params.phispy != false){
process SplitPhispy{
    tag "SplitPhispy"
    input:
        file gbk from target_gbkFile

    output:
        file "tmp/*.gbk" into SplitPhispy_Phispy
    script:
        """
        echo \$HOST_Q
        python3 ${script_path}/phispy/split_gbk.py -i ${gbk} -o tmp -s ${params.phispy_len}
        """
}

process Phispy{
    tag "${gbk}"
    input:
        file gbk from SplitPhispy_Phispy.flatten()

    output:
        file "${gbk}.prophage_coordinates.tsv" into Phispy_Prophagescsv
        file "${gbk}.prophage.tbl" into Phispy_Prophagestbl
    script:
        """
        echo \$HOST_Q
        python3 ${script_path}/phispy/ganPhiSpy.py 'export LANG=en_US.UTF-8 && ${params.PhiSpy} ${gbk} --threads ${params.cpu} --output_choice 512 -o phispy_out --keep_dropped_predictions --phage_genes 1 -n 1 -u ${params.phispy_len}'
        cp phispy_out/prophage_coordinates.tsv ${gbk}.prophage_coordinates.tsv
        cp phispy_out/prophage.tbl ${gbk}.prophage.tbl
        """
}

process Prophages{
    tag "Prophages"
    publishDir "${params.element_out}/prophage", mode: 'copy', overwrite:true
    input:
        file gbkcsv from Phispy_Prophagescsv.collect()
        file gbktbl from Phispy_Prophagestbl.collect()

    output:
        file "prophage_coordinates.xls"
        file "prophage.tbl.xls"
    script:
        """
        echo \$HOST_Q
        echo -e 'PP_ID\\tContig_ID\\tPP_start\\tPP_end\\tattL_start\\tattL_end\\tattR_start\\tattR_end\\tattL_sequence\\tattR_sequence\\tReason' > prophage_coordinates.xls
        for csvFile in ${gbkcsv}
        do
            cat \$csvFile >> prophage_coordinates.xls
        done

        echo -e 'PP_ID\\tPosition' > prophage.tbl.xls
        for tblFile in ${gbktbl}
        do
            cat \$tblFile >> prophage.tbl.xls
        done
        """
}
}

//##############Minced Anno##############
if (params.minced != false){
process CRISPRsResult{
    tag "CRISPRsResult"
    publishDir "${params.element_out}/CRISPRs", mode: 'copy', overwrite:true
    input:
        file genome from target_genomeFile

    output:
        file "*crisprs.gff3"
        file "*crisprs.txt"
        file "*crisprs.xls"
    script:
        if (params.sample_name == 'None'){
            """
            echo \$HOST_Q
            python3 ${script_path}/minced/get_minced_result.py 'minced -minNR 1 ${genome} crisprs.txt gff3' ${params.sample_name}
            python3 ${script_path}/minced/get_crispr.py crisprs.gff3 crisprs.xls
            #minced ${genome} crisprs.txt gff3
            #echo '##gff-version 3' > crisprs.gff3
            #echo -e '#seqid\\tsource\\ttype\\tstart\\tend\\tscore\\tstrand\\tphase\\tattributes' >> crisprs.gff3
            #grep -v '#' gff3 >> crisprs.gff3
            """
        } else {
            """
            echo \$HOST_Q
            python3 ${script_path}/minced/get_minced_result.py 'minced -minNR 1 ${genome} ${params.sample_name}.crisprs.txt gff3' ${params.sample_name}
            python3 ${script_path}/minced/get_crispr.py ${params.sample_name}.crisprs.gff3 ${params.sample_name}.crisprs.xls
            #minced ${genome} ${params.sample_name}.crisprs.txt gff3
            #echo '##gff-version 3' > ${params.sample_name}.crisprs.gff3
            #echo -e '#seqid\\tsource\\ttype\\tstart\\tend\\tscore\\tstrand\\tphase\\tattributes' >> ${params.sample_name}.crisprs.gff3
            #grep -v '#' gff3 >> ${params.sample_name}.crisprs.gff3
            """
        }
}
}

//##############Antismash Anno##############
if (params.kingdom == 'Archaea' || params.kingdom == 'Bacteria' || params.kingdom == 'B_A_V' || params.kingdom == 'Fungi' || params.kingdom == 'B_A_F_V'){
if (params.antismash != false){
if (params.kingdom == 'Archaea' || params.kingdom == 'Bacteria' || params.kingdom == 'B_A_V' || params.kingdom == 'B_A_F_V'){
    anti_choose = "--taxon bacteria --genefinding-tool prodigal"
} else {
    anti_choose = "--taxon fungi --genefinding-tool glimmerhmm"
}

if (params.antimode == 'gbk'){
Channel
    .fromPath(params.gbk)
    .ifEmpty {ERROR: "Do not find the input file: ${params.gbk}"}
    .set{ gbkFileAnti }
gbkFileAnti.collect().set{target_gbkFileAnti}
}

if (params.antimode == 'fasta'){
Channel
    .fromPath(params.genome)
    .ifEmpty {ERROR: "Do not find the input file: ${params.genome}"}
    .set{ genomeFileAnti }
genomeFileAnti.collect().set{target_genomeFileAnti}
}

if (params.antimode == 'fasta_gff'){
Channel
    .fromPath(params.genome)
    .ifEmpty {ERROR: "Do not find the input file: ${params.genome}"}
    .set{ genomeFileAnti }
genomeFileAnti.collect().set{target_genomeFileAnti}
Channel
    .fromPath(params.gff)
    .ifEmpty {ERROR: "Do not find the input file: ${params.gff}"}
    .set{ gffFileAnti }
gffFileAnti.collect().set{target_gffFileAnti}
}

if (params.antimode == 'gbk'){
process AntismashResultGB{
    tag "AntismashResultGB"
    publishDir "${params.element_out}/antismash", mode: 'copy', overwrite:true
    input:
        file gbk from target_gbkFileAnti

    output:
        file "antismash.zip"
    script:
        """
        echo \$HOST_Q
        ${params.SoftAnti} ${anti_choose} --cb-general --cb-knownclusters --cb-subclusters --asf --pfam2go --smcog-trees --output-dir Antis --output-basename antismash ${gbk}
        cp Antis/antismash.zip ./
        chmod 755 antismash.zip
        """
}
}

if (params.antimode == 'fasta'){
process AntismashResultGG{
    tag "AntismashResultGG"
    publishDir "${params.element_out}/antismash", mode: 'copy', overwrite:true
    input:
        file genome from target_genomeFileAnti

    output:
        file "antismash.zip"
    script:
        """
        echo \$HOST_Q
        ${params.SoftAnti} ${anti_choose} --cb-general --cb-knownclusters --cb-subclusters --asf --pfam2go --smcog-trees --output-dir Antis --output-basename antismash ${genome}
        cp Antis/antismash.zip ./
        """
}
}

if (params.antimode == 'fasta_gff'){
process AntismashResultGF{
    tag "AntismashResultGF"
    publishDir "${params.element_out}/antismash", mode: 'copy', overwrite:true
    input:
        file genome from target_genomeFileAnti
        file gff from target_gffFileAnti

    output:
        file "antismash.zip"
    script:
        """
        echo \$HOST_Q
        ${params.SoftAnti} ${anti_choose} --cb-general --cb-knownclusters --cb-subclusters --asf --pfam2go --smcog-trees --output-dir Antis --output-basename antismash ${genome} --genefinding-gff3 ${gff}
        cp Antis/antismash.zip ./
        """
}
}
}
}

//##############SecretedProtein Anno##############
if (params.signalp != false && params.tmhmm != false){
process SecretedProtein{
    tag "SecretedProtein"
    publishDir "${params.specific_out}/secretedProtein", mode: 'copy', overwrite:true
    input:
        file signalp from SignalResult_ss
        file tmhmm from TmhmmResultShort_ss

    output:
        file "Secreted_result.xls"
        file "Secreted_num.xls"
    script:
        """
        echo \$HOST_Q
        python3 ${script_path}/signalp/get_secreted.py ${tmhmm} ${signalp} Secreted_result.xls
        python3 ${script_path}/signalp/get_secreted_num.py Secreted_result.xls Secreted_num.xls
        """
}
}