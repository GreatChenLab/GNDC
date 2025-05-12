if(params.help || params.h){
log.info """
###必要输入
    --genome                        <str>  input genome fasta file
    --sample_name                   <str>  Result file prefix
    --format_genome                 <str>  input genome fasta file, choose from [y, n]                           [${params.format_genome}]
    --transcode_mem                 <int>  input transcode use mem                                               [${params.transcode_mem}]
    -profile                        <str>  Different servers use different configurations, choose from [sge_docker,slurm_docker,sge_singularity,slurm_singularity]
###转录注释相关参数
    --data_set                      <str>  choose from [NGS, PB, ONT, NGS_ONT, NGS_PB]
    --run_small                     <str>  运行小肽注释                                                           [${params.run_small}]

    --isoform_soft                  <str>  choose from [stringtie, scallop2]                                     [${params.isoform_soft}]
    --orf_soft                      <str>  choose from [TransDecoder, orfipy]                                    [${params.orf_soft}]
    ###NGS
    --NGS_data                      <str>  input NGS fastq dir
    --split_trans                   <str>  if split run transcript predict, use y or n                           [${params.split_trans}]
    --fastp_cpu                     <int>  fastp use threads number                                              [${params.fastp_cpu}]
    --fastqc_cpu                    <int>  fastqc use threads number                                             [${params.fastqc_cpu}]
    --hisat2_build_cpu              <int>  hisat2_build use threads number                                       [${params.hisat2_build_cpu}]
    --hisat2_cpu                    <int>  hisat2 use threads number                                             [${params.hisat2_cpu}]
    --NGS_samtools_cpu              <int>  NGS samtools use threads number                                       [${params.NGS_samtools_cpu}]
    --NGS_stringtie_cpu             <int>  NGS stringtie use threads number                                      [${params.NGS_stringtie_cpu}]
    --hisat2_mem                    <int>  hisat2 use memory                                                     [${params.hisat2_mem}]
    --merge_NGS_bam_mem             <int>  NGS samtools merge bam use memory                                     [${params.merge_NGS_bam_mem}]
    --Single_Trans_mem              <int>  Single_Trans use memory                                               [${params.Single_Trans_mem}]
    --NGS_stringtie_merge_mem       <int>  NGS_stringtie_merge use memory                                        [${params.NGS_stringtie_merge_mem}]
    ###ONT
    --ONT_data                      <str>  input ONT fastq dir/fastq gz dir
    --fl_filter_length              <int>  Filter on a minimum read length (NanoFilt)                            [${params.fl_filter_length}]
    --fl_filter_quality             <int>  Filter on a minimum average read quality score (NanoFilt)             [${params.fl_filter_quality}]
    --pychopper_cpu                 <int>  pychopper use threads number                                          [${params.pychopper_cpu}]
    --ONT_minimap2_cpu              <int>  ONT minimap2 use threads number                                       [${params.ONT_minimap2_cpu}]
    --ONT_samtools_cpu              <int>  ONT samtools use threads number                                       [${params.ONT_samtools_cpu}]
    --ONT_stringtie_cpu             <int>  ONT stringtie use threads number                                      [${params.ONT_stringtie_cpu}]
    --NanoFilt_mem                  <int>  NanoFilt use memory                                                   [${params.NanoFilt_mem}]
    --pychopper_mem                 <int>  pychopper use memory                                                  [${params.pychopper_mem}]
    --ONT_minimap2_mem              <int>  ONT minimap2 use memory                                               [${params.ONT_minimap2_mem}]
    --merge_ONT_bam_mem             <int>  ONT samtools merge bam use memory                                     [${params.merge_ONT_bam_mem}]
    ###PB
    --PB_data                       <str>  input PB bam dir/fasta file
    --PB_type                       <str>  choose form subreads, ccs, cluster (cluster input fasta file)         [${params.PB_type}]
    --primer                        <str>  Primers used for sequencing                                           [${params.primer}]
    --skip_lima                     <str>  skip lima,choose [y,n]                                                [${params.skip_lima}]
    --ccs_cpu                       <int>  ccs use threads number                                                [${params.ccs_cpu}]
    --pbmm2_cpu                     <int>  pbmm2 use threads number                                              [${params.pbmm2_cpu}]
    --PB_minimap2_cpu               <int>  PB minimap2 use threads number                                        [${params.PB_minimap2_cpu}]
    --PB_samtools_cpu               <int>  PB samtools use threads number                                        [${params.PB_samtools_cpu}]
    --collapse_cpu                  <int>  isoseq3/cDNA_Cupcake use threads number                               [${params.collapse_cpu}]
    --pbmm2_mem                     <int>  pbmm2 use memory                                                      [${params.pbmm2_mem}]
    --PB_minimap2_mem               <int>  PB minimap2 use memory                                                [${params.PB_minimap2_mem}]
    --collapse_mem                  <int>  isoseq3/cDNA_Cupcake use memory                                       [${params.collapse_mem}]

    --Fastp_mem                     <int>  Fastp_mem use memory                                                  [${params.Fastp_mem}]
    --Fastqc_mem                    <int>  Fastqc_mem use memory                                                 [${params.Fastqc_mem}]
    --NGS_stringtie_mem             <int>  NGS_stringtie_mem use memory                                          [${params.NGS_stringtie_mem}]
    --MinimapIndex_mem              <int>  MinimapIndex_mem use memory                                           [${params.MinimapIndex_mem}]
    --ONT_stringtie_mem             <int>  ONT_stringtie_mem use memory                                          [${params.ONT_stringtie_mem}]
    --PBccs_mem                     <int>  PBccs_mem use memory                                                  [${params.PBccs_mem}]
    --PBlima_mem                    <int>  PBlima_mem use memory                                                 [${params.PBlima_mem}]
    --PBrefine_mem                  <int>  PBrefine_mem use memory                                               [${params.PBrefine_mem}]
    --PBcluster_mem                 <int>  PBcluster_mem use memory                                              [${params.PBcluster_mem}]
    --cDNA_CupcakeCollapse_mem      <int>  cDNA_CupcakeCollapse_mem use memory                                   [${params.cDNA_CupcakeCollapse_mem}]
    --TransDcoder_mem               <int>  TransDcoder_mem use memory                                            [${params.TransDcoder_mem}]
    
    --AllQC_mem                     <int>  AllQC_mem use memory                                                  [${params.AllQC_mem}]
    --MapStat_mem                   <int>  MapStat_mem use memory                                                [${params.MapStat_mem}]
    --AllMapStat_mem                <int>  AllMapStat_mem use memory                                             [${params.AllMapStat_mem}]
    --Get_fq_ont_mem                <int>  Get_fq_ont_mem use memory                                             [${params.Get_fq_ont_mem}]
    --Fq2Fa_mem                     <int>  Fq2Fa_mem use memory                                                  [${params.Fq2Fa_mem}]
    --MergeNGS_mem                  <int>  MergeNGS_mem use memory                                               [${params.MergeNGS_mem}]
    --MergeONT_mem                  <int>  MergeONT_mem use memory                                               [${params.MergeONT_mem}]
    --MergePB_mem                   <int>  MergePB_mem use memory                                                [${params.MergePB_mem}]
    --MergeNGSONT_mem               <int>  MergeNGSONT_mem use memory                                            [${params.MergeNGSONT_mem}]
    --MergeNGSPB_mem                <int>  MergeNGSPB_mem use memory                                             [${params.MergeNGSPB_mem}]
###输出
    --nf_out                        <str>  Result output dir                                                     [${params.nf_out}]
    --nf_tmp                        <str>  Temp output dir                                                       [${params.nf_tmp}]
"""
exit 0
}

