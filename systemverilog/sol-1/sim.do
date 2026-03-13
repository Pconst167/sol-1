onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sol1_top/arst
add wave -noupdate /sol1_top/stop_clk_req
add wave -noupdate /sol1_top/u_clock/stop_clk
add wave -noupdate /sol1_top/clk
add wave -noupdate /sol1_top/pins_irq_req
add wave -noupdate /sol1_top/dma_ack
add wave -noupdate /sol1_top/dma_req
add wave -noupdate /sol1_top/rd
add wave -noupdate /sol1_top/wr
add wave -noupdate /sol1_top/mem_io
add wave -noupdate /sol1_top/address_bus
add wave -noupdate /sol1_top/data_bus
add wave -noupdate -divider {== IDE ==}
add wave -noupdate /sol1_top/u_ide/address
add wave -noupdate /sol1_top/u_ide/arst
add wave -noupdate -radix unsigned /sol1_top/u_ide/byteCounter
add wave -noupdate /sol1_top/u_ide/ce_n
add wave -noupdate /sol1_top/u_ide/command
add wave -noupdate /sol1_top/u_ide/currentState
add wave -noupdate /sol1_top/u_ide/nextState
add wave -noupdate /sol1_top/u_ide/data_in
add wave -noupdate /sol1_top/u_ide/data_out
add wave -noupdate /sol1_top/u_ide/LBA
add wave -noupdate /sol1_top/u_ide/mem
add wave -noupdate /sol1_top/u_ide/oe_n
add wave -noupdate /sol1_top/u_ide/registers
add wave -noupdate -radix unsigned -childformat {{{/sol1_top/u_ide/status[7]} -radix unsigned} {{/sol1_top/u_ide/status[6]} -radix unsigned} {{/sol1_top/u_ide/status[5]} -radix unsigned} {{/sol1_top/u_ide/status[4]} -radix unsigned} {{/sol1_top/u_ide/status[3]} -radix unsigned} {{/sol1_top/u_ide/status[2]} -radix unsigned} {{/sol1_top/u_ide/status[1]} -radix unsigned} {{/sol1_top/u_ide/status[0]} -radix unsigned}} -subitemconfig {{/sol1_top/u_ide/status[7]} {-height 14 -radix unsigned} {/sol1_top/u_ide/status[6]} {-height 14 -radix unsigned} {/sol1_top/u_ide/status[5]} {-height 14 -radix unsigned} {/sol1_top/u_ide/status[4]} {-height 14 -radix unsigned} {/sol1_top/u_ide/status[3]} {-height 14 -radix unsigned} {/sol1_top/u_ide/status[2]} {-height 14 -radix unsigned} {/sol1_top/u_ide/status[1]} {-height 14 -radix unsigned} {/sol1_top/u_ide/status[0]} {-height 14 -radix unsigned}} /sol1_top/u_ide/status
add wave -noupdate /sol1_top/u_ide/we_n
add wave -noupdate -divider {== CS ==}
add wave -noupdate /sol1_top/bios_config_cs
add wave -noupdate /sol1_top/bios_ram_cs
add wave -noupdate /sol1_top/bios_rom_cs
add wave -noupdate /sol1_top/ide_cs
add wave -noupdate /sol1_top/pio0_cs
add wave -noupdate /sol1_top/pio1_cs
add wave -noupdate /sol1_top/rtc_cs
add wave -noupdate /sol1_top/timer_cs
add wave -noupdate /sol1_top/uart0_cs
add wave -noupdate /sol1_top/uart1_cs
add wave -noupdate -divider {== MICROCODE ==}
add wave -noupdate /sol1_top/u_cpu_top/ctrl_cond_flag_src
add wave -noupdate /sol1_top/u_cpu_top/ctrl_cond_invert
add wave -noupdate /sol1_top/u_cpu_top/ctrl_cond_sel
add wave -noupdate /sol1_top/u_cpu_top/u_microcode_sequencer/ir
add wave -noupdate /sol1_top/u_cpu_top/u_microcode_sequencer/u_address
add wave -noupdate /sol1_top/u_cpu_top/u_microcode_sequencer/u_flags
add wave -noupdate /sol1_top/u_cpu_top/u_microcode_sequencer/any_interruption
add wave -noupdate /sol1_top/u_cpu_top/u_microcode_sequencer/final_condition
add wave -noupdate /sol1_top/u_cpu_top/u_microcode_sequencer/int_pending
add wave -noupdate -divider {== CPU TOP ==}
add wave -noupdate /sol1_top/u_cpu_top/cpu_flags
add wave -noupdate /sol1_top/u_cpu_top/cpu_status
add wave -noupdate /sol1_top/u_cpu_top/bus_tristate
add wave -noupdate /sol1_top/u_cpu_top/mdrl
add wave -noupdate /sol1_top/u_cpu_top/mdrh
add wave -noupdate /sol1_top/u_cpu_top/marl
add wave -noupdate /sol1_top/u_cpu_top/marh
add wave -noupdate /sol1_top/u_cpu_top/pcl
add wave -noupdate /sol1_top/u_cpu_top/pch
add wave -noupdate /sol1_top/u_cpu_top/ptb
add wave -noupdate /sol1_top/u_cpu_top/spl
add wave -noupdate /sol1_top/u_cpu_top/sph
add wave -noupdate /sol1_top/u_cpu_top/sspl
add wave -noupdate /sol1_top/u_cpu_top/ssph
add wave -noupdate /sol1_top/u_cpu_top/al
add wave -noupdate /sol1_top/u_cpu_top/ah
add wave -noupdate -divider {== ALU ==}
add wave -noupdate /sol1_top/u_cpu_top/ctrl_alu_a_src
add wave -noupdate /sol1_top/u_cpu_top/ctrl_alu_b_src
add wave -noupdate /sol1_top/u_cpu_top/ctrl_alu_cf_in_invert
add wave -noupdate /sol1_top/u_cpu_top/ctrl_alu_cf_in_src
add wave -noupdate /sol1_top/u_cpu_top/ctrl_alu_cf_out_invert
add wave -noupdate /sol1_top/u_cpu_top/ctrl_alu_mode
add wave -noupdate /sol1_top/u_cpu_top/ctrl_alu_op
add wave -noupdate /sol1_top/u_cpu_top/w_bus
add wave -noupdate /sol1_top/u_cpu_top/x_bus
add wave -noupdate /sol1_top/u_cpu_top/k_bus
add wave -noupdate /sol1_top/u_cpu_top/y_bus
add wave -noupdate /sol1_top/u_cpu_top/z_bus
add wave -noupdate /sol1_top/u_cpu_top/alu_out
add wave -noupdate /sol1_top/u_cpu_top/alu_zf
add wave -noupdate /sol1_top/u_cpu_top/alu_cf_in
add wave -noupdate /sol1_top/u_cpu_top/alu_cf_out
add wave -noupdate /sol1_top/u_cpu_top/alu_final_cf
add wave -noupdate /sol1_top/u_cpu_top/alu_of
add wave -noupdate /sol1_top/u_cpu_top/alu_sf
add wave -noupdate -divider {== REGISTERS ==}
add wave -noupdate /sol1_top/u_cpu_top/al
add wave -noupdate /sol1_top/u_cpu_top/ah
add wave -noupdate /sol1_top/u_cpu_top/bl
add wave -noupdate /sol1_top/u_cpu_top/bh
add wave -noupdate /sol1_top/u_cpu_top/bpl
add wave -noupdate /sol1_top/u_cpu_top/bph
add wave -noupdate /sol1_top/u_cpu_top/cl
add wave -noupdate /sol1_top/u_cpu_top/ch
add wave -noupdate /sol1_top/u_cpu_top/dl
add wave -noupdate /sol1_top/u_cpu_top/dh
add wave -noupdate /sol1_top/u_cpu_top/dil
add wave -noupdate /sol1_top/u_cpu_top/dih
add wave -noupdate /sol1_top/u_cpu_top/gl
add wave -noupdate /sol1_top/u_cpu_top/gh
add wave -noupdate /sol1_top/u_cpu_top/sil
add wave -noupdate /sol1_top/u_cpu_top/sih
add wave -noupdate /sol1_top/u_cpu_top/tdrl
add wave -noupdate /sol1_top/u_cpu_top/tdrh
add wave -noupdate /sol1_top/u_cpu_top/irq_clear
add wave -noupdate /sol1_top/u_cpu_top/irq_dff
add wave -noupdate /sol1_top/u_cpu_top/irq_masks
add wave -noupdate /sol1_top/u_cpu_top/irq_request
add wave -noupdate /sol1_top/u_cpu_top/irq_status
add wave -noupdate /sol1_top/u_cpu_top/irq_vector
add wave -noupdate /sol1_top/u_cpu_top/mdr_to_pagetable_data
add wave -noupdate /sol1_top/u_cpu_top/pagetable_addr_source
add wave -noupdate -divider {== CONTROL ==}
add wave -noupdate /sol1_top/u_cpu_top/ctrl_ah_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_al_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_bh_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_bl_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_bp_h_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_bp_l_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_cf_in_src
add wave -noupdate /sol1_top/u_cpu_top/ctrl_ch_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_cl_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_clear_all_ints
add wave -noupdate /sol1_top/u_cpu_top/ctrl_cond_flag_src
add wave -noupdate /sol1_top/u_cpu_top/ctrl_cond_invert
add wave -noupdate -expand -subitemconfig {{/sol1_top/u_cpu_top/ctrl_cond_sel[3]} {-height 14} {/sol1_top/u_cpu_top/ctrl_cond_sel[2]} {-height 14} {/sol1_top/u_cpu_top/ctrl_cond_sel[1]} {-height 14} {/sol1_top/u_cpu_top/ctrl_cond_sel[0]} {-height 14}} /sol1_top/u_cpu_top/ctrl_cond_sel
add wave -noupdate /sol1_top/u_cpu_top/ctrl_dh_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_di_h_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_di_l_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_display_reg_load
add wave -noupdate /sol1_top/u_cpu_top/ctrl_dl_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_escape
add wave -noupdate /sol1_top/u_cpu_top/ctrl_force_user_ptb
add wave -noupdate /sol1_top/u_cpu_top/ctrl_gh_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_gl_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_immy
add wave -noupdate /sol1_top/u_cpu_top/ctrl_int_ack
add wave -noupdate /sol1_top/u_cpu_top/ctrl_int_vector_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_ir_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_irq_masks_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_mar_h_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_mar_in_src
add wave -noupdate /sol1_top/u_cpu_top/ctrl_mar_l_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_mdr_h_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_mdr_in_src
add wave -noupdate /sol1_top/u_cpu_top/ctrl_mdr_l_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_mdr_out_en
add wave -noupdate /sol1_top/u_cpu_top/ctrl_mdr_out_src
add wave -noupdate /sol1_top/u_cpu_top/ctrl_mdr_to_pagetable_data_en
add wave -noupdate /sol1_top/u_cpu_top/ctrl_of_in_src
add wave -noupdate /sol1_top/u_cpu_top/ctrl_offset
add wave -noupdate /sol1_top/u_cpu_top/ctrl_page_table_we
add wave -noupdate /sol1_top/u_cpu_top/ctrl_pc_h_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_pc_l_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_ptb_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_rd
add wave -noupdate /sol1_top/u_cpu_top/ctrl_sf_in_src
add wave -noupdate /sol1_top/u_cpu_top/ctrl_shift_src
add wave -noupdate /sol1_top/u_cpu_top/ctrl_si_h_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_si_l_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_sp_h_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_sp_l_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_status_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_tdr_h_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_tdr_l_wrt
add wave -noupdate /sol1_top/u_cpu_top/ctrl_typ
add wave -noupdate /sol1_top/u_cpu_top/ctrl_u_cf_in_src
add wave -noupdate /sol1_top/u_cpu_top/ctrl_u_of_in_src
add wave -noupdate /sol1_top/u_cpu_top/ctrl_u_sf_in_src
add wave -noupdate /sol1_top/u_cpu_top/ctrl_u_zf_in_src
add wave -noupdate /sol1_top/u_cpu_top/ctrl_wr
add wave -noupdate /sol1_top/u_cpu_top/ctrl_zbus_src
add wave -noupdate /sol1_top/u_cpu_top/ctrl_zf_in_src
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {76409582 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 190
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 6
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {76409298 ns} {76412336 ns}
bookmark add wave bookmark0 {{8339320171 ps} {8349290586 ps}} 16
bookmark add wave bookmark1 {{8307101692 ps} {8389800233 ps}} 0
bookmark add wave bookmark2 {{27041948331 ps} {27046366383 ps}} 24
