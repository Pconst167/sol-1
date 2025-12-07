onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fpu_tb/fpu_top/int_in
add wave -noupdate /fpu_tb/fpu_top/fp_out
add wave -noupdate /fpu_tb/fpu_top/sign_in
add wave -noupdate /fpu_tb/fpu_top/exp_in
add wave -noupdate /fpu_tb/fpu_top/mantissa_in
add wave -noupdate /fpu_tb/fpu_top/leading_zeroes
add wave -noupdate /fpu_tb/fpu_top/one_over_255
add wave -noupdate /fpu_tb/fpu_top/error
add wave -noupdate /fpu_tb/fpu_top/m1
add wave -noupdate /fpu_tb/fpu_top/m2
add wave -noupdate /fpu_tb/fpu_top/result_mantissa
add wave -noupdate /fpu_tb/fpu_top/result_exp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1926 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 121
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
WaveRestoreZoom {0 ns} {10500 ns}
