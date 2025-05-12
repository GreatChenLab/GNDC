import argparse
import os
import logging
import subprocess as sbp
import multiprocessing as mp
import distutils.spawn
import json
import glob
#检查文件夹是否存在
def check_dir_exists(dirname):
    if os.path.isdir(dirname):
        return os.path.abspath(dirname)
    raise NotADirectoryError(f"{dirname} not a directory or not exists!") 

#当输出目录不存在的时候，新建输出目录 
def check_output_dir(dirname):
    if not os.path.exists(dirname):
        os.makedirs(dirname)
    return os.path.abspath(dirname)

def fastp_parser():
    argparser_fastp = argparse.ArgumentParser(description='reads quality control with fastp')
    argparser_fastp.add_argument("-i", "--input", type=check_dir_exists, default=".", 
                                 help="The directory where raw reads data is located")
    argparser_fastp.add_argument("-o", "--output", type=check_output_dir, default=".",
                                 help="The directory save quality control result")
    argparser_fastp.add_argument('-n', "--qc-name", default="qc_stat.xls",
                                 help="The quality control stat output file name")
    argparser_fastp.add_argument("-P", "--process", type=int, default=5,
                               help="The porcess number for deal with multiple samples")
    argparser_fastp.add_argument("-t", "--threads", type=int, default=5,
                                 help="The threads number for running fastp")
    argparser_fastp.add_argument("-s", "--single-end", action="store_true", 
                                 help="Single-end or Pair-end, default: Pair-end")
    argparser_fastp.add_argument("-S", "--Suffix-name", type=str, default="fq.gz",
                                 choices=("fq", "fq.gz", "fastq"),
                                 help="The suffix name of input file,\"fq\",\"fq.gz\",\"fastq\". default: fq.gz")
    return argparser_fastp
    
class Single_end():
    def __init__(self, dirname, suffix_name=None):
        self.dirname = dirname
        self.suffix_name = suffix_name 
    def __str__(self):
        return f"The path {self.dirname}"
    def __repr__(self):
        return self.__str__()
    def __iter__(self):
        if self.suffix_name:
            for file in os.listdir(self.dirname):
                if file.endswith(self.suffix_name):
                    yield os.path.join(self.dirname, file) 
        else:
            for file in os.listdir(self.dirname):
                yield os.path.join(self.dirname, file)       
    def __getitem__(self, key):
        return [file for file in self][key]
    def __len__(self):
        return len([file for file in self])

class Pair_end(Single_end):
    def __init__(self, dirname, suffix_name=None):
        super().__init__(dirname, suffix_name)        
    #判断是否是双端数据，目前使用的是命名差异
    def __iter__(self):
        file_list = {} 
        for file in os.listdir(self.dirname):
            if self.suffix_name:
                if file.endswith(self.suffix_name):
                    prefix_name = file.rsplit('_', 1)[0]
                    if prefix_name not in file_list:
                        file_list[prefix_name] = []
                    file_list[prefix_name].append(os.path.join(self.dirname, file)) 
            else:
                prefix_name = file.rsplit('_', 1)[0]
                if prefix_name not in file_list:
                    file_list[prefix_name] = []
                file_list[prefix_name].append(os.path.join(self.dirname, file))
        try:
            for _, (file1, file2) in file_list.items():
                if file1.count('1') < file2.count('1'):
                    file1, file2 = file2, file1
                yield file1, file2            
        except ValueError as e:
            raise ValueError("The pair end reads don't match")

def create_logger(name, filename, level=logging.DEBUG):
    logger = logging.getLogger(name)
    logger.setLevel(level) 
    ch1 = logging.FileHandler(filename + ".log", mode='w')
    ch2 = logging.StreamHandler()
    formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
    ch1.setFormatter(formatter)
    ch2.setFormatter(formatter)
    logger.addHandler(ch1)
    logger.addHandler(ch2)
    return logger


def fetch_json_special_tag(filename, tag):
    with open(filename) as f:
        data = json.load(f)[tag]
    return data

