from subprocess import run, DEVNULL, TimeoutExpired
import numpy as np
import pandas as pd
import glob
import vcd.reader
from scipy.stats import entropy
import matplotlib.pyplot as plt
import editdistance
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

compile

change_selection -name global -replace [get_timing_paths -delay_type max -nworst 1 -max_paths 1 -include_hierarchical_pins]

uplevel #0 {{ report_area -hierarchy > area.txt}}

exit
exit
"""

def get_area(file_path, top_module, clock_name):

    script_file = "test_area_script.tcl"
    
    if os.path.isfile("area.txt"):
        os.remove("area.txt")
    if os.path.isfile(script_file):
        os.remove(script_file)
        
    with open(script_file, "w") as f:
        f.write(script_text.format(file_path=file_path, top_module=top_module))

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
if os.path.isfile("dump.vcd"):
    os.remove("dump.vcd")

p1 = run(['vlog', 'ref_no_p.sv'])
p2 = run(['vlog', 'only_p.sv'])
p3 = run(['vlog', 'testbench.sv'])
p4 = run("""vsim -c -novopt -warning vsim-12110 quark_tb -do 'run 11000; quit'""", shell=True)
p5 = run(['mv', 'dump.vcd', 'ref.vcd'])

# build p_ref
with open("ref.vcd", "rb") as f:
    tokens = vcd.reader.tokenize(f)
    f_ref = []
    f_id = ''
    curr_state = ''
    for i, token in enumerate(tokens):
        if token.kind == vcd.reader.TokenKind.VAR and token.data.reference == 'p_t':
            f_id = token.data.id_code
        if token.kind == vcd.reader.TokenKind.CHANGE_SCALAR and token.data.id_code == f_id:
            curr_state = token.data.value
        if token.kind == vcd.reader.TokenKind.CHANGE_TIME:
            f_ref.append(curr_state)

# ['file_name', 'model_type', 'prompt_detail', 'temp', 'completion_id', 'compiled', 'passed_bench', 'Levenshtein distance']
d.append(["ref.vcd", "manual", "NA", 'NA', 'NA', 1, 1, editdistance.eval(f_ref, f_ref), "NA"])

# ['file_name', 'model_type', 'prompt_detail', 'temp', 'completion_id', 'compiled', 'passed_bench', 'Levenshtein distance']
for model_type in ['llm', 'gpt3.5', 'gpt4', 'claude', 'llama', 'mistral', 'gemini']:
    for file_name in glob.glob(f"completions_{model_type}/*.v"):
        m = re.match(r"(\S*)/completion_(\S)_t(\S+)_(\d+).v", file_name)
        if m:
            prompt_detail = m.groups()[1]
            temp = float(m.groups()[2])
            completion_id = int(m.groups()[3])
        else:
            print("error on processing file name", file_name)
            break
        if os.path.isdir("work/"):
            assert run(['rm', '-rf', 'work/']).returncode == 0
        if os.path.isfile("dump.vcd"):
            os.remove("dump.vcd")
        p = run(['vlog', file_name])
        if p.returncode == 0:
            # compiling successful
            p2_1 = run(['vlog', 'ref_no_p.sv'])
            p2_2 = run(['vlog', 'testbench.sv'])
            if p2_1.returncode != 0 or p2_2.returncode != 0:
                print("error, can't compile testbench or ref_no_p")
                break

            try:
                p3 = run("""vsim -c -novopt -warning vsim-12110 quark_tb -do 'run 11000; quit'""", shell=True, timeout=120)
            except TimeoutExpired as e:
                with open("timeout.log", "a") as f:
                    f.write(f"{file_name}\n")
                # can not run bench
                d.append([file_name, model_type, prompt_detail, temp, completion_id, 1, 0, 'NA', 'NA'])
            if p3.returncode != 0:
                # can not run bench
                d.append([file_name, model_type, prompt_detail, temp, completion_id, 1, 0, 'NA', 'NA'])
            else:
                try:
                    with open("dump.vcd", "rb") as f:
                        tokens = vcd.reader.tokenize(f)
                        f_track = []
                        f_id = ''
                        curr_state = ''
                        for i, token in enumerate(tokens):
                            if token.kind == vcd.reader.TokenKind.VAR and token.data.reference == 'p_t':
                                f_id = token.data.id_code
                            if token.kind == vcd.reader.TokenKind.CHANGE_SCALAR and token.data.id_code == f_id:
                                curr_state = token.data.value
                            if token.kind == vcd.reader.TokenKind.CHANGE_TIME:
                                f_track.append(curr_state)  
                        d.append([file_name, model_type, prompt_detail, temp, completion_id, 1, 1, editdistance.eval(f_track, f_ref), get_area(file_name, "p", "NA")])
                except vcd.reader.VCDParseError as e:
                    print(e)
                    d.append([file_name, model_type, prompt_detail, temp, completion_id, 1, 0, 'NA', 'NA'])
        else:
            d.append([file_name, model_type, prompt_detail, temp, completion_id, 0, 0, 'NA', 'NA'])

d_pd = pd.DataFrame(d, columns=['file_name', 'model_type', 'prompt_detail', 'temp', 'completion_id', 'compiled', 'passed_bench', 'Levenshtein distance', 'area'])

d_pd.to_csv("stats.csv", index=False)