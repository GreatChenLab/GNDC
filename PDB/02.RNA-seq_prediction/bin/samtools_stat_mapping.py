#!/usr/bin/env python

"""python samtools_stat_mapping.py sample_info.txt aa.stat"""
import sys
import glob
import os
import operator as op
file_list = glob.glob('./*.map.stat')
file_list.sort()
out = open("align_stats.xls", "w")
out.write("Sample\tTotal reads\tmapped reads\tmap_rate\n")
#sample_info = open(sys.argv[1], "rt")
for ll in file_list:
    sample = os.path.basename(ll).split('.map.stat')[0]
#    sample = line.strip().split("\t")[0]
    ff = open(f"%s"%(ll), "rt")
    file_lines=ff.readlines()
    total=int([n for n in file_lines if n.endswith("total (QC-passed reads + QC-failed reads)\n")][0].split()[0])
    secondary = int([n for n in file_lines if n.endswith("secondary\n")][0].split()[0])
    supplementary = int([n for n in file_lines if n.endswith("supplementary\n")][0].split()[0])
    #mapped = int([n for n in file_lines if n.split(' ')[2]=="mapped"][0].split()[0])
    mapped = int([n for n in file_lines if op.contains(n,'mapped (')][0].split()[0])

    mapping_reads = mapped - secondary - supplementary
    total_reads = total - secondary - supplementary
    mapping = (mapped - secondary - supplementary)/(total - secondary - supplementary)
    mapping = round(mapping * 100, 2)
    out.write("{}\t{:,}\t{:,}\t{}%\n".format(sample, total_reads, mapping_reads, mapping))
    ff.close()
out.close()
