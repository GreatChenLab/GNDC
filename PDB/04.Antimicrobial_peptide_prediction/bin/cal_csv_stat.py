#!/usr/bin/python
import os,sys,glob,sys
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

input_file = sys.argv[1]

with open(input_file,"r") as f:
    for line in f:
        if line.strip().startswith(","):
            new_line = line.strip().split(",")
            item_index_dict = dict(zip(new_line,range(len(new_line))))
            del item_index_dict['']
            del item_index_dict['name']
            del item_index_dict['sequence']
            item_num_dict = dict(zip(new_line[3:],[0] * len(new_line[3:])))
            all_num = 0
        else:
            all_num += 1
            new_line = line.strip().split(",")
            for a,b in item_index_dict.items():
                item = a 
                index = b
                if new_line[index] == "Yes":
                    item_num_dict[item] += 1
                else:
                    pass
    #print(all_num)
    #print(item_num_dict)

with open("prediction_results.xls","w") as f:
    f.write("Item\tNum\tratio(%)\n")
    f.write("All\t%s\t100.00\n" % (all_num))
    for a,b in item_num_dict.items():
        ratio = "%.2f" % (float(b / int(all_num) * 100))
        f.write("%s\t%s\t%s\n" % (a,b,ratio))

df = pd.read_csv("prediction_results.xls", sep="\t", skiprows=2, header=None, names=["Category", "Num", "Ratio"])

plt.figure(figsize=(12, 6))

colors = sns.color_palette("viridis", len(df)) 
plt.bar(df["Category"], df["Ratio"], color=colors)

plt.xticks(rotation=45, ha="right", fontsize=10)

plt.ylim(0, 100)

plt.xlabel("Category", fontsize=12)
plt.ylabel("Ratio (%)", fontsize=12)
plt.title("Prediction Results Histogram", fontsize=14)

sns.despine()

plt.savefig("prediction_results.png", dpi=300, bbox_inches="tight")

plt.close()

print("saved as prediction_results.png")

