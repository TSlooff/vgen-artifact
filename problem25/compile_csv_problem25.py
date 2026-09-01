from subprocess import run
import numpy as np
import pandas as pd
import glob
import vcd.reader
from scipy.stats import entropy
import matplotlib.pyplot as plt
import editdistance
import os
import re

d = []

# ['file_name', 'model_type', 'prompt_detail', 'temp', 'completion_id', 'compiled', 'correct']
for model_type in ['gpt3.5', 'gpt4', 'claude', 'llama', 'mistral', 'gemini']:
    for prompt_detail in ['L', 'M', 'H']:
        for temp in [0.1, 0.3, 0.5, 0.7, 1.0]:
            for completion_id in range(100):
                file_name = f"completions_{model_type}/completion_{prompt_detail}_t{temp}_{completion_id}.c"
                with open(file_name, "r") as f:
                    code = f.read()
                
                if os.path.isfile("sbox.c"):
                    os.remove("sbox.c")
                if os.path.isfile("check.bin"):
                    os.remove("check.bin")
                    
                with open("sbox.c", "w") as f:
                    f.write("#include<stdint.h>\n")
                    f.write(code)
                p = run(['gcc', 'testbench.c', 'ref.c', 'sbox.c', '-ocheck.bin'])
                if p.returncode == 0:
                    # compile successful
                    p2 = run(['./check.bin'])
                    d.append([file_name, model_type, prompt_detail, temp, completion_id, 1, int(p2.returncode == 0)])
                else:
                    d.append([file_name, model_type, prompt_detail, temp, completion_id, 0, 0])


d_pd = pd.DataFrame(d, columns=['file_name', 'model_type', 'prompt_detail', 'temp', 'completion_id', 'compiled', 'correct'])

d_pd.to_csv("stats.csv", index=False)