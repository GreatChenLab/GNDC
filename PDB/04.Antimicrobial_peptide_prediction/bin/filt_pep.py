#!/usr/bin/python3
import os,sys,glob,re

if len(sys.argv) == 3:
	input_pep = sys.argv[1]
	output_pep = sys.argv[2]
	with open(input_pep,"r") as f1,open(output_pep,"w") as f2:
		idstr_line = f1.read().split(">")
		for each in idstr_line[1:]:
			each_line = each.strip().split("\n")
			id_prefix = each_line[0].split()[0]
			seq_str = "".join(each_line[1:])
			
			if "X" in seq_str:
				write_tag = 0
			else:
				if "." in seq_str[:-1] or "*" in seq_str[:-1]:
					write_tag = 0
				else:
					if seq_str[-1] == "." or seq_str[-1] == "*":
						seq_str = seq_str[:-1]
						write_tag = 1
					else:
						write_tag = 1
			if write_tag == 0:
				continue
			else:
				f2.write(">%s\n" % id_prefix)
				f2.write("%s\n" % seq_str)
else:
	print("Usage:python3 %s input.pep output.pep\n" % sys.argv[0])