//script_bin = new File(workflow.projectDir.toString(),"bin")
// ################# genome fasta deal ###############################
if (params.format_genome == "y"){
Channel
    .fromPath(params.genome)
    .ifEmpty {ERROR:"target genome for anno missed,check path"}
    .set{fastaFile}

process transcode{
    tag "transcode"
    publishDir "${params.nf_tmp}/00.genome",mode: 'link'
    input:
        path gen from fastaFile

    output:
        path "${gen}.unix.60.fa" into genome_use
    script:
        """
        python3 /soft_env/00.genome/bin/gzORnot.py ${gen} ${gen}.qiongha
        ${params.dos2unix} -n ${gen}.qiongha ${gen}.unix
        sed -i "s/|/_/g" ${gen}.unix
        python3 /soft_env/00.genome/bin/fasta_deal.py -i ${gen}.unix -o ${gen}.unix.unix
        seqkit seq -w 60 ${gen}.unix.unix > ${gen}.unix.60.fa
        """
}
} else {
Channel
    .fromPath(params.genome)
    .ifEmpty {ERROR:"target genome for anno missed,check path"}
    .set{genome_use} 
}
genome_use.collect().set{target_genome}

// ################# NGS part ###############################
if (params.data_set == "NGS" || params.data_set == "NGS_ONT" || params.data_set == "NGS_PB"){
Channel
    .fromFilePairs( "${params.NGS_data}/*{R,r,_,.}{1,2}*{fq,fastq}{.gz,}", size: 2 )
    .ifEmpty { exit 1, "Cannot find any reads matching: ${params.NGS_data}."}
    .set {raw_reads}

process Fastp{
    //tag "${name}"
    publishDir "${params.nf_tmp}/03.Transcript/NGS/cleanData/fastp/${name}",mode: 'link'
    input:
        set val(name),path(fq) from raw_reads

    output:
        path "${name}.json" into FastpQC_AllFastpQC
        path "${name}.html"
        set val(name),path("${fq[0]}_R1.clean.fq.gz"),path("${fq[1]}_R2.clean.fq.gz") into clean_fq,fastqc_fq
    script:
        """
        fastp -L -i ${fq[0]} -I ${fq[1]} -w ${params.fastp_cpu} -o ${fq[0]}_R1.clean.fq.gz -O ${fq[1]}_R2.clean.fq.gz -j ${name}.json -h ${name}.html
        """
}

process Fastqc{
    //tag "${name}"
    publishDir "${params.nf_tmp}/03.Transcript/NGS/cleanData/fastqc/${name}",mode: 'link'
    input:
        set val(name),path(fq1),path(fq2) from fastqc_fq

    output:
        path "*/*/per_base_quality.png"
        path "*/*/per_base_sequence_content.png"
        path "*/*/per_sequence_gc_content.png"
        path "*_fastqc.html"
    script:
        """
        export LANG=en_US.UTF-8 && fastqc -t ${params.fastqc_cpu} -o ./ --extract ${fq1} ${fq2}
        """
}

process AllQC{
    tag "AllQC"
    publishDir "${params.nf_tmp}/03.Transcript/NGS/cleanData",mode: 'link'
    input:
        path all_stat from FastpQC_AllFastpQC.collect()

    output:
        path "all_NGS_stats.xls"
    script:
        """
        export LANG=en_US.UTF-8 && python3 /soft_env/03.transcript/bin/fastp_stats.py
        """
}

process hisat2_align{
    //tag "${name}"
    publishDir "${params.nf_tmp}/03.Transcript/NGS/mapping/${name}", mode: 'link'
    input:
        path genome from target_genome
        set val(name),path(fq1),path(fq2) from clean_fq

    output:
        path "*.sorted.bam" into NGS_merge_bams
        set val(name),path("*.sorted.bam") into NGS_MapStat,single_trans_bam
    script:
        """
        hisat2-build -p ${params.hisat2_build_cpu} ${genome} ${genome}
        hisat2 --dta -p ${params.hisat2_cpu} -x ${genome} -1 ${fq1} -2 ${fq2} | samtools sort -O BAM -@ ${params.NGS_samtools_cpu} -o ${name}.sorted.bam
        samtools index -c ${name}.sorted.bam
        """
}

process MapStat{
    //tag "${name}"
    input:
        set val(name),path(bam) from NGS_MapStat

    output:
        path "*.stat" into MapStat_AllMapStat
    script:
        """
        samtools flagstat ${bam} > ${name}.map.stat
        """
}

process AllMapStat{
    tag "AllMapStat"
    publishDir "${params.nf_tmp}/03.Transcript/NGS/mapping", mode: 'link'
    input:
        path all_s from MapStat_AllMapStat.collect()

    output:
        path "align_stats.xls"
    script:
        """
        export LANG=en_US.UTF-8 && python3 /soft_env/03.transcript/bin/samtools_stat_mapping.py
        """
}

if (params.split_trans == "n" || params.data_set != "NGS"){
process merge_NGS_bam{
    tag "merge_NGS_bam"
    input:
        path bam_li from NGS_merge_bams.toList()

    output:
        path "NGS_merged_sorted.bam" into ngs_merge_bam,NGS_ONT_NGS_bam,NGS_PB_NGS_bam
    script:
        bam_li_new = bam_li.join(' ')
        """
        samtools merge -o NGS_merged_sorted.bam ${bam_li_new}
        """
}

process NGS_stringtie{
    tag "NGS_stringtie"
    publishDir "${params.nf_tmp}/03.Transcript/NGS/gtf", mode: 'link'
    input:
        path bam from ngs_merge_bam

    output:
        path "NGS_transcripts.gtf" into NGS_trans_gtf
    script:
        if (params.isoform_soft == "scallop2"){
            """
            ${params.scallop2} -i ${bam} -o NGS_transcripts.gtf --min_mapping_quality 10
            """
        } else {
            """
            stringtie ${bam} -p ${params.NGS_stringtie_cpu} -l NGS -o NGS_transcripts.gtf.tmp
            python3 /soft_env/03.transcript/bin/re_fuck.py NGS_transcripts.gtf.tmp NGS_transcripts.gtf.tmp.tmp
            python3 /soft_env/03.transcript/bin/sort_gtf_pos.py NGS_transcripts.gtf.tmp.tmp NGS_transcripts.gtf
            """
        }
}
} else {
process Single_Trans{
    input:
        set val(name),path(bam) from single_trans_bam

    output:
        path "*.NGS_transcripts.gtf" into stringtie_merge_trans
    script:
        if (params.isoform_soft == "scallop2"){
            """
            ${params.scallop2} -i ${bam} -o ${name}.NGS_transcripts.gtf --min_mapping_quality 10
            """
        } else {
            """
            stringtie ${bam} -p ${params.NGS_stringtie_cpu} -l NGS -o NGS_transcripts.gtf.tmp
            python3 /soft_env/03.transcript/bin/re_fuck.py NGS_transcripts.gtf.tmp NGS_transcripts.gtf.tmp.tmp
            python3 /soft_env/03.transcript/bin/sort_gtf_pos.py NGS_transcripts.gtf.tmp.tmp ${name}.NGS_transcripts.gtf
            """
        }
}

process NGS_stringtie_merge{
    tag "NGS_stringtie_merge"
    publishDir "${params.nf_tmp}/03.Transcript/NGS/gtf", mode: 'link'
    input:
        path gtf from stringtie_merge_trans.collect()

    output:
        path "NGS_transcripts.gtf" into NGS_trans_gtf
    script:
        """
        ls *.gtf | xargs -i echo "{}" | tr ' ' '\\t' > gtf.list
        stringtie --merge gtf.list -o NGS_transcripts.gtf -c 3 -F 2 -T 2 -l NGS
        """
}
}
}

