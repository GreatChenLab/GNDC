1. 安装PepNet (https://github.com/hjy23/PepNet)
    git clone https://github.com/hjy23/PepNet.git
    cd PepNet
    conda create -n PepNet python=3.8
    source activate PepNet
    pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
    pip install -r requirements.txt

2. 下载预先训练完成的数据库（ProtT5-XL-U50）
    https://huggingface.co/Rostlab/prot_t5_xl_uniref50/tree/main
    下载完成后直接解压在PepNet目录下
    tar -zxvf datasets.tar.gz

3. 运行预测AIP的代码,修改 run_Aip.py 中PetPath的路径为PepNet的安装路径即可
    python run_Aip.py ${inputFa} ${outdir} 