def parser_qc_json(filename):
    data = fetch_json_special_tag(filename, "summary")
    store_result = []
    for key in ('before_filtering', 'after_filtering'):
        item = data[key]
        store_result.extend([format(item[special_key], ',') for special_key in ("total_reads", "total_bases")])
        if key == "after_filtering":
            q20_rate, q30_rate, gc_content = map(lambda x: "{:.3f}%".format(x * 100), (item['q20_rate'], item['q30_rate'], item['gc_content']))
            store_result.extend([q20_rate, q30_rate, gc_content])
    return store_result
            
class Args_base():
    def __init__(self, Input, output, single_end, Suffix_name, process, threads):
        self.input = Input
        self.processes = process
        self.threads = threads
        self.single = single_end
        self.suffix = Suffix_name
        self.output = output
        
class Fastp(Args_base):
    def __init__(self, args):
        super().__init__(args.input, args.output, args.single_end, args.Suffix_name, args.process, args.threads)
        self.logger = create_logger("fastp", "qc")
        if self.single:
            self.read_files = Single_end(self.input, self.suffix)
        else:
            self.read_files = Pair_end(self.input, self.suffix)
    def cmd_single_end(self, file1):
        prefix_name = os.path.basename(file1).rsplit('_', 1)[0]
        print(prefix_name)
        try:
            sbp.run(f"fastp -i {file1} -o {prefix_name}.clean.fq.gz -w {self.threads} -h {prefix_name}.html -j {prefix_name}.json", shell=True, check=True, cwd=self.output)
            self.logger.info(f"{file1} has been processed!")
        except sbp.CalledProcessError as e:
            self.logger.error(f"the {e.cmd} running failed!")  
    def cmd_pair_end(self, file1, file2):
        prefix_name = os.path.basename(file1).rsplit('_', 1)[0]
        print(prefix_name)
        try:
            sbp.run(f"fastp -A -i {file1} -I {file2} -o {prefix_name}_R1.clean.fq.gz -O {prefix_name}_R2.clean.fq.gz -w {self.threads} -h {prefix_name}.html -j {prefix_name}.json", shell=True, check=True, cwd=self.output)
            self.logger.info(f"{file1} and {file2} has been processed!")
        except sbp.CompletedProcess as e:
            self.logger.error(f"the {e.cmd} running failed!")
    def run(self):
        with mp.Pool(self.processes) as P:
            if self.single:
                for file in self.read_files:
                    self.logger.info(f"{file} is processing now")
                    P.apply_async(self.cmd_single_end, args=(file,))
            else:
                for file1, file2 in self.read_files:
                    self.logger.info(f"{file1} and {file2} is processing now")
                    P.apply_async(self.cmd_pair_end, args=(file1, file2))
            P.close() 
            P.join() 

def check_software_exists(software):
    if isinstance(software, str):
        assert distutils.spawn.find_executable(software), f"{software} not exists in you environment"
    elif isinstance(software, list):
        for i in software:
            assert distutils.spawn.find_executable(i), f"{i} not exists in you evironment!"

def main():
#    parser = fastp_parser()
#    args = parser.parse_args() 
#    check_software_exists("fastp")
#    Fastp(args).run()
#    dirnames = args.input
#    with open(args.qc_name, 'w') as f:
#        f.write('\t'.join(['Sample', 'Raw reads', 'Raw bases', 'Clean reads', 'Clean bases', 'Q20_rate', 'Q30_rate']) + '\n')
#        for file in os.listdir(args.output):
#            if file.endswith('json'):
#                sample_name = file.rstrip('.json')
#                qc_result = parser_qc_json(os.path.join(args.output, file))
#                f.write('\t'.join([sample_name, *qc_result]) + '\n')
    with open('all_NGS_stats.xls', 'w') as f:
        f.write('\t'.join(['Sample', 'Raw reads', 'Raw bases', 'Clean reads', 'Clean bases', 'Q20_rate', 'Q30_rate', 'GC_content']) + '\n')
        file_list = glob.glob('./*.json')
        file_list.sort()
        for file in file_list:
            sample_name = file.rstrip('.json')
            qc_result = parser_qc_json(os.path.join('./', file))
            f.write('\t'.join([sample_name.split('/')[1], *qc_result]) + '\n')
if __name__ == "__main__":
    main() 
