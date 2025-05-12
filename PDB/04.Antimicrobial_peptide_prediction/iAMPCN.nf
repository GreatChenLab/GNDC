#!/usr/bin/nextflow
params.help=null

if (params.help){
    log.info ''
    log.info '-------------------------'
    log.info 'iAMPCN NF'
    log.info '-------------------------    '
    log.info ''
    log.info 'Author :zqshu'
    log.info 'Email  :shuziqiang@benagen.com'
    log.info 'Date   :2025.03.25'
    log.info 'Usage:'
    log.info '        nextflow run iAMPCN.nf -resume -with-trace [options] '
    log.info ''
    log.info '        --input_dir                INPUTDIR            inclued *.5_75_amino_acids.pep.fa...'
    log.info '        --pred_threshold           PRED_THRESHOLD      pred_threshold of iAMPCN [default:0.5]'
    log.info '        --output_dir               OUTPUTPATH          the output dir of result files inside [default:AMP_Results]'
    log.info '        --min_cpu                  MINCPU              min cpu/mem control [default:10]'
    log.info '        --mid_cpu                  MIDCPU              mid cpu/mem control [default:30]'
    log.info '        --high_cpu                 HIGCPU              max cpu/mem control [default:60]'
    log.info '        --queueq                   QUEUE               queue info for slurm [default:xhhctdnormal]'
    exit 1
}

pipe_dir                = new File(workflow.projectDir.toString(),'bin')
input_dir               = params.input_dir
pred_threshold          = params.pred_threshold
output_dir              = params.output_dir
min_cpu                 = params.min_cpu
mid_cpu                 = params.mid_cpu
high_cpu                = params.high_cpu
queueq                  = params.queueq

Channel
    .fromPath( "${params.input_dir}/*.pep.fa", type: 'file')
    .ifEmpty { error "Cannot find any folder matching: ${params.input_dir}" }
    .map { file -> tuple( file.name.split('\\.')[0], file ) }
    .set { input_path }

process filt_pep {
    tag { "sub_${sample_name}" }
    publishDir "${output_dir}", mode: 'copy', overwrite: true
    input:
        tuple val(sample_name), file(each_fa) from input_path

    output:
        tuple( val(sample_name), file("*/*.used.pep.fa") ) into used_pep

    script:
        """
        mkdir -p ${sample_name}
        python3 ${pipe_dir}/filt_pep.py ${each_fa} ${each_fa}.1
        python3 ${pipe_dir}/de_dup.py ${each_fa}.1 ${sample_name}/${sample_name}.used.pep.fa
        """
}

process split_pep {
    tag { "split_${sample_name}" }
    input:
        tuple val(sample_name), file(fa) from used_pep

    output:
        tuple( val(sample_name), file("*.split/*.part_*") ) into split_pep

    script:
        """
        seqkit split2 --by-size 8000 ${fa}
        """
}

split_pep_flat = split_pep
    .flatMap { species, file_paths ->
        def files = file_paths instanceof List ? file_paths : [file_paths]
        files.collect { file_path -> tuple(species, file_path) }
    }

process do_iAMPCN {
    tag { "AMP_${sample_name}" }
    input:
        tuple val(sample_name), file(split_fa) from split_pep_flat

    output:
        tuple( val(sample_name), file("*.csv") ) into each_csv

    script:
        """
        number=`ls ${split_fa} | awk -F "part_" '{print \$2}' | awk -F "." '{print \$1}'`
        python /work/home/shuziqiang/soft/iAMPCN/iAMPCN/predict.py -test_fasta_file \${PWD}/${split_fa} -output_file_name \${PWD}/${sample_name}_\${number} -pred_threshold ${pred_threshold}
        """
}

grouped_csv = each_csv.groupTuple()

process merge_csv {
    tag { "merge_${sample_name}" }
    publishDir "${output_dir}", mode: 'copy', overwrite: true
    input:
        tuple val(sample_name), file(csv_files) from grouped_csv

    output:
        tuple( val(sample_name), file("*/*.predicted.csv") ) into last_predicted

    script:
        """
        python3 ${pipe_dir}/Merge.py ${sample_name}.merged.csv
        mkdir -p ${sample_name}
        cp ${sample_name}.merged.csv ${sample_name}/${sample_name}.predicted.csv
        """
}

process stat_draw {
    tag { "${sample_name}" }
    publishDir "${output_dir}", mode: 'copy', overwrite: true
    input:
        tuple val(sample_name), file(csv) from last_predicted

    output:
        file "*/prediction_results.*"   

    script:
        """
        python3 ${pipe_dir}/cal_csv_stat.py ${csv}
        mkdir -p ${sample_name}
        cp prediction_results.xls ${sample_name}/
        cp prediction_results.png ${sample_name}/
        """
}
