
1. 下载仓库: <https://github.com/GreatChenLab/deepB3P>

2. 安装环境
    
    1. 如果conda太老，没办法使用`deepB3P/environment.yml`
    
    2. 使用pip安装也需要额外处理`deepB3P/requirements.txt`

    ```
    # cut -f 1 -d "@" requirements.txt > requirements.txt.new
    # 删除 dgl 的版本限制
    # 删除 pepnn 包

    # 先安装 python 3.7
    # 再 pip install -r requirements.txt.new
    ```

3. 更改`deepB3P/model/deepb3p.py`

    > 原因：原模型是在 nvidia GPU 训练，但是我们运行需要在 CPU 上运行；

    ```Python
    # 原代码
    self.model.load_state_dict(torch.load(directory))

    # 新代码
    self.model.load_state_dict(torch.load(directory,map_location=torch.device('cpu')))
    ```

4. 可选；更改输出文件，方便多进程后分辨结果。

    ```Python
    def predict(file,outfile):
        ......
        res.to_csv(outfile, index=False) # 'prob.txt'

    if __name__ == '__main__':
        import sys
        if len(sys.argv) != 3:
            print("Usage:\npython predict_user.py fasta_file outfile")
            exit(0)
        file = sys.argv[1]
        outfile = sys.argv[2]
        predict(file,outfile)
        print('predict ok')
    ```

5. 开始准备运行

```shell
# 去除序列中的"*"和"X"字符
bash run.1.clean.sh
# 分割序列
bash run.2.split.sh
# 获得运行命令 run.4.all.sh
bash run.3.get_all.sh
# 多线程运行
bash run.5.paralleltask.sh
# 合并和统计结果
python run.6.merge.py
python run.7.stat.py 0.5
python run.7.stat.py 0.8
```

