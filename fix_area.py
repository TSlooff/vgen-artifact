from subprocess import run, DEVNULL
import numpy as np
import pandas as pd
import glob
import vcd.reader
from scipy.stats import entropy
import matplotlib.pyplot as plt
import editdistance
import os
import re
import sys

problem_id = sys.argv[1]
os.chdir(f"problem{problem_id}")


def get_top_module_clock():
    if problem_id == '1':
        with open("compile_csv.py", "r") as f:
            t = f.read()
    else:
        with open(f"compile_csv_problem{problem_id}.py", "r") as f:
            t = f.read()
    p = re.compile('get_area\(file_name,\s?[\'"](.*?)[\'"],\s?[\'"](.*?)[\'"]\)', re.DOTALL)
    return p.findall(t)[0]
    
def get_script_text():
    to_exec = []
    track = False
    if problem_id == '1':
        with open("compile_csv.py", "r") as f:
            t = f.read()
    else:
        with open(f"compile_csv_problem{problem_id}.py", "r") as f:
            t = f.read()
    p = re.compile('(?:""")(.*?)(?:""")', re.DOTALL)
    return p.findall(t)[0]

top_module, clock = get_top_module_clock()
script_text = get_script_text()
print(f"working on problem {problem_id} in dir: {os.getcwd()} on module {top_module} with clock {clock}")
print("script text:")
print(script_text)
print()

assert("uplevel #0 {{ report_area -hierarchy > area.txt}}" in script_text)

def get_area(file_path, top_module, clock_name):
    
    if os.path.isfile("area.txt"):
        os.remove("area.txt")
        
    script_file = "test_area_script.tcl"
    with open(script_file, "w") as f:
        f.write(script_text.format(file_path=file_path, top_module=top_module, clock_name=clock_name))

    p = run(['/usr/bin/csh', '-c', f"dc_shell -f {script_file}"], capture_output = True)
    if p.returncode == 0:
        if p.stdout.decode().count("Error:") > 1: # >1 because clock can give an error which can be ignored
            return "NA"
        if "The statements in initial blocks are ignored." in p.stdout.decode():
            return "NA"
        area_line = None
        with open("area.txt", "r") as f:
            for l in f.readlines():
                if "Total cell area:" in l:
                    area_line = l
                    break
        if area_line is None:
            return "NA"
        return re.search("(\d+.\d+)", area_line).group()
    else:
        return "NA"

data = pd.read_csv(f"stats.csv")
data.drop_duplicates(inplace=True, ignore_index=True)

if 'correct' not in data.columns:
    if 'Levenshtein distance' in data.columns:
        data['correct'] = (data['Levenshtein distance'] == 0).astype(int)
    else:
        data['period'] = data[['period_low', 'period_high']].max(axis=1)
        data['correct'] = (data['period'] == 65535).astype(int)

with open("area_change.txt", "w") as f:
    for i in data.loc[data['correct'] == 1,].index:
        if i > 0:
            file_name = data.loc[i, 'file_name']
            org_area = data.loc[i, 'area']
            new_area = get_area(file_name, top_module, clock)
            f.write(",\t".join([str(i), file_name, str(org_area), new_area]))
            f.write("\n")
            data.at[i,'area'] = new_area

# print(data.loc[data['correct'] == 1,])

data.to_csv("stats.csv", index=False)