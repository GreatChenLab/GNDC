#!/usr/bin/python3
import os,re,sys,glob

out_file = sys.argv[1]

csv_line = glob.glob("*_*.csv")

head_str = os.popen("head -n1 %s" % csv_line[0]).read().strip()

with open(out_file,"w") as f:
    f.write(head_str + "\n")
    n = 0
    for each in csv_line:
        with open(each,"r") as f1:
            for line in f1:
                if line.strip().startswith(","):
                    pass
                else:
                    new_line = line.strip().split(",")
                    new_line[0] = str(n)
                    f.write(",".join(new_line) + "\n")
                    n += 1
