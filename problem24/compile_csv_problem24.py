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

script_text = """sh rm -rf WORK/*
sh rm -rf AN.DB/*
sh rm -rf csrc/*
remove_design -all


define_design_lib WORK -path ./WORK

analyze -library WORK -format verilog {{
{file_path}
}}


analyze -library WORK -format verilog {{
aes_no_top.v
}}


elaborate {top_module} -library WORK


create_clock -name "{clock_name}" -period 10 -waveform {{ 0 5  }}  {{ {clock_name} }}

compile

change_selection -name global -replace [get_timing_paths -delay_type max -nworst 1 -max_paths 1 -include_hierarchical_pins]

uplevel #0 {{ report_area -hierarchy > area.txt}}

exit
exit
"""

def get_area(file_path, top_module, clock_name):
    
    if os.path.isfile("area.txt"):
        os.remove("area.txt")
        
    script_file = "test_area_script.tcl"
    with open(script_file, "w") as f:
        f.write(script_text.format(file_path=file_path, top_module=top_module, clock_name=clock_name))

    p = run(['/usr/bin/csh', '-c', f"dc_shell -f {script_file}"])
    if p.returncode == 0:
        area_line = None
        with open("area.txt", "r") as f:
            for l in f.readlines():
                if "Error:" in l:
                    return "NA"
                if "Total cell area:" in l:
                    area_line = l
                    break
        if area_line is None:
            return "NA"
        return re.search("(\d+.\d+)", area_line).group()
    else:
        return "NA"

d = []

if os.path.isdir("work/"):
    assert run(['rm', '-rf', 'work/']).returncode == 0
if os.path.isfile("REF.txt"):
    os.remove("REF.txt")
if os.path.isfile("CT.txt"):
    os.remove("CT.txt")


target = 'top'

p1 = run(['vlog', f'aes_no_{target}.v'])
p2 = run(['vlog', f'{target}.v'])
p3 = run(['vcom', 'aes_tb.vhd'])
p4 = run("""timeout --preserve-status 5m vsim -c aes_tb -do 'run 100us;quit'""", shell=True)
p5 = run(['mv', 'CT.txt', 'REF.txt'])

# build ref
with open("REF.txt", "r") as f:
    ref_CTs = f.readlines()

# ['file_name', 'model_type', 'prompt_detail', 'temp', 'completion_id', 'compiled', 'passed_bench', 'correct', 'first_CT', 'Levenshtein distance']
d.append(["REF.txt", "manual", "NA", "NA", "NA", 1, 1, 1, ref_CTs[0], 0, get_area('top.v', 'aes', 'clk')])
for model_type in ['llm', 'gpt3.5', 'gpt4', 'claude', 'llama', 'mistral', 'gemini']:
    for file_name in glob.glob(f"completions_{model_type}/*.v"):
        m = re.match(r"(\S*)/completion_(\S)_t(\S+)_(\d+).v", file_name)
        if m:
            prompt_detail = m.groups()[1]
            temp = float(m.groups()[2])
            completion_id = int(m.groups()[3])
        else:
            print("ERRROOORRRR", file_name)
            break
        if os.path.isdir("work/"):
            assert run(['rm', '-rf', 'work/']).returncode == 0
        if os.path.isfile("CT.txt"):
            os.remove("CT.txt")
        p = run(['vlog', file_name])
        if p.returncode == 0:
            # compiling successful
            p2_1 = run(['vlog', f'aes_no_{target}.v'])
            p2_2 = run(['vcom', 'aes_tb.vhd'])
            if p2_1.returncode != 0 or p2_2.returncode != 0:
                print("error, can't compile testbench or ref modules")
                break
            p3 = run("""timeout --preserve-status 5m vsim -c aes_tb -do 'run 100us;quit'""", shell=True)
            if p3.returncode != 0:
                # can not run bench
                d.append([file_name, model_type, prompt_detail, temp, completion_id, 1, 0, 0, 'NA', 'NA', 'NA'])
            else:
                with open("CT.txt", "r") as f:
                    CTs = f.readlines()
                d.append([file_name, model_type, prompt_detail, temp, completion_id, 1, 1, int(CTs == ref_CTs), CTs[0] if len(CTs) != 0 else 'NA', sum(editdistance.eval(a, b) for (a,b) in zip(CTs, ref_CTs)), get_area(file_name, 'aes', 'clk')])
        else:
            d.append([file_name, model_type, prompt_detail, temp, completion_id, 0, 0, 0, 'NA', 'NA', 'NA'])

d_pd = pd.DataFrame(d, columns=['file_name', 'model_type', 'prompt_detail', 'temp', 'completion_id', 'compiled', 'passed_bench', 'correct', 'first CT', 'Levenshtein distance', 'area'])

d_pd.to_csv("stats.csv", index=False)