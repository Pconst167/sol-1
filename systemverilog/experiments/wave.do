onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /comb_divider_tb/a
add wave -noupdate -radix unsigned /comb_divider_tb/b
add wave -noupdate -radix unsigned /comb_divider_tb/quotient
add wave -noupdate -radix unsigned /comb_divider_tb/remainder
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3119 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
