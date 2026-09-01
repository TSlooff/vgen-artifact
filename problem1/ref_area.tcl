sh rm -rf WORK/*
sh rm -rf AN.DB/*
sh rm -rf csrc/*
remove_design -all


define_design_lib WORK -path ./WORK
analyze -library WORK -format sverilog {
ref.sv
}

elaborate lfsr_16bit -library WORK


create_clock -name "clk" -period 10 -waveform { 0 5  }  { clk }

compile

change_selection -name global -replace [get_timing_paths -delay_type max -nworst 1 -max_paths 1 -include_hierarchical_pins]

uplevel #0 { report_area -hierarchy > area.txt}

exit
exit
