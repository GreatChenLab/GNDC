#!/usr/bin/python3
import os,sys,glob,re

def make_dir(strdir):
    if not os.path.exists(strdir):
        os.makedirs(strdir)
    makedirpath = get_cwd_dir(strdir)
    return makedirpath

def get_cwd_dir(strdir):
    allpath = os.path.abspath(strdir)
    return allpath

for i in os.popen("ls -d *_amino_acids").readlines():
    this_dir = get_cwd_dir(i.strip())
    slurm_out_file = glob.glob("%s/slurm-*.out" % this_dir)[0]
    slurm_out_file_str = os.popen("cat %s" % slurm_out_file).read().strip()
    if "have unusual amino acids" in slurm_out_file_str:
        cmd = "cd %s && python ../filt_pep.py used.pep filt.used.pep" % (this_dir)
        os.system(cmd)
        cmd = "cd %s && rm -rf tmp_save" % (this_dir)
        os.system(cmd)
        with open("%s/Run.sh" % this_dir,"w") as f:
            f.write("#!/bin/bash\n")
            f.write("/work/home/shuziqiang/soft/iAMPCN/iAMPCN/iAMPCN -test_fasta_file %s/filt.used.pep -output_file_name %s/prediction_results\n" % (this_dir,this_dir))
        cmd = "cd %s && sbatch --job-name=iAMPCN --partition=xhhctdnormal --nodes=1 --cpus-per-task=38 --time=720:00:00 --chdir=%s Run.sh && sleep 2s" % (this_dir,this_dir)
        os.system(cmd)
    else:
        pass
