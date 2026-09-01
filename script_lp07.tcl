sh rm -rf WORK/*
sh rm -rf AN.DB/*
sh rm -rf csrc/*
remove_design -all


define_design_lib WORK -path ./WORK
analyze -library WORK -format verilog {

}

elaborate top-level -library WORK


create_clock -name "clock" -period 10 -waveform { 0 5  }  { clock  }

compile

change_selection -name global -replace [get_timing_paths -delay_type max -nworst 1 -max_paths 1 -include_hierarchical_pins]

uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 4 -sort_by group > timing_lp07.txt}

uplevel #0 { report_area -hierarchy > area_lp07.txt}
  
exit
exit 