// ################# ONT part ###############################
if (params.data_set == "ONT" || params.data_set == "NGS_ONT"){
Channel
    .fromFilePairs( "${params.ONT_data}/*{fq, fastq}{.gz, .tar.gz,}", size: 1 )
    .ifEmpty { exit 1, "Cannot find any reads matching: ${params.ONT_data}."}
    .set {pass_fq}

process Get_fq_ont{
    //tag "${name}"
    input:
        set val(name),path(fq) from pass_fq

    output:
        set val(name),path("*.raw_no_filter.fq") into Get_fq_ont_NanoFilt
    script:
        """
        python3 /soft_env/03.transcript/bin/get_ont_fq.py ${fq} ${name}
        """
}

process Nano_Filt_1_Filter{
    //tag "${name}"
    publishDir "${params.nf_tmp}/03.Transcript/ONT/cleanData",mode: 'link'
    input:
        set val(name),path(fq) from Get_fq_ont_NanoFilt

    output:
        set val(name),path("*.filtered.fq") into NanoFiltFilter_CdnaClassifier
    script:
        """
        NanoFilt -l ${params.fl_filter_length} -q ${params.fl_filter_quality} ${fq} > ${name}.filtered.fq
        """
}

//鉴定全长转录本&进行过滤&fq转fa(ONT)
process CdnaClassifier{
    //tag "${name}"
    input:
        set val(name),path(fq) from NanoFiltFilter_CdnaClassifier

    output:
        set val(name),path("*.full_length.fq") into CdnaClassifier_ClassifierNanoFiltFilter
    script:
        """
        pychopper -S ${name}.stats.xls -r ${name}.report.pdf -w ${name}.rescued.fq -u ${name}.unclassified.fq -A ${name}.bed -t ${params.pychopper_cpu} ${fq} ${name}.full_length.fq
        """
}

process Nano_Filt_2_Filter{
    //tag "${name}"
    publishDir "${params.nf_tmp}/03.Transcript/ONT/Classifier",mode: 'link'
    input:
        set val(name),path(fq) from CdnaClassifier_ClassifierNanoFiltFilter

    output:
        set val(name),path("*.full_length_filtered.fq") into ClassifierNanoFiltFilter_Fq2Fa
    script:
        """
        NanoFilt -l ${params.fl_filter_length} -q ${params.fl_filter_quality} ${fq} > ${name}.full_length_filtered.fq
        """
}

process Fq2Fa{
    //tag "${name}"
    input:
        set val(name),path(fq) from ClassifierNanoFiltFilter_Fq2Fa

    output:
        set val(name),path("*.full_length_filtered.fa") into Fq2Fa_Minimap
    script:
        """
        seqkit fq2fa ${fq} > ${name}.full_length_filtered.fa
        """
}

//创建minimap2索引
process MinimapIndex{
    tag "MinimapIndex"
    input:
        path genome from target_genome

    output:
        path 'genome_index.mmi' into geno_index
    script:
        """
        minimap2 -t ${params.ONT_minimap2_cpu} -k14 -I 1000G -d genome_index.mmi ${genome}
        """
}
geno_index.collect().set{target_geno_index}

//全长序列与参考基因组minimap2比对
process MinimapClassifier{
    //tag "${name}"
    publishDir "${params.nf_tmp}/03.Transcript/ONT/mapping", mode: 'link'
    input:
        path index from target_geno_index
        set val(name),path(fa) from Fq2Fa_Minimap

    output:
        path "${name}.ref.aligned.bam" into MinimapClassifier_merge_ONT_bam
    script:
        """
        minimap2 -t ${params.ONT_minimap2_cpu} -ax splice -uf --secondary=no ${index} ${fa} | samtools sort -O BAM -@ ${params.ONT_samtools_cpu} -o ${name}.ref.aligned.bam
        samtools index -c ${name}.ref.aligned.bam
        """
}

process merge_ONT_bam{
    tag "merge_ONT_bam"
    input:
        path bam_li from MinimapClassifier_merge_ONT_bam.toList()

    output:
        file "ONT_merged_sorted.bam" into merge_ONT_bam_ONT_stringtie,NGS_ONT_ONT_bam
    script:
        bam_li_new = bam_li.join(' ')
        """
        samtools merge -o ONT_merged_sorted.bam ${bam_li_new}
        """
}

process ONT_stringtie{
    tag "ONT_stringtie"
    publishDir "${params.nf_tmp}/03.Transcript/ONT/gtf", mode: 'link'
    input:
        file bam from merge_ONT_bam_ONT_stringtie

    output:
        file "ONT_transcripts.gtf" into ONT_trans_gtf
    script:
        """
        stringtie -p ${params.ONT_stringtie_cpu} -l ONT -R -L -o ONT_transcripts.gtf.tmp ${bam}
        python3 /soft_env/03.transcript/bin/re_fuck.py ONT_transcripts.gtf.tmp ONT_transcripts.gtf.tmp.tmp
        python3 /soft_env/03.transcript/bin/sort_gtf_pos.py ONT_transcripts.gtf.tmp.tmp ONT_transcripts.gtf
        """
}
}

