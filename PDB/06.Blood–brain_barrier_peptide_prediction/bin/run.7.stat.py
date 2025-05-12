#!/usr/bin/env python3
import os
import glob
import pandas as pd
import multiprocessing
import sys
from tqdm import tqdm
def process_file(args):
    file_path, threshold = args
    species = os.path.basename(file_path).replace('.txt', '').replace('_peptides', '').replace('.merged', '')
    try:
        df = pd.read_csv(file_path, sep='\t')
        total_lines = len(df)
        lines_gt_threshold = len(df[df.iloc[:, 3] > threshold])
        return species, total_lines, lines_gt_threshold
    except Exception as e:
        return species, 0, 0
def multiprocessing_tqdm(func, argument_list, num_processes=3):
    results = []
    pool = multiprocessing.Pool(processes=int(num_processes))
    for argument in argument_list:
        result = pool.apply_async(func, (argument,))
        results.append(result)
    pool.close()
    pbar = tqdm(total=len(argument_list), position=0, leave=True)
    result_data = []
    for result in results:
        result_data.append(result.get())
        pbar.update(1)
    pool.join()
    pbar.close()
    return result_data
def main():
    threshold = 0.5
    if len(sys.argv) > 1:
        threshold = float(sys.argv[1])
    files = glob.glob("Result/*.txt")
    file_args = [(file, threshold) for file in files]
    results = multiprocessing_tqdm(process_file, file_args, num_processes=20)
    with open(f"Result.stat.{threshold}.txt", "w") as f:
        f.write(f"物种名\t总行数\t>{threshold}的行数\t比例\n")
        for species, total, gt_threshold in results:
            ratio = 0 if total == 0 else round(gt_threshold / total * 100, 2)
            f.write(f"{species}\t{total}\t{gt_threshold}\t{ratio}%\n")
if __name__ == "__main__":
    main()