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

analyze -library WORK -format sverilog {{
quark_functions.sv
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
if os.path.isfile("ref.txt"):
    os.remove("ref.txt")

p1 = run(['vlog', 'quark_top.sv'])
p2 = run(['vlog', 'quark_functions.sv'])
p3 = run(['vlog', 'testbench.sv'])
p4 = run("""vsim -c -novopt -warning vsim-12110 quark_tb -do 'run 11000; quit'""", shell=True)
p5 = run(['mv', 'dump.vcd', 'ref.vcd'])

# build ref
with open("ref.vcd", "rb") as f:
    tokens = vcd.reader.tokenize(f)
    ref_track = []
    ref_id = ''
    for i, token in enumerate(tokens):
        if token.kind == vcd.reader.TokenKind.VAR:
            if token.data.reference == 'daout' and token.data.type_ == vcd.reader.VarType.reg:
                ref_id = token.data.id_code
        if token.kind == vcd.reader.TokenKind.CHANGE_VECTOR and token.data.id_code == ref_id:
            ref_track.append(token.data.value)     
  
# ['file_name', 'model_type', 'prompt_detail', 'temp', 'completion_id', 'compiled', 'passed_bench', 'correct', 'last_val']
d.append(["ref.vcd", "manual", "NA", "NA", "NA", 1, 1, 1, ref_track[-1], '540.868606'])

# ['file_name', 'model_type', 'prompt_detail', 'temp', 'completion_id', 'compiled', 'passed_bench', 'correct', 'last_val']
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
        if os.path.isfile("dump.vcd"):
            os.remove("dump.vcd")
        p = run(['vlog', file_name])
        if p.returncode == 0:
            # compiling successful
            p2_1 = run(['vlog', 'quark_functions.sv'])
            p2_2 = run(['vlog', 'testbench.sv'])
            if p2_1.returncode != 0 or p2_2.returncode != 0:
                print("error, can't compile testbench or quark_functions")
                break
            p3 = run("""vsim -c -novopt -warning vsim-12110 quark_tb -do 'run 11000; quit'""", shell=True)
            if p3.returncode != 0:
                # can not run bench
                d.append([file_name, model_type, prompt_detail, temp, completion_id, 1, 0, 0, 'NA', 'NA'])
            else:
                with open("dump.vcd", "rb") as f:
                    tokens = vcd.reader.tokenize(f)
                    uniq_track = []
                    uniq_id = ''
                    try:
                        for i, token in enumerate(tokens):
                            if token.kind == vcd.reader.TokenKind.VAR:
                                if token.data.reference == 'daout' and token.data.type_ == vcd.reader.VarType.reg:
                                    uniq_id = token.data.id_code
                            if token.kind == vcd.reader.TokenKind.CHANGE_VECTOR and token.data.id_code == uniq_id:
                                uniq_track.append(token.data.value)   
                        if len(uniq_track) == 0:
                            d.append([file_name, model_type, prompt_detail, temp, completion_id, 1, 1, 0, 'NA', get_area(file_name, 'quark', 'clk')])
                        else:
                            d.append([file_name, model_type, prompt_detail, temp, completion_id, 1, 1, int(uniq_track[-1] == ref_track[-1]), uniq_track[-1], get_area(file_name, 'quark', 'clk')])
                    except vcd.reader.VCDParseError as e:
                        d.append([file_name, model_type, prompt_detail, temp, completion_id, 1, 1, 0, 'NA', 'NA'])
        else:
            d.append([file_name, model_type, prompt_detail, temp, completion_id, 0, 0, 0, 'NA', 'NA'])

d_pd = pd.DataFrame(d, columns=['file_name', 'model_type', 'prompt_detail', 'temp', 'completion_id', 'compiled', 'passed_bench', 'correct', 'last_val', 'area'])

d_pd.to_csv("stats.csv", index=False)