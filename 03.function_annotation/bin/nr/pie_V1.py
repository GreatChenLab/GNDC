# -*- coding: utf-8 -*-
"""
v1.0.0.202205    jjl@j-jl.com
"""
#%%---------------------------------------------------------------
import pandas as pd
import os,sys,argparse,re,glob
#from loguru import logger
#%%-----------------------------------------------------------------
Bin,filename = os.path.split(os.path.realpath(__file__))
parser = argparse.ArgumentParser(description='test\n')
parser.add_argument('-i', '--indata', dest='indata',    required=True, help='配置文件') # required=True , 
parser.add_argument('-o', '--prefix', dest='prefix', default=f"{os.getcwd()}/pie",  help='输出文件前缀')
args   = parser.parse_args()
#%%---------------------------------------------------------------------------
def main():
#    if not os.path.exists(os.path.dirname(args.prefix)): os.makedirs(os.path.dirname(args.prefix))
    #---------------------------------------------------------------------------
    df_data = pd.read_csv(args.indata,sep="\t")
    df_data["factor"] = round(df_data['Number'] / sum(df_data['Number']), 4)
    #print(df_data)
    info_dict = {}
    for i,row in df_data.iterrows(): 
        # name =  f"{row['Species']}({100*row['factor']}%)"
        name =  row['Species']
        info_dict[name] = {"name": name, "value": row["Number"]}

    #---------------------------------------------------------------------------
    w = open(f"{args.prefix}.html","w",encoding='utf-8')
    with open(f"{Bin}/pie.echart.html","r",encoding='utf-8') as f:
        for line in f.readlines():
            if re.search("_replace",line):
                line = line.replace("data_replace",str([value for key,value in info_dict.items()]))
                line = line.replace("legend_replace",str(list(info_dict.keys())))
                line = line.replace("title_replace","NR 注释结果")
                #print(line)
            w.write(line)
    w.close()
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
#%%-----------------------------------------------------------------------------
if __name__ == "__main__":
#    logger.success("开始运行")
    main()
#    logger.success('运行完成' )
