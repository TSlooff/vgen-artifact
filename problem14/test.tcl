sh rm -rf WORK/*
sh rm -rf AN.DB/*
sh rm -rf csrc/*
remove_design -all


define_design_lib WORK -path ./WORK

analyze -library WORK -format verilog {{
completions_gpt3.5/completion_H_t1.0_59.v
}}

analyze -library WORK -format verilog {{
aes_no_round.v
}}

elaborate {top_module} -library WORK



compile

change_selection -name global -replace [get_timing_paths -delay_type max -nworst 1 -max_paths 1 -include_hierarchical_pins]

uplevel #0 {{ report_area -hierarchy > area.txt}}

exit
exit
