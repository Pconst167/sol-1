onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fpu_tb/fpu_top/arst
add wave -noupdate /fpu_tb/fpu_top/clk
add wave -noupdate /fpu_tb/fpu_top/operation
add wave -noupdate /fpu_tb/fpu_top/operand_a
add wave -noupdate -radix hexadecimal /fpu_tb/fpu_top/operand_b
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_mantissa
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_mantissa
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/a_exp
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/b_exp
add wave -noupdate -radix decimal /fpu_tb/fpu_top/aexp_no_bias
add wave -noupdate -radix decimal /fpu_tb/fpu_top/bexp_no_bias
add wave -noupdate -radix decimal /fpu_tb/fpu_top/aexp_after_adjust
add wave -noupdate -radix decimal /fpu_tb/fpu_top/bexp_after_adjust
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_mantissa_after_adjust
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_mantissa_after_adjust
add wave -noupdate /fpu_tb/fpu_top/clk
add wave -noupdate /fpu_tb/fpu_top/start_operation_div_fsm
add wave -noupdate /fpu_tb/fpu_top/operation_done_div_fsm
add wave -noupdate /fpu_tb/fpu_top/curr_state_div_fsm
add wave -noupdate -radix binary /fpu_tb/fpu_top/divisor
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/div_counter
add wave -noupdate /fpu_tb/fpu_top/div_carry
add wave -noupdate /fpu_tb/fpu_top/div_shift
add wave -noupdate /fpu_tb/fpu_top/div_sub_divisor
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_mantissa_division
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/result_exp_division
add wave -noupdate -radix binary /fpu_tb/fpu_top/remainder_dividend
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_ieee_packet
add wave -noupdate -radix hexadecimal /fpu_tb/fpu_top/result_ieee_packet
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {65926 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 245
configure wave -valuecolwidth 495
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
WaveRestoreZoom {0 ns} {70350 ns}
