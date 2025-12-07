onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /fpu_tb/test_phase
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_operand
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_operand
add wave -noupdate -radix binary /fpu_tb/fpu_top/operation
add wave -noupdate -radix binary /fpu_tb/fpu_top/ieee_packet_out
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_mantissa
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_mantissa_adjusted
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_mantissa_signed
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_exp
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_exp_adjusted
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_sign
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_mantissa
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_mantissa_adjusted
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_mantissa_signed
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_exp
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_exp_adjusted
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_sign
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_sign_mul
add wave -noupdate -radix binary /fpu_tb/fpu_top/product_pre_norm
add wave -noupdate -radix binary /fpu_tb/fpu_top/product_norm
add wave -noupdate -radix binary /fpu_tb/fpu_top/mul_m_shift_left
add wave -noupdate -radix binary /fpu_tb/fpu_top/mul_m_norm
add wave -noupdate -radix binary /fpu_tb/fpu_top/mul_m_norm2
add wave -noupdate -radix binary /fpu_tb/fpu_top/product_rounded
add wave -noupdate -radix binary /fpu_tb/fpu_top/product_renorm
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_mantissa_mul
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/mul_zcount
add wave -noupdate -radix decimal /fpu_tb/fpu_top/mul_exp_sum
add wave -noupdate -radix decimal /fpu_tb/fpu_top/mul_exp_shift1
add wave -noupdate -radix decimal /fpu_tb/fpu_top/mul_e_shift_left
add wave -noupdate -radix decimal /fpu_tb/fpu_top/mul_e_norm
add wave -noupdate -radix decimal /fpu_tb/fpu_top/mul_exp_renorm
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/result_exp_mul
add wave -noupdate -radix binary /fpu_tb/fpu_top/mul_is_subnormal
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_subnormal
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_nan
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_inf
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_pos_inf
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_neg_inf
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_zero
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_nan
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_inf
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_pos_inf
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_neg_inf
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_zero
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_subnormal
add wave -noupdate -radix binary /fpu_tb/fpu_top/zero_inf_or_inf_zero
add wave -noupdate -radix binary /fpu_tb/fpu_top/inf_or_inf
add wave -noupdate -radix binary /fpu_tb/fpu_top/zero_or_zero
add wave -noupdate -radix binary /fpu_tb/fpu_top/zero_and_zero
add wave -noupdate -radix binary /fpu_tb/fpu_top/zero_inf
add wave -noupdate -radix binary /fpu_tb/fpu_top/inf_zero
add wave -noupdate -radix binary /fpu_tb/fpu_top/nan_or_nan
add wave -noupdate -radix binary /fpu_tb/fpu_top/nan_inf_or_inf_nan
add wave -noupdate -radix binary /fpu_tb/fpu_top/zero_nan_or_nan_zero
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {364 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 301
configure wave -valuecolwidth 489
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {25200 ns}
