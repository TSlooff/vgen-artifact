from subprocess import run, DEVNULL
import numpy as np
import pandas as pd
import glob
import vcd.reader
from scipy.stats import entropy
import matplotlib.pyplot as plt
import re
import os

script_text = """sh rm -rf WORK/*
sh rm -rf AN.DB/*
sh rm -rf csrc/*
remove_design -all


define_design_lib WORK -path ./WORK
analyze -library WORK -format verilog {{
{file_path}
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
        
def extract_q_vals(file_name):
    q_ids = dict()
    q_vals = dict()
    with open(file_name, "rb") as f:
        tokens = vcd.reader.tokenize(f)
        Q = np.array(['x'] * 16)
        for i, token in enumerate(tokens):
            if token.kind == vcd.reader.TokenKind.VAR and token.data.reference == 'Q':
                q_ids[token.data.id_code] = token.data.bit_index
            elif token.kind == vcd.reader.TokenKind.CHANGE_SCALAR and token.data.id_code in q_ids.keys():
                Q[q_ids[token.data.id_code]] = token.data.value
            elif token.kind == vcd.reader.TokenKind.CHANGE_TIME:
                # when the time changes, i.e. change in clock, then we record the value of Q
                q_vals["".join(Q)] = q_vals.get("".join(Q), 0) + 1
    # unset Q value, can be removed
    q_vals.pop('xxxxxxxxxxxxxxxx', None)
    return q_vals

# ['filename', 'model_type', 'prompt_detail', 'temp', 'completion_id', 'compiled', 'passed_bench', 'period_low', 'entropy_low', 'period_high', 'entropy_high', 'area']
d = []

file_name = 'ref.sv'
if os.path.isdir("work/"):
    assert run(['rm', '-rf', 'work/']).returncode == 0
if os.path.isfile("dump.vcd"):
    os.remove("dump.vcd")
p = run(['vlog', file_name])
p2 = run(['vlog', 'testbench_low.sv'])
if p2.returncode != 0:
    print("error, can't compile testbench")
    exit()
p3 = run("""vsim -c -novopt -warning vsim-12110 lfsr_16bit_tb -do 'run 1310720; quit'""", shell=True)
q_vals = extract_q_vals("dump.vcd")
P_l = len(q_vals.keys())
H_l = entropy(list(q_vals.values()))

if os.path.isdir("work/"):
    assert run(['rm', '-rf', 'work/']).returncode == 0
if os.path.isfile("dump.vcd"):
    os.remove("dump.vcd")
p = run(['vlog', file_name])
p2 = run(['vlog', 'testbench_high.sv'])
if p2.returncode != 0:
    print("error, can't compile testbench")
    exit()
p3 = run("""vsim -c -novopt -warning vsim-12110 lfsr_16bit_tb -do 'run 1310720; quit'""", shell=True)
q_vals = extract_q_vals("dump.vcd")

d.append([file_name, 'manual', 'NA', -1, -1, 1, 1, P_l, H_l, len(q_vals.keys()), entropy(list(q_vals.values())), "NA"])

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

        # RESET = LOW testbench
        if os.path.isdir("work/"):
            assert run(['rm', '-rf', 'work/']).returncode == 0
        if os.path.isfile("dump.vcd"):
            os.remove("dump.vcd")
        p = run(['vlog', file_name])
        if p.returncode == 0:
            # compiling successful
            p2 = run(['vlog', 'testbench_low.sv'])
            if p2.returncode != 0:
                print("error, can't compile testbench low")
                break
            p3 = run("""vsim -c -novopt -warning vsim-12110 lfsr_16bit_tb -do 'run 1310720; quit'""", shell=True)
            if p3.returncode != 0:
                # does not pass bench, can occur if LLM introduces timescale into their code
                d.append([file_name, model_type, prompt_detail, temp, completion_id, 1, 0, 0, 0, 0, 0, "NA"])
            else:
                q_vals = extract_q_vals("dump.vcd")
                P_l = len(q_vals.keys())
                H_l = entropy(list(q_vals.values()))
        else:
            d.append([file_name, model_type, prompt_detail, temp, completion_id, 0, 0, 0, 0, 0, 0, "NA"])

        
        # RESET = HIGH testbench
        if os.path.isdir("work/"):
            assert run(['rm', '-rf', 'work/']).returncode == 0
        if os.path.isfile("dump.vcd"):
            os.remove("dump.vcd")
        p = run(['vlog', file_name])
        if p.returncode == 0:
            # compiling successful
            p2 = run(['vlog', 'testbench_high.sv'])
            if p2.returncode != 0:
                print("error, can't compile testbench high")
                break
            p3 = run("""vsim -c -novopt -warning vsim-12110 lfsr_16bit_tb -do 'run 1310720; quit'""", shell=True)
            if p3.returncode != 0:
                # does not pass bench, can occur if LLM introduces timescale into their code
                d.append([file_name, model_type, prompt_detail, temp, completion_id, 1, 0, 0, 0, 0, 0, "NA"])
            else:
                q_vals = extract_q_vals("dump.vcd")
                d.append([file_name, model_type, prompt_detail, temp, completion_id, 1, 1, P_l, H_l, len(q_vals.keys()), entropy(list(q_vals.values())), get_area(file_name, "lfsr_16bit", "clk")])
        else:
            d.append([file_name, model_type, prompt_detail, temp, completion_id, 0, 0, 0, 0, 0, 0, "NA"])

d_pd = pd.DataFrame(d, columns=['filename', 'model_type', 'prompt_detail', 'temp', 'completion_id', 'compiled', 'passed_bench', 'period_low', 'entropy_low', 'period_high', 'entropy_high', 'area'])

d_pd.to_csv("stats.csv", index=False)
