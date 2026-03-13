onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fpu_tb/fpu_top/arst
add wave -noupdate /fpu_tb/fpu_top/clk
add wave -noupdate -radix binary /fpu_tb/fpu_top/dividend
add wave -noupdate -radix binary /fpu_tb/fpu_top/divisor
add wave -noupdate -radix binary /fpu_tb/fpu_top/minus_divisor
add wave -noupdate /fpu_tb/fpu_top/start_operation_div_fsm
add wave -noupdate -radix binary /fpu_tb/fpu_top/quotient
add wave -noupdate -radix binary /fpu_tb/fpu_top/q
add wave -noupdate /fpu_tb/fpu_top/operation_done_div_fsm
add wave -noupdate -radix binary /fpu_tb/fpu_top/remainder_dividend
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/div_counter
add wave -noupdate /fpu_tb/fpu_top/div_shift
add wave -noupdate /fpu_tb/fpu_top/div_sub_divisor
add wave -noupdate /fpu_tb/fpu_top/div_set_a0_1
add wave -noupdate /fpu_tb/fpu_top/curr_state_div_fsm
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {84752 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 209
configure wave -valuecolwidth 486
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 45
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ns} {95288 ns}
