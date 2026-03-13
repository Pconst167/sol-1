onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fpu_tb/fpu_top/arst
add wave -noupdate /fpu_tb/fpu_top/clk
add wave -noupdate /fpu_tb/fpu_top/cmd_end
add wave -noupdate /fpu_tb/fpu_top/busy
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_mantissa
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_mantissa_adjusted
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/a_exp
add wave -noupdate /fpu_tb/fpu_top/a_sign
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_mantissa
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_mantissa_adjusted
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/b_exp
add wave -noupdate /fpu_tb/fpu_top/b_sign
add wave -noupdate -radix decimal /fpu_tb/fpu_top/ab_exp_diff
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/a_exp_adjusted
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/b_exp_adjusted
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_mantissa_shifted
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_mantissa_adjusted
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_sticky_bit
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_mantissa_shifted
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_mantissa_adjusted
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_sticky_bit
add wave -noupdate -radix decimal /fpu_tb/fpu_top/ab_exp_diff
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/ab_shift_amount
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_mantissa_mul
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/result_exp_mul
add wave -noupdate /fpu_tb/fpu_top/result_sign_mul
add wave -noupdate /fpu_tb/fpu_top/clk
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_mantissa_div
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/result_exp_div
add wave -noupdate /fpu_tb/fpu_top/result_sign_div
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/sqrt_counter
add wave -noupdate /fpu_tb/fpu_top/start_operation_sqrt_fsm
add wave -noupdate /fpu_tb/fpu_top/operation_done_sqrt_fsm
add wave -noupdate /fpu_tb/fpu_top/operation
add wave -noupdate /fpu_tb/fpu_top/start_operation_ar_fsm
add wave -noupdate /fpu_tb/fpu_top/operation_done_ar_fsm
add wave -noupdate /fpu_tb/fpu_top/clk
add wave -noupdate /fpu_tb/fpu_top/curr_state_main_fsm
add wave -noupdate /fpu_tb/fpu_top/curr_state_arith_fsm
add wave -noupdate /fpu_tb/fpu_top/curr_state_sqrt_fsm
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_m_addsub_prenorm
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_m_addsub_abs
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_m_addsub
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/result_e_addsub_prenorm
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/result_e_addsub
add wave -noupdate /fpu_tb/fpu_top/result_s_addsub
add wave -noupdate /fpu_tb/fpu_top/zcount_addsub
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_m_addsub_normalized
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/result_e_addsub_normalized
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_m_addsub_rounded
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_m_addsub_renorm
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/result_e_addsub_renorm
add wave -noupdate /fpu_tb/fpu_top/guard_bits
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {3334 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 245
configure wave -valuecolwidth 331
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
WaveRestoreZoom {0 ns} {5513 ns}
