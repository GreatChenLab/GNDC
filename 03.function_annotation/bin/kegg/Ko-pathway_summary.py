#!/usr/bin/env python
# -*- encoding: utf-8 -*-
'''
@Time   ：   2022-05-24
@username   :   chenzhenzhen
'''
"""kegg Ko 和 pathway 合并"""

import sys
import numpy as np

ko_anno = {}
with open(sys.argv[1],"r") as kegg:
    next(kegg)
    for l in kegg.readlines():
        ctg = l.strip().split("\t")[0]
        anno = l.strip().split("\t")[1] + "\t" + l.strip().split("\t")[2]
        ko_anno[ctg] = anno

path_anno = {}
idlist = []
with open(sys.argv[2],"r") as path:
    next(path)
    for li in path.readlines():
        type = li.strip().split("\t")[1] + "\t" + li.strip().split("\t")[2] + "\t" + li.strip().split("\t")[3]
        ko_id = li.strip().split("\t")[4]
        idlist.append(ko_id)
        path_anno[ko_id] = type

uniq_path = {}
uniq_id = np.unique(idlist)
for i in uniq_id:
    if i in path_anno.keys():
        uniq_path[i] = path_anno[i]


with open(sys.argv[3],"r") as id,open(sys.argv[4],"w") as out:
    out.write("SeqID\tKoID\tGene\tPathwayID\tClassI\tClassII\tClassIII\n")
    next(id)
    for line in id.readlines():
        ctg_id = line.strip().split("\t")[0]
        ko = line.strip().split("\t")[2]
        if ctg_id in ko_anno.keys():
            out.write("{}\t{}\t".format(ctg_id,ko_anno[ctg_id]))
        if ko in uniq_path.keys():
            out.write("{}\t{}\n".format(ko,uniq_path[ko]))
