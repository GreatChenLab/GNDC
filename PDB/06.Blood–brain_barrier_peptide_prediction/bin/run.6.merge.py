import os
import pandas as pd
import re, glob
import multiprocessing
from tqdm import tqdm
def process_species(species_data):
    species, file_list = species_data
    output_file = f"Result/{species}.merged.txt"
    if len(file_list) == 1:
        df = pd.read_csv(file_list[0], sep='\t', header=0)
        df.to_csv(output_file, sep='\t', index=False)
        return f"物种 {species} 只有一个文件，已复制为 {output_file}"
    all_dfs = []
    first_df = pd.read_csv(file_list[0], sep='\t', header=0)
    all_dfs.append(first_df)
    for file in file_list[1:]:
        df = pd.read_csv(file, sep='\t', header=0)
        all_dfs.append(df)
    merged_df = pd.concat(all_dfs, ignore_index=True)
    merged_df = merged_df.sort_values(by=merged_df.columns[3], ascending=False)
    merged_df.to_csv(output_file, sep='\t', index=False)
    return f"物种 {species} 的 {len(file_list)} 个文件已合并为 {output_file}"
def multiprocessing_tqdm(func, argument_list, num_processes=3):
    results = []
    pool = multiprocessing.Pool(processes=int(num_processes))
    for argument in argument_list:
        result = pool.apply_async(func, (argument,))
        results.append(result)
    pool.close()
    pbar = tqdm(total=len(argument_list), position=0, leave=True)
    result_messages = []
    for result in results:
        result_messages.append(result.get())
        pbar.update(1)
    pool.join()
    pbar.close()
    return result_messages
def merge_species_files(num_processes=4):
    files = glob.glob("run.4.all.sh.work/*/*/*.out.final.txt")
    species_files = {}
    for file in files:
        species_name = os.path.basename(file).split(".")[0]
        if species_name not in species_files:
            species_files[species_name] = []
        species_files[species_name].append(file)
    if not os.path.exists("Result"): 
        os.makedirs("Result")
    species_data_list = list(species_files.items())
    result_messages = multiprocessing_tqdm(process_species, species_data_list, num_processes)
    for message in result_messages:
        print(message)
if __name__ == "__main__":
    merge_species_files(80)