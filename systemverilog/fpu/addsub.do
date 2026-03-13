onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /fpu_tb/fpu_top/ab_exp_diff
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/ab_shift_amount
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_mantissa
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_mantissa_shifted
add wave -noupdate -radix binary /fpu_tb/fpu_top/a_mantissa_adjusted
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/a_exp
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/a_exp_adjusted
add wave -noupdate /fpu_tb/fpu_top/a_sign
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_mantissa
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_mantissa_shifted
add wave -noupdate -radix binary /fpu_tb/fpu_top/b_mantissa_adjusted
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/b_exp
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/b_exp_adjusted
add wave -noupdate /fpu_tb/fpu_top/b_sign
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_m_addsub_prenorm
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_m_addsub_abs
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/zcount_addsub
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_m_addsub_normalized
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_m_addsub_rounded
add wave -noupdate -radix binary /fpu_tb/fpu_top/result_m_addsub_renorm
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/result_e_addsub_prenorm
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/result_e_addsub
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/result_e_addsub_normalized
add wave -noupdate -radix unsigned /fpu_tb/fpu_top/result_e_addsub_renorm
add wave -noupdate /fpu_tb/fpu_top/result_s_addsub
add wave -noupdate -radix binary -childformat {{{/fpu_tb/fpu_top/result_m_addsub[22]} -radix binary} {{/fpu_tb/fpu_top/result_m_addsub[21]} -radix binary} {{/fpu_tb/fpu_top/result_m_addsub[20]} -radix binary} {{/fpu_tb/fpu_top/result_m_addsub[19]} -radix binary} {{/fpu_tb/fpu_top/result_m_addsub[18]} -radix binary} {{/fpu_tb/fpu_top/result_m_addsub[17]} -radix binary} {{/fpu_tb/fpu_top/result_m_addsub[16]} -radix binary} {{/fpu_tb/fpu_top/result_m_addsub[15]} -radix binary} {{/fpu_tb/fpu_top/result_m_addsub[14]} -radix binary} {{/fpu_tb/fpu_top/result_m_addsub[13]} -radix binary} {{/fpu_tb/fpu_top/result_m_addsub[12]} -radix binary} {{/fpu_tb/fpu_top/result_m_addsub[11]} -radix binary} {{/fpu_tb/fpu_top/result_m_addsub[10]} -radix binary} {{/fpu_tb/fpu_top/result_m_addsub[9]} -radix binary} {{/fpu_tb/fpu_top/result_m_addsub[8]} -radix binary} {{/fpu_tb/fpu_top/result_m_addsub[7]} -radix binary} {{/fpu_tb/fpu_top/result_m_addsub[6]} -radix binary} {{/fpu_tb/fpu_top/result_m_addsub[5]} -radix binary} {{/fpu_tb/fpu_top/result_m_addsub[4]} -radix binary} {{/fpu_tb/fpu_top/result_m_addsub[3]} -radix binary} {{/fpu_tb/fpu_top/result_m_addsub[2]} -radix binary} {{/fpu_tb/fpu_top/result_m_addsub[1]} -radix binary} {{/fpu_tb/fpu_top/result_m_addsub[0]} -radix binary}} -subitemconfig {{/fpu_tb/fpu_top/result_m_addsub[22]} {-height 16 -radix binary} {/fpu_tb/fpu_top/result_m_addsub[21]} {-height 16 -radix binary} {/fpu_tb/fpu_top/result_m_addsub[20]} {-height 16 -radix binary} {/fpu_tb/fpu_top/result_m_addsub[19]} {-height 16 -radix binary} {/fpu_tb/fpu_top/result_m_addsub[18]} {-height 16 -radix binary} {/fpu_tb/fpu_top/result_m_addsub[17]} {-height 16 -radix binary} {/fpu_tb/fpu_top/result_m_addsub[16]} {-height 16 -radix binary} {/fpu_tb/fpu_top/result_m_addsub[15]} {-height 16 -radix binary} {/fpu_tb/fpu_top/result_m_addsub[14]} {-height 16 -radix binary} {/fpu_tb/fpu_top/result_m_addsub[13]} {-height 16 -radix binary} {/fpu_tb/fpu_top/result_m_addsub[12]} {-height 16 -radix binary} {/fpu_tb/fpu_top/result_m_addsub[11]} {-height 16 -radix binary} {/fpu_tb/fpu_top/result_m_addsub[10]} {-height 16 -radix binary} {/fpu_tb/fpu_top/result_m_addsub[9]} {-height 16 -radix binary} {/fpu_tb/fpu_top/result_m_addsub[8]} {-height 16 -radix binary} {/fpu_tb/fpu_top/result_m_addsub[7]} {-height 16 -radix binary} {/fpu_tb/fpu_top/result_m_addsub[6]} {-height 16 -radix binary} {/fpu_tb/fpu_top/result_m_addsub[5]} {-height 16 -radix binary} {/fpu_tb/fpu_top/result_m_addsub[4]} {-height 16 -radix binary} {/fpu_tb/fpu_top/result_m_addsub[3]} {-height 16 -radix binary} {/fpu_tb/fpu_top/result_m_addsub[2]} {-height 16 -radix binary} {/fpu_tb/fpu_top/result_m_addsub[1]} {-height 16 -radix binary} {/fpu_tb/fpu_top/result_m_addsub[0]} {-height 16 -radix binary}} /fpu_tb/fpu_top/result_m_addsub
add wave -noupdate /fpu_tb/fpu_top/guard_bits
add wave -noupdate /fpu_tb/fpu_top/sticky_bit
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {2888 ns} 0}
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