// ################# PB part ###############################
if (params.data_set == "PB" || params.data_set == "NGS_PB"){
if (params.PB_type == "subreads" && params.PB_type == "ccs" && params.PB_type != "cluster"){
    log.info "Please input subreads || ccs || cluster for --PB_type"
    exit 1
}
if (params.PB_type != "cluster"){
if (params.PB_type == "subreads"){
Channel
    .fromFilePairs( "${params.PB_data}/*.bam", size: 1 )
    .ifEmpty { exit 1, "Cannot find any reads matching: ${params.PB_data}."}
    .set {raw_iso_reads}

process PBccs{
    //tag "${name}"
    publishDir "${params.nf_tmp}/03.Transcript/PB/ccs", mode: 'link'
    input:
       set val(name),path(bam) from raw_iso_reads

    output:
        set val(name),path("ccs.bam") into PBccs_PBlima
    script:
        """
        ccs ${bam} ccs.bam -j ${params.ccs_cpu} --min-rq 0.9
        """
}
} else if (params.PB_type == "ccs"){
Channel
    .fromFilePairs( "${params.PB_data}/*.bam", size: 1 )
    .ifEmpty { exit 1, "Cannot find any reads matching: ${params.PB_data}."}
    .set {PBccs_PBlima}
}

process PBlima{
    tag "${name}"
    input:
        set val(name),path(bam) from PBccs_PBlima

    output:
        //set val(name),path("*.fl*.bam") into PBlima_PBrefine
        path "*.fl*.bam" into PBlima_PBrefine
    script:
        if (params.skip_lima == "n"){
            """
            lima ${bam} ${params.primer} ${name}.fl.bam --isoseq --peek-guess
            """
        } else {
            """
            ln -s ${bam} ${name}.fl_lima.bam
            """
        }
}

process PBrefine{
    tag "${name}"
    input:
        path bam from PBlima_PBrefine.collect()
        //set val(name),path(bam) from PBlima_PBrefine

    output:
        //path "${name}.flncl.bam" into PBrefine_PBcluster
        path "flncl.bam" into PBrefine_PBcluster
    script:
        """
        ls *.bam > all.fofn
        isoseq refine all.fofn ${params.primer} flncl.bam --require-polya
        #isoseq3 refine all.fofn ${params.primer} flncl.bam --require-polya
        """
}

process PBcluster{
    tag "PBcluster"
    publishDir "${params.nf_tmp}/03.Transcript/PB/cluster", mode: 'link'
    input:
        path bam from PBrefine_PBcluster
        //path bam from PBrefine_PBcluster.collect()

    output:
        path "clustered.hq.fasta.gz" into clustered_hq_fq,cluster_map_fa
        path "clustered.lq.fasta.gz"
        path "clustered.bam" into clustered_bam
    script:
        """
        #ls *.bam > flnc.fofn
        #isoseq cluster2 flnc.fofn clustered.bam -j 20
        #isoseq cluster2 ${bam} clustered.bam -j 20
        isoseq cluster ${bam} clustered.bam --use-qvs --verbose
        #isoseq3 cluster ${bam} clustered.bam --use-qvs --verbose
        """
}
} else {
Channel
    .fromPath(params.PB_data)
    .ifEmpty { exit 1, "Cannot find any reads matching: ${params.PB_data}."}
    .set {clustered_hq_fq}

Channel
    .fromPath(params.PB_data)
    .ifEmpty { exit 1, "Cannot find any reads matching: ${params.PB_data}."}
    .set {cluster_map_fa}
}

process MinimapCluster{
    tag "MinimapCluster"
    publishDir "${params.nf_tmp}/03.Transcript/PB/mapping/Minimap2", mode: 'link'
    input:
        path fa from clustered_hq_fq
        path genome from target_genome

    output:
        path "minimap2_sorted.bam" into MinimapCollapsed_bam,NGS_PB_PB_bam
    script:
        """
        minimap2 -t ${params.PB_minimap2_cpu} -ax splice -uf --secondary=no -C5 -O6,24 -B4 ${genome} ${fa} | samtools sort -O BAM -@ ${params.PB_samtools_cpu} -o minimap2_sorted.bam
        """
}

if (params.PB_type != "cluster"){
process Pbmm2Cluster{
    tag "Pbmm2Cluster"
    publishDir "${params.nf_tmp}/03.Transcript/PB/mapping/Pbmm2", mode: 'link'
    input:
        path bam from clustered_bam
        path genome from target_genome

    output:
        path "pbmm2_sorted.bam" into PbmmCollapsed_bam
    script:
        """
        pbmm2 align -j ${params.pbmm2_cpu} --preset ISOSEQ --sort ${bam} ${genome} pbmm2_sorted.bam
        """
}

process PBCollapse{
    tag "PBCollapse"
    publishDir "${params.nf_tmp}/03.Transcript/PB/gtf", mode: 'link'
    input:
        path bam from PbmmCollapsed_bam

    output:
        path "PB_transcripts.gtf" into PB_trans_gtf
    script:
        """
        isoseq collapse --do-not-collapse-extra-5exons ${bam} Clustered.collapsed.gff -j ${params.collapse_cpu}
        cp Clustered.collapsed.gff PB_transcripts.gtf
        """
}
} else {
process cDNA_CupcakeCollapse{
    tag "cDNA_CupcakeCollapse"
    publishDir "${params.nf_tmp}/03.Transcript/PB/gtf", mode: 'link'
    input:
        path bam from MinimapCollapsed_bam
        path fa from cluster_map_fa

    output:
        path "PB_transcripts.gtf" into PB_trans_gtf
    script:
        """
        python3 /soft_env/03.transcript/bin/get_cluster_fa.py ${fa} PB_clustered.fa
        collapse_isoforms_by_sam.py --input PB_clustered.fa -b ${bam} --dun-merge-5-shorter --cpus ${params.collapse_cpu} -o Clustered
        python3 /soft_env/03.transcript/bin/sort_gtf_pos.py Clustered.collapsed.gff PB_transcripts.gtf
        """
}
}
}

