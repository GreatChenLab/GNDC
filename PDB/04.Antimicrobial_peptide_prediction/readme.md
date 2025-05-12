# 抗菌肽流程说明文档

## 流程依赖

 - seqkit：v2.9.0
 - iAMPCN（[git网址](https://github.com/joy50706/iAMPCN/tree/master)）
 - python：3.8.0
 - python 包：pandas，matplotlib，seaborn
 - nextflow：20.10.0
 - conda 或者 mamba环境

## 环境搭建
以 `mamba` 举例

```bash
git clone https://github.com/joy50706/iAMPCN.git
git checkout master
micromamba create -n iampcn python==3.8
micromamba activate iampcn
pip install numpy -i https://pypi.tuna.tsinghua.edu.cn/simple/
pip install pandas -i https://pypi.tuna.tsinghua.edu.cn/simple/
pip install biopython -i https://pypi.tuna.tsinghua.edu.cn/simple/
pip install tqdm -i https://pypi.tuna.tsinghua.edu.cn/simple/
pip install -U scikit-learn -i https://pypi.tuna.tsinghua.edu.cn/simple/
pip install pandas -i https://pypi.tuna.tsinghua.edu.cn/simple/
pip install matplotlib -i https://pypi.tuna.tsinghua.edu.cn/simple/
pip install seaborn -i https://pypi.tuna.tsinghua.edu.cn/simple/
micromamba deactivate
micromamba install -n iampcn pytorch torchvision torchaudio cpuonly -c pytorch -c conda-forge -c bioconda
```

安装 seqkit 见 [官网](https://github.com/shenwei356/seqkit)
安装 nextflow 见[官网](https://www.nextflow.io/)
安装 micromamba 见[官网](https://mamba.readthedocs.io/en/latest/installation/micromamba-installation.html)

## 参数

|参数| 解释 | 默认|
|--|--|--|
| - - input_dir | 存放小肽数据的目录，eg：*.5_75_amino_acids.pep.fa | 无  |
| - - pred_threshold | 预测概率阈值，pred 越接近 1，表示模型越有信心该序列是抗菌肽  | 0.5
| - - high_cpu | iAMPCN 预测抗菌肽时单个任务用的 cpu 数目  | 60
| - - queueq | 投递的队列名称  | xhhctdnormal

## 运行示例

```bash
## 01.进环境
micromamba activate iampcn
## 02.运行nf
nextflow run iAMPCN.nf -qs 400 -resume -with-trace --input_dir 00.data/ --pred_threshold 0.98 --high_cpu 16
```
**-qs：运行 nf 时最大并行任务数
-resume：流程可断点续跑
-with-trace：输出目录追踪 trace.txt 文件**


