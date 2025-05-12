#!/usr/bin/python3
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

df = pd.read_csv("prediction_results.xls", sep="\t", skiprows=2, header=None, names=["Category", "Num", "Ratio"])

plt.figure(figsize=(12, 6))

colors = sns.color_palette("viridis", len(df))  # 使用渐变色
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