// ################# merge get trans part ###############################
if (params.data_set == "NGS"){
process MergeNGS{
    tag "MergeNGS"
    publishDir "${params.nf_tmp}/03.Transcript/gtf/NGS",mode:'copy',overwrite:true
    input:
        path ngs_gtf from NGS_trans_gtf

    output:
        path "transcript.gtf" into final_predict_orf
    script:
        """
        ln -s \$PWD/${ngs_gtf} transcript.gtf
        """
}
}

if (params.data_set == "ONT"){
process MergeONT{
    tag "MergeONT"
    publishDir "${params.nf_tmp}/03.Transcript/gtf/ONT",mode:'copy',overwrite:true
    input:
        path ont_gtf from ONT_trans_gtf

    output:
        path "transcript.gtf" into final_predict_orf
    script:
        """
        ln -s \$PWD/${ont_gtf} transcript.gtf
        """
}
}

if (params.data_set == "PB"){
process MergePB{
    tag "MergePB"
    publishDir "${params.nf_tmp}/03.Transcript/gtf/PB",mode:'copy',overwrite:true
    input:
        path pb_gtf from PB_trans_gtf

    output:
        path "transcript.gtf" into final_predict_orf
    script:
        """
        ln -s \$PWD/${pb_gtf} transcript.gtf
        """
}
}

if (params.data_set == "NGS_ONT"){
process MergeNGSONT{
    tag "MergeNGSONT"
    publishDir "${params.nf_tmp}/03.Transcript/gtf/NGS_ONT",mode:'copy',overwrite:true
    input:
        path ngs_bam from NGS_ONT_NGS_bam
        path ont_bam from NGS_ONT_ONT_bam
    output:
        path "transcript.gtf" into final_predict_orf
    script:
        """
        stringtie --mix -l NGS_ONT -p ${params.ONT_stringtie_cpu} -o transcript.gtf ${ngs_bam} ${ont_bam}
        """
}

//process MergeNGSONT{
//    tag "MergeNGSONT"
//    publishDir "${params.nf_tmp}/03.Transcript/gtf/NGS_ONT",mode:'copy',overwrite:true
//    input:
//        path ngs_gtf from NGS_trans_gtf
//        path ont_gtf from ONT_trans_gtf
//    output:
//        path "transcript.gtf" into final_predict_orf
//        path "*_gene_report.txt"
//        path "*_trans_report.txt"
//        path "*_merge.txt"
//    script:
//        """
//        #NGS
//        gtfToGenePred ${ngs_gtf} NGS_transcripts.genePred
//        genePredToBed NGS_transcripts.genePred NGS_transcripts.bed
//        python3 /soft_env/03.transcript/bin/get_add_gene_id_bed.py ${ngs_gtf} NGS_transcripts.bed NGS_transcripts.WithGene.bed
//        #ONT
//        gtfToGenePred ${ont_gtf} ONT_transcripts.genePred
//        genePredToBed ONT_transcripts.genePred ONT_transcripts.bed
//        python3 /soft_env/03.transcript/bin/get_add_gene_id_bed.py ${ont_gtf} ONT_transcripts.bed ONT_transcripts.WithGene.bed
//        #Merge
//        echo -e "NGS_transcripts.WithGene.bed\\tno_cap\\t2,1,2\\tNGS" > filelist.txt
//        echo -e "ONT_transcripts.WithGene.bed\\tno_cap\\t1,2,1\\tONT" >> filelist.txt
//        python3 /soft_env/03.transcript/bin/tama_merge.py -f filelist.txt -p merge -d merge_dup
//        bedToGenePred merge.bed merge.GenePred
//        genePredToGtf file merge.GenePred merge.gtf
//        python3 /soft_env/03.transcript/bin/get_final_gtf.py merge.gtf transcript.gtf
//        """
//}
}

