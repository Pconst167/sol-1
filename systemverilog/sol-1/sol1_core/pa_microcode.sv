package pa_microcode;  
  parameter CONTROL_WORD_WIDTH = 8 * 15;
  parameter CYCLES_PER_INSTRUCTION = 64;
  parameter NBR_INSTRUCTIONS = 256;

  parameter bit [13:0] FETCH_U_ADDR = 16;
  parameter bit [13:0] TRAP_U_ADDR = 32;
  
  parameter byte unsigned base_u_rom0 = 0 * 8;
  parameter byte unsigned base_u_rom1 = 1 * 8;
  parameter byte unsigned base_u_rom2 = 2 * 8;
  parameter byte unsigned base_u_rom3 = 3 * 8;
  parameter byte unsigned base_u_rom4 = 4 * 8;
  parameter byte unsigned base_u_rom5 = 5 * 8;
  parameter byte unsigned base_u_rom6 = 6 * 8;
  parameter byte unsigned base_u_rom7 = 7 * 8;
  parameter byte unsigned base_u_rom8 = 8 * 8;
  parameter byte unsigned base_u_rom9 = 9 * 8;
  parameter byte unsigned base_u_rom10 = 10 * 8;
  parameter byte unsigned base_u_rom11 = 11 * 8;
  parameter byte unsigned base_u_rom12 = 12 * 8;
  parameter byte unsigned base_u_rom13 = 13 * 8;  
  
  // control word field positions
  parameter byte unsigned bitpos_typ0 = base_u_rom0 + 0;
  parameter byte unsigned bitpos_typ1 = base_u_rom0 + 1;
  parameter byte unsigned bitpos_offset_0 = base_u_rom0 + 2;
  parameter byte unsigned bitpos_offset_1 = base_u_rom0 + 3;
  parameter byte unsigned bitpos_offset_2 = base_u_rom0 + 4;
  parameter byte unsigned bitpos_offset_3 = base_u_rom0 + 5;
  parameter byte unsigned bitpos_offset_4 = base_u_rom0 + 6;
  parameter byte unsigned bitpos_offset_5 = base_u_rom0 + 7;
  
  parameter byte unsigned bitpos_offset_6 = base_u_rom1 + 0;
  parameter byte unsigned bitpos_cond_invert = base_u_rom1 + 1;
  parameter byte unsigned bitpos_cond_flag_src = base_u_rom1 + 2;
  parameter byte unsigned bitpos_cond_sel_0 = base_u_rom1 + 3;
  parameter byte unsigned bitpos_cond_sel_1 = base_u_rom1 + 4;
  parameter byte unsigned bitpos_cond_sel_2 = base_u_rom1 + 5;
  parameter byte unsigned bitpos_cond_sel_3 = base_u_rom1 + 6;
  parameter byte unsigned bitpos_escape = base_u_rom1 + 7;

  parameter byte unsigned bitpos_u_zf_in_src_0 = base_u_rom2 + 0;
  parameter byte unsigned bitpos_u_zf_in_src_1 = base_u_rom2 + 1;
  parameter byte unsigned bitpos_u_cf_in_src_0 = base_u_rom2 + 2;
  parameter byte unsigned bitpos_u_cf_in_src_1 = base_u_rom2 + 3;
  parameter byte unsigned bitpos_u_sf_in_src = base_u_rom2 + 4;
  parameter byte unsigned bitpos_u_of_in_src = base_u_rom2 + 5;
  parameter byte unsigned bitpos_ir_wrt = base_u_rom2 + 6;
  parameter byte unsigned bitpos_status_wrt = base_u_rom2 + 7;

  parameter byte unsigned bitpos_shift_src_0 = base_u_rom3 + 0;
  parameter byte unsigned bitpos_shift_src_1 = base_u_rom3 + 1;
  parameter byte unsigned bitpos_shift_src_2 = base_u_rom3 + 2;
  parameter byte unsigned bitpos_zbus_src_0 = base_u_rom3 + 3;
  parameter byte unsigned bitpos_zbus_src_1 = base_u_rom3 + 4;
  parameter byte unsigned bitpos_alu_a_src_0	= base_u_rom3 + 5;	
  parameter byte unsigned bitpos_alu_a_src_1	= base_u_rom3 + 6;	
  parameter byte unsigned bitpos_alu_a_src_2 = base_u_rom3 + 7; 

  parameter byte unsigned bitpos_alu_a_src_3 = base_u_rom4 + 0;
  parameter byte unsigned bitpos_alu_a_src_4 = base_u_rom4 + 1;
  parameter byte unsigned bitpos_alu_a_src_5 = base_u_rom4 + 2;
  parameter byte unsigned bitpos_alu_op_0 = base_u_rom4 + 3;
  parameter byte unsigned bitpos_alu_op_1 = base_u_rom4 + 4;
  parameter byte unsigned bitpos_alu_op_2 = base_u_rom4 + 5;
  parameter byte unsigned bitpos_alu_op_3 = base_u_rom4 + 6;
  parameter byte unsigned bitpos_alu_mode = base_u_rom4 + 7;

  parameter byte unsigned bitpos_alu_cf_in_src_0 = base_u_rom5 + 0;
  parameter byte unsigned bitpos_alu_cf_in_src_1 = base_u_rom5 + 1;
  parameter byte unsigned bitpos_alu_cf_in_invert = base_u_rom5 + 2;
  parameter byte unsigned bitpos_zf_in_src_0 = base_u_rom5 + 3;
  parameter byte unsigned bitpos_zf_in_src_1 = base_u_rom5 + 4;
  parameter byte unsigned bitpos_alu_cf_out_invert = base_u_rom5 + 5;
  parameter byte unsigned bitpos_cf_in_src_0 = base_u_rom5 + 6;
  parameter byte unsigned bitpos_cf_in_src_1 = base_u_rom5 + 7;

  parameter byte unsigned bitpos_cf_in_src_2 = base_u_rom6 + 0;
  parameter byte unsigned bitpos_sf_in_src_0 = base_u_rom6 + 1;
  parameter byte unsigned bitpos_sf_in_src_1 = base_u_rom6 + 2;
  parameter byte unsigned bitpos_of_in_src_0 = base_u_rom6 + 3;
  parameter byte unsigned bitpos_of_in_src_1 = base_u_rom6 + 4;
  parameter byte unsigned bitpos_of_in_src_2 = base_u_rom6 + 5;
  parameter byte unsigned bitpos_rd = base_u_rom6 + 6;
  parameter byte unsigned bitpos_wr = base_u_rom6 + 7;

  parameter byte unsigned bitpos_alu_b_src_0 = base_u_rom7 + 0;
  parameter byte unsigned bitpos_alu_b_src_1 = base_u_rom7 + 1;
  parameter byte unsigned bitpos_alu_b_src_2 = base_u_rom7 + 2;
  parameter byte unsigned bitpos_display_reg_load = base_u_rom7 + 3; // used during fetch to select and load register display
  parameter byte unsigned bitpos_dl_wrt = base_u_rom7 + 4;
  parameter byte unsigned bitpos_dh_wrt = base_u_rom7 + 5;
  parameter byte unsigned bitpos_cl_wrt = base_u_rom7 + 6;
  parameter byte unsigned bitpos_ch_wrt = base_u_rom7 + 7;

  parameter byte unsigned bitpos_bl_wrt = base_u_rom8 + 0;
  parameter byte unsigned bitpos_bh_wrt = base_u_rom8 + 1;
  parameter byte unsigned bitpos_al_wrt = base_u_rom8 + 2;
  parameter byte unsigned bitpos_ah_wrt = base_u_rom8 + 3;
  parameter byte unsigned bitpos_mdr_in_src = base_u_rom8 + 4;
  parameter byte unsigned bitpos_mdr_out_src = base_u_rom8 + 5;
  parameter byte unsigned bitpos_mdr_out_en = base_u_rom8 + 6;			// must invert before sending
  parameter byte unsigned bitpos_mdr_l_wrt = base_u_rom8 + 7;			

  parameter byte unsigned bitpos_mdr_h_wrt = base_u_rom9 + 0;
  parameter byte unsigned bitpos_tdr_l_wrt = base_u_rom9 + 1;
  parameter byte unsigned bitpos_tdr_h_wrt = base_u_rom9 + 2;
  parameter byte unsigned bitpos_di_l_wrt = base_u_rom9 + 3;
  parameter byte unsigned bitpos_di_h_wrt = base_u_rom9 + 4;
  parameter byte unsigned bitpos_si_l_wrt = base_u_rom9 + 5;
  parameter byte unsigned bitpos_si_h_wrt = base_u_rom9 + 6;
  parameter byte unsigned bitpos_mar_l_wrt = base_u_rom9 + 7;

  parameter byte unsigned bitpos_mar_h_wrt = base_u_rom10 + 0;
  parameter byte unsigned bitpos_bp_l_wrt = base_u_rom10 + 1;
  parameter byte unsigned bitpos_bp_h_wrt = base_u_rom10 + 2;
  parameter byte unsigned bitpos_pc_l_wrt = base_u_rom10 + 3;
  parameter byte unsigned bitpos_pc_h_wrt = base_u_rom10 + 4;
  parameter byte unsigned bitpos_sp_l_wrt = base_u_rom10 + 5;
  parameter byte unsigned bitpos_sp_h_wrt = base_u_rom10 + 6;
  //parameter byte unsigned bitpos_unused = base_u_rom10 + 7;

  //parameter byte unsigned bitpos_unused = base_u_rom11 + 0;
  parameter byte unsigned bitpos_int_vector_wrt = base_u_rom11 + 1;
  parameter byte unsigned bitpos_irq_masks_wrt = base_u_rom11 + 2;		// << wrt signals are also active low, 	
  parameter byte unsigned bitpos_mar_in_src = base_u_rom11 + 3;
  parameter byte unsigned bitpos_int_ack = base_u_rom11 + 4;		//--- active high
  parameter byte unsigned bitpos_clear_all_ints = base_u_rom11 + 5;
  parameter byte unsigned bitpos_ptb_wrt = base_u_rom11 + 6;
  parameter byte unsigned bitpos_page_table_we = base_u_rom11 + 7; 

  parameter byte unsigned bitpos_mdr_to_pagetable_data_en = base_u_rom12 + 0;
  parameter byte unsigned bitpos_force_user_ptb = base_u_rom12 + 1; // --->>> goes to board as page_table_addr_source via or gate
  //parameter byte unsigned bitpos_unused = base_u_rom12 + 2;
  //parameter byte unsigned bitpos_unused = base_u_rom12 + 3;
  //parameter byte unsigned bitpos_unused = base_u_rom12 + 4;
  //parameter byte unsigned bitpos_unused = base_u_rom12 + 5;
  parameter byte unsigned bitpos_gl_wrt = base_u_rom12 + 6;
  parameter byte unsigned bitpos_gh_wrt = base_u_rom12 + 7;

  parameter byte unsigned bitpos_immy_0 = base_u_rom13 + 0;
  parameter byte unsigned bitpos_immy_1 = base_u_rom13 + 1;
  parameter byte unsigned bitpos_immy_2 = base_u_rom13 + 2;
  parameter byte unsigned bitpos_immy_3 = base_u_rom13 + 3;
  parameter byte unsigned bitpos_immy_4 = base_u_rom13 + 4;
  parameter byte unsigned bitpos_immy_5 = base_u_rom13 + 5;
  parameter byte unsigned bitpos_immy_6 = base_u_rom13 + 6;
  parameter byte unsigned bitpos_immy_7 = base_u_rom13 + 7;
 
endpackage
