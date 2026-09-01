# Benchmarking Large Language Models on HDL Generation of Cryptographic Primitives

This repository contains the relevant scripts for the paper *Benchmarking Large Language Models on HDL Generation of Cryptographic Primitives*. The completions themselves are hosted on Zenodo and can be used together with these scripts to reproduce results. Figures can be reproduced based on csv files which are hosted directly here.

Seven LLMs are evaluated on 25 tasks drawn from LFSR-based constructions, Quark, PRESENT
and AES. Each task is prompted at three levels of detail (**L**ow, **M**edium, **H**igh)
and five temperatures (0.1, 0.3, 0.5, 0.7, 1.0), with 100 completions per cell —
**261,000 completions** in total. Every completion is compiled, simulated against a
hand-written testbench, and (where functionally correct) synthesised to obtain circuit area.

## Tasks

| Problem | Top Module | Task | Complexity |
|---|---|---|---|
| 1 | LFSR | 16-bit Linear-Feedback Shift Register | Basic |
| 2 | Quark | P Function | Basic |
| 3 | Quark | F Function | Medium |
| 4 | Quark | G Function | Medium |
| 5 | Quark | H Function | Medium |
| 6 | Quark | Top Module | Challenging |
| 7 | Present | Rotate | Basic |
| 8 | Present | Round | Basic |
| 9 | Present | Keyschedule | Basic |
| 10 | Present | Sbox | Medium |
| 11 | Present | Substitution Layer | Medium |
| 12 | Present | Permutation Layer | Challenging |
| 13 | Present | Top Module | Challenging |
| 14 | AES | Round Function | Basic |
| 15 | AES | Final Round Function | Basic |
| 16 | AES | Finite Field Multiplication by 2 in $GF(2^8)$ | Basic |
| 17 | AES | Finite Field Multiplication by 3 in $GF(2^8)$ | Basic |
| 18 | AES | Keyschedule | Medium |
| 19 | AES | Last Column Operation in Keyschedule | Medium |
| 20 | AES | Shiftrow | Medium |
| 21 | AES | Substitution Layer | Medium |
| 22 | AES | Sbox | Challenging |
| 23 | AES | Mixcolumns | Challenging |
| 24 | AES | Top Module | Challenging |
| 25 | Present | Present Sbox in C | Medium |

## Repository structure

```
problem1/ ... problem25/     one directory per task (see below)
figures/                     figures used in the paper (as well as additional ones)
completions_backup/          pre-markdown-stripping copies of completions
*_gen*.py                    scripts used to query each model
vis_stats.ipynb              produces the paper's tables and figures
rm_md.ipynb                  strips markdown fences from raw completions
script_lp07.tcl              Synopsys Design Compiler synthesis template
```

### Inside a problem directory

| File | Description |
|---|---|
| `prompt_L.txt`, `prompt_M.txt`, `prompt_H.txt` | The three prompts for this task |
| `<module>.v` / `.sv` | Reference implementation of the module under test |
| `ref_no_<module>.v`, `aes_no_<module>.v`, … | Surrounding design with the module removed; the LLM output is substituted here |
| `*_tb.vhd`, `testbench*.sv`, `testbench.c` | Testbench used to decide functional correctness |
| `Key.txt`, `PT.txt` | Test vectors driving the testbench |
| `compile_csv*.py` | Evaluation script: compile → simulate → synthesise → write `stats.csv` |
| `stats.csv` | Per-completion results; **all tables and figures in the paper derive from these** |
| `completions_<model>/` | `completion_<L\|M\|H>_t<temperature>_<id>` — one file per completion |

Models are `llm` (the fine-tuned `fine-tuned-codegen-6B-Verilog` baseline), `gpt3.5`,
`gpt4`, `claude`, `llama`, `mistral` and `gemini`. Problem 25 is a C task and so omits
the Verilog-only fine-tuned model.

### `stats.csv` columns

`file_name`, `model_type`, `prompt_detail`, `temp`, `completion_id`, `compiled`,
`passed_bench`, `correct`, `first CT`, `Levenshtein distance`, `area`.

Problem 1 differs, since the LFSR is judged by output entropy rather than by a ciphertext
comparison: `period_low`, `entropy_low`, `period_high`, `entropy_high`.

## Reproducing the results

The evaluation harness uses shell to call external EDA tools, which must be on `PATH`:

- `vlog`, `vcom`, `vsim` — Siemens QuestaSim / ModelSim, for compilation and simulation
- `dc_shell` — Synopsys Design Compiler, for synthesis and area
- The NanGate 15nm Open Cell Library, referenced from your `.synopsys_dc.setup`

To regenerate `stats.csv` for a single task:

```sh
cd problem22 && python compile_csv_problem22.py
```

To regenerate the tables and figures from the `stats.csv` files, run `vis_stats.ipynb`
from the repository root.

## Completions

The 261,000 completions are archived separately on Zenodo:

> Tom Slooff, Subhadeep Banik, Francesco Regazzoni.
> *LLM completions for "Benchmarking Large Language Models on HDL Generation of Cryptographic Primitives"*. Zenodo, 2026. DOI: [10.5281/zenodo.22227945](https://doi.org/10.5281/zenodo.22227945)

Unpack the archives into the repository root so that each `problemN/completions_<model>/`
directory is populated, then run the scripts as described above.

## Citation

```bibtex
@inproceedings{slooff2026benchmarking,
  title     = {Benchmarking Large Language Models on HDL Generation of Cryptographic Primitives},
  author    = {Slooff, Tom and Banik, Subhadeep and Regazzoni, Francesco},
  booktitle = {IEEE International Conference on Omni-Layer Intelligent Systems},
  year      = {2026},
  publisher = {IEEE},
  doi       = {TODO},
}
```

## License

Everything in this repository — the evaluation scripts, the reference implementations,
the prompts, the test vectors, the `stats.csv` result files and the figures — is released
under the MIT License. See [LICENSE](LICENSE).

The completions hosted on Zenodo are covered by the license stated on that record.

If you use this benchmark, please cite the paper above.