if (params.data_set == "NGS_PB"){
process MergeNGSPB{
    tag "MergeNGSPB"
    publishDir "${params.nf_tmp}/03.Transcript/gtf/NGS_PB",mode:'copy',overwrite:true
    input:
        path ngs_bam from NGS_PB_NGS_bam
        path pb_bam from NGS_PB_PB_bam
    output:
        path "transcript.gtf" into final_predict_orf
    script:
        """
        stringtie --mix -l NGS_PB -p ${params.ONT_stringtie_cpu} -o transcript.gtf ${ngs_bam} ${pb_bam}
        """
}

//process MergeNGSPB{
//    tag "MergeNGSPB"
//    publishDir "${params.nf_tmp}/03.Transcript/gtf/NGS_PB",mode:'copy',overwrite:true
//    input:
//        path ngs_gtf from NGS_trans_gtf
//        path pb_gtf from PB_trans_gtf
//    output:
//        path "transcript.gtf" into final_predict_orf
//        path "*_gene_report.txt"
//        path "*_trans_report.txt"
//        path "*_merge.txt"
//    script:
//        """
//        #NGS
//        gtfToGenePred ${ngs_gtf} NGS_transcripts.genePred
//        genePredToBed NGS_transcripts.genePred NGS_transcripts.bed
//        python3 /soft_env/03.transcript/bin/get_add_gene_id_bed.py ${ngs_gtf} NGS_transcripts.bed NGS_transcripts.WithGene.bed
//        #PB
//        gtfToGenePred ${pb_gtf} PB_transcripts.genePred
//        genePredToBed PB_transcripts.genePred PB_transcripts.bed
//        python3 /soft_env/03.transcript/bin/get_add_gene_id_bed.py ${pb_gtf} PB_transcripts.bed PB_transcripts.WithGene.bed
//        #Merge
//        echo -e "NGS_transcripts.WithGene.bed\\tno_cap\\t2,1,2\\tNGS" > filelist.txt
//        echo -e "PB_transcripts.WithGene.bed\\tno_cap\\t1,2,1\\tPB" >> filelist.txt
//        python3 /soft_env/03.transcript/bin/tama_merge.py -f filelist.txt -p merge -d merge_dup
//        bedToGenePred merge.bed merge.GenePred
//        genePredToGtf file merge.GenePred merge.gtf
//        python3 /soft_env/03.transcript/bin/get_final_gtf.py merge.gtf transcript.gtf
//        """
//}
}

