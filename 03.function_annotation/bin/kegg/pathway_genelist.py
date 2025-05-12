#!/usr/bin/env python
# -*- encoding: utf-8 -*-
'''
@Time   ：   2022-05-24
@username   :   chenzhenzhen
'''
"""KEGG pathway分类统计后加入每类基因id整合"""

import sys
import numpy as np

a = {}
list = []
with open(sys.argv[1],"r") as path:
    next(path)
    for l in path.readlines():
        type = l.strip().split("\t")[4] + "\t" + l.strip().split("\t")[5]
        list.append(type)
        gene = l.strip().split("\t")[2].split("`")[0]
        a.setdefault(type, []).append(gene)

uniq_type = {}
uniq_id = np.unique(list)
for i in uniq_id:
    if i in a.keys():
        uniq_type[i] = a[i]

with open(sys.argv[2],"r") as cls,open(sys.argv[3],"w") as out:
    out.write("ClassI\tClassII\tGeneNum\tGene\n")
    next(cls)
    for line in cls.readlines():
        clas = line.strip().split("\t")[0] + "\t" + line.strip().split("\t")[1]
        num = line.strip().split("\t")[2]
        if clas in a.keys():
            out.write("{}\t{}\t{}\n".format(clas,num,", ".join(uniq_type[clas])))