// ################# TransDcoder ###############################
process TransDcoder{
    tag "TransDcoder"
    publishDir "${params.nf_tmp}/03.Transcript/gff", mode: 'link'
    input:
        path gtf from final_predict_orf
        path genome from target_genome

    output:
        path "transcript.gff" into transcripts_gff
        path "amino_acids_5_75/"
    script:
    if (params.run_small == "y"){
        if (params.data_set == "NGS" || params.data_set == "NGS_ONT" || params.data_set == "NGS_PB"){
            """
            /software/TransDecoder-TransDecoder-v5.7.0/util/gtf_genome_to_cdna_fasta.pl ${gtf} ${genome} > all.exon.fa 
            /software/TransDecoder-TransDecoder-v5.7.0/util/gtf_to_alignment_gff3.pl ${gtf} > transcripts_for_genome.gff3
            /software/TransDecoder-TransDecoder-v5.7.0/TransDecoder.LongOrfs -t all.exon.fa -m 4 #--complete_orfs_only
            /software/TransDecoder-TransDecoder-v5.7.0/TransDecoder.Predict -t all.exon.fa --retain_long_orfs_length 12
            /software/TransDecoder-TransDecoder-v5.7.0/util/cdna_alignment_orf_to_genome_orf.pl all.exon.fa.transdecoder.gff3 transcripts_for_genome.gff3 all.exon.fa > transcript.gff.tmp
            python3 /soft_env/03.transcript/bin/reformat_gff.py transcript.gff.tmp transcript.gff

            cp transcript.gff trans.orf1_transcript.gff
            perl /soft_env/09.integrate/bin/bin/gff2cds.pl ${genome} trans.orf1_transcript.gff trans.orf1_transcript.gff.cds --consider_phase
            perl /soft_env/09.integrate/bin/bin/cds2pep.pl trans.orf1_transcript.gff.cds --Nrate 0.0000000000000001 --min_pep_len 2 --warn_pep 2> trans.orf1_transcript.gff.cds.err
            perl /soft_env/09.integrate/bin/bin/filter_gff.pl trans.orf1_transcript.gff --filter trans.orf1_transcript.gff.cds.err > trans.orf1_transcript.gff.filter
            mkdir -p amino_acids_5_75/all_isoform
            /data/user/fanpengyu/00.software/gffread trans.orf1_transcript.gff.filter -g ${genome} -x all_isoform.cds.fa -y all_isoform.pep.fa
            python3 /soft_env/03.transcript/bin/get_short_tran.py 228 18 all_isoform.cds.fa amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.cds.fa
            python3 /soft_env/03.transcript/bin/get_short_tran.py 75 5 all_isoform.pep.fa amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.pep.fa
            python3 /soft_env/03.transcript/bin/filter_seq.py amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.pep.fa amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.filter.pep.fa amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.cds.fa amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.filter.cds.fa
            python3 /soft_env/03.transcript/bin/get_short_gff.py amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.filter.cds.fa trans.orf1_transcript.gff.filter amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.gff
            seqkit stat amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.filter.cds.fa > amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.cds.stat.xls
            seqkit stat amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.filter.pep.fa > amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.pep.stat.xls

            #perl /soft_env/09.integrate/bin/bin/compare_gffs.pl trans.orf1_transcript.gff --filter_lst trans.orf1_transcript.gff.cds.err --longest_out trans.orf1_transcript.gff.longest
            #perl /soft_env/09.integrate/bin/bin/compare_gffs.pl trans.orf1_transcript.gff.longest --longest_out trans.orf.All.longest.gff
            #mkdir -p amino_acids_5_75/longest_isoform
            #/data/user/fanpengyu/00.software/gffread trans.orf.All.longest.gff -g ${genome} -x amino_acids_5_75/longest_isoform/longest_isoform.cds.fa -y amino_acids_5_75/longest_isoform/longest_isoform.pep.fa
            #python3 /soft_env/03.transcript/bin/get_short_tran.py 228 18 amino_acids_5_75/longest_isoform/longest_isoform.cds.fa amino_acids_5_75/longest_isoform/longest_isoform.5_75_amino_acids.cds.fa
            #python3 /soft_env/03.transcript/bin/get_short_tran.py 75 5 amino_acids_5_75/longest_isoform/longest_isoform.pep.fa amino_acids_5_75/longest_isoform/longest_isoform.5_75_amino_acids.pep.fa
            #python3 /soft_env/03.transcript/bin/filter_seq.py amino_acids_5_75/longest_isoform/longest_isoform.5_75_amino_acids.pep.fa amino_acids_5_75/longest_isoform/longest_isoform.5_75_amino_acids.filter.pep.fa amino_acids_5_75/longest_isoform/longest_isoform.5_75_amino_acids.cds.fa amino_acids_5_75/longest_isoform/longest_isoform.5_75_amino_acids.filter.cds.fa
            #python3 /soft_env/03.transcript/bin/get_short_gff.py amino_acids_5_75/longest_isoform/longest_isoform.cds.fa trans.orf.All.longest.gff amino_acids_5_75/longest_isoform/longest_isoform.5_75_amino_acids.gff
            #seqkit stat amino_acids_5_75/longest_isoform/longest_isoform.5_75_amino_acids.cds.fa > amino_acids_5_75/longest_isoform/longest_isoform.5_75_amino_acids.cds.stat.xls
            #seqkit stat amino_acids_5_75/longest_isoform/longest_isoform.5_75_amino_acids.pep.fa > amino_acids_5_75/longest_isoform/longest_isoform.5_75_amino_acids.pep.stat.xls
            """
        } else {
            """
            /software/TransDecoder-TransDecoder-v5.7.0/util/gtf_genome_to_cdna_fasta.pl ${gtf} ${genome} > all.exon.fa 
            /software/TransDecoder-TransDecoder-v5.7.0/util/gtf_to_alignment_gff3.pl ${gtf} > transcripts_for_genome.gff3
            /software/TransDecoder-TransDecoder-v5.7.0/TransDecoder.LongOrfs -t all.exon.fa -m 4 -S #--complete_orfs_only 
            /software/TransDecoder-TransDecoder-v5.7.0/TransDecoder.Predict -t all.exon.fa --retain_long_orfs_length 12
            /software/TransDecoder-TransDecoder-v5.7.0/util/cdna_alignment_orf_to_genome_orf.pl all.exon.fa.transdecoder.gff3 transcripts_for_genome.gff3 all.exon.fa > transcript.gff.tmp
            python3 /soft_env/03.transcript/bin/reformat_gff.py transcript.gff.tmp transcript.gff

            cp transcript.gff trans.orf1_transcript.gff
            perl /soft_env/09.integrate/bin/bin/gff2cds.pl ${genome} trans.orf1_transcript.gff trans.orf1_transcript.gff.cds --consider_phase
            perl /soft_env/09.integrate/bin/bin/cds2pep.pl trans.orf1_transcript.gff.cds --Nrate 0.0000000000000001 --min_pep_len 2 --warn_pep 2> trans.orf1_transcript.gff.cds.err
            perl /soft_env/09.integrate/bin/bin/filter_gff.pl trans.orf1_transcript.gff --filter trans.orf1_transcript.gff.cds.err > trans.orf1_transcript.gff.filter
            mkdir -p amino_acids_5_75/all_isoform
            /data/user/fanpengyu/00.software/gffread trans.orf1_transcript.gff.filter -g ${genome} -x all_isoform.cds.fa -y all_isoform.pep.fa
            python3 /soft_env/03.transcript/bin/get_short_tran.py 228 18 all_isoform.cds.fa amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.cds.fa
            python3 /soft_env/03.transcript/bin/get_short_tran.py 75 5 all_isoform.pep.fa amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.pep.fa
            python3 /soft_env/03.transcript/bin/filter_seq.py amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.pep.fa amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.filter.pep.fa amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.cds.fa amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.filter.cds.fa
            python3 /soft_env/03.transcript/bin/get_short_gff.py amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.filter.cds.fa trans.orf1_transcript.gff.filter amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.gff
            seqkit stat amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.filter.cds.fa > amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.cds.stat.xls
            seqkit stat amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.filter.pep.fa > amino_acids_5_75/all_isoform/all_isoform.5_75_amino_acids.pep.stat.xls

            #perl /soft_env/09.integrate/bin/bin/compare_gffs.pl trans.orf1_transcript.gff --filter_lst trans.orf1_transcript.gff.cds.err --longest_out trans.orf1_transcript.gff.longest
            #perl /soft_env/09.integrate/bin/bin/compare_gffs.pl trans.orf1_transcript.gff.longest --longest_out trans.orf.All.longest.gff
            #mkdir -p amino_acids_5_75/longest_isoform
            #/data/user/fanpengyu/00.software/gffread trans.orf.All.longest.gff -g ${genome} -x amino_acids_5_75/longest_isoform/longest_isoform.cds.fa -y amino_acids_5_75/longest_isoform/longest_isoform.pep.fa
            #python3 /soft_env/03.transcript/bin/get_short_tran.py 228 18 amino_acids_5_75/longest_isoform/longest_isoform.cds.fa amino_acids_5_75/longest_isoform/longest_isoform.5_75_amino_acids.cds.fa
            #python3 /soft_env/03.transcript/bin/get_short_tran.py 75 5 amino_acids_5_75/longest_isoform/longest_isoform.pep.fa amino_acids_5_75/longest_isoform/longest_isoform.5_75_amino_acids.pep.fa
            #python3 /soft_env/03.transcript/bin/filter_seq.py amino_acids_5_75/longest_isoform/longest_isoform.5_75_amino_acids.pep.fa amino_acids_5_75/longest_isoform/longest_isoform.5_75_amino_acids.filter.pep.fa amino_acids_5_75/longest_isoform/longest_isoform.5_75_amino_acids.cds.fa amino_acids_5_75/longest_isoform/longest_isoform.5_75_amino_acids.filter.cds.fa
            #python3 /soft_env/03.transcript/bin/get_short_gff.py amino_acids_5_75/longest_isoform/longest_isoform.cds.fa trans.orf.All.longest.gff amino_acids_5_75/longest_isoform/longest_isoform.5_75_amino_acids.gff
            #seqkit stat amino_acids_5_75/longest_isoform/longest_isoform.5_75_amino_acids.cds.fa > amino_acids_5_75/longest_isoform/longest_isoform.5_75_amino_acids.cds.stat.xls
            #seqkit stat amino_acids_5_75/longest_isoform/longest_isoform.5_75_amino_acids.pep.fa > amino_acids_5_75/longest_isoform/longest_isoform.5_75_amino_acids.pep.stat.xls
            """
        }
    } else {
        if (params.orf_soft == "orfipy"){
            """
            /software/TransDecoder-TransDecoder-v5.7.0/util/gtf_genome_to_cdna_fasta.pl ${gtf} ${genome} > all.exon.fa
            /software/TransDecoder-TransDecoder-v5.7.0/util/gtf_to_alignment_gff3.pl ${gtf} > transcripts_for_genome.gff3
            ${params.orfipy} all.exon.fa --procs 32 --bed12 orfipy.bed12 --bed orfipy.bed --dna orfipy.cds --pep orfipy.pep --longest --outdir orfipy_out --start ATG --stop TAA,TAG,TGA
            python3 /soft_env/03.transcript/bin/get_use_and_to_gff.py orfipy_out/orfipy_longest.bed orfipy_out/orfipy.bed12
            /software/TransDecoder-TransDecoder-v5.7.0/util/cdna_alignment_orf_to_genome_orf.pl orfipy.gff3 transcripts_for_genome.gff3 all.exon.fa > transcript.gff.tmp
            python3 /soft_env/03.transcript/bin/reformat_gff.py transcript.gff.tmp transcript.gff
            mkdir -p amino_acids_5_75/
            """
        } else {
            if (params.data_set == "NGS" || params.data_set == "NGS_ONT" || params.data_set == "NGS_PB"){
                """
                /software/TransDecoder-TransDecoder-v5.7.0/util/gtf_genome_to_cdna_fasta.pl ${gtf} ${genome} > all.exon.fa 
                /software/TransDecoder-TransDecoder-v5.7.0/util/gtf_to_alignment_gff3.pl ${gtf} > transcripts_for_genome.gff3
                /software/TransDecoder-TransDecoder-v5.7.0/TransDecoder.LongOrfs -t all.exon.fa --complete_orfs_only
                /software/TransDecoder-TransDecoder-v5.7.0/TransDecoder.Predict -t all.exon.fa
                /software/TransDecoder-TransDecoder-v5.7.0/util/cdna_alignment_orf_to_genome_orf.pl all.exon.fa.transdecoder.gff3 transcripts_for_genome.gff3 all.exon.fa > transcript.gff.tmp
                python3 /soft_env/03.transcript/bin/reformat_gff.py transcript.gff.tmp transcript.gff
                mkdir -p amino_acids_5_75/
                """
            } else {
                """
                /software/TransDecoder-TransDecoder-v5.7.0/util/gtf_genome_to_cdna_fasta.pl ${gtf} ${genome} > all.exon.fa 
                /software/TransDecoder-TransDecoder-v5.7.0/util/gtf_to_alignment_gff3.pl ${gtf} > transcripts_for_genome.gff3
                /software/TransDecoder-TransDecoder-v5.7.0/TransDecoder.LongOrfs -t all.exon.fa -S --complete_orfs_only 
                /software/TransDecoder-TransDecoder-v5.7.0/TransDecoder.Predict -t all.exon.fa
                /software/TransDecoder-TransDecoder-v5.7.0/util/cdna_alignment_orf_to_genome_orf.pl all.exon.fa.transdecoder.gff3 transcripts_for_genome.gff3 all.exon.fa > transcript.gff.tmp
                python3 /soft_env/03.transcript/bin/reformat_gff.py transcript.gff.tmp transcript.gff
                mkdir -p amino_acids_5_75/
                """
            }
        }
    }
}


//perl /soft_env/09.integrate/bin/bin/get_position_seq.pl -p ${params.sample_name}.gene.gff -s ${genome} -o ${params.sample_name}.gene.fa
