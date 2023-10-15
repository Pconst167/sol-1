module cpu_top(
  input logic arst,
  input logic clk,
  //input logic [7:0] data_bus,
  input logic [7:0] pins_irq_req,
  input logic dma_req,
  input logic pin_wait,
  input logic ext_input,
  
  inout logic [7:0] data_bus,
  output logic [21:0] address_bus,
  //output logic [7:0] data_bus_out,
  output logic rd,
  output logic wr,
  output logic mem_io,
  output logic halt,
  output logic dma_ack
);
  import pa_cpu::*; 

// General registers
  logic [7:0] ah, al;
  logic [7:0] bh, bl;
  logic [7:0] ch, cl;
  logic [7:0] dh, dl;
  logic [7:0] gh, gl;
  
// System registers
  logic [7:0] ir;
  logic [7:0] pch, pcl;
  logic [7:0] ptb;
  logic [7:0] cpu_status;
  logic [7:0] cpu_flags;
  logic [7:0] irq_masks;
  logic [7:0] irq_status;
  logic [7:0] irq_vector;
  logic [7:0] irq_clear;

  logic status_dma_ack;
  logic status_irq_en;
  logic status_mode;
  logic status_paging_en;
  logic status_halt;
  logic status_displayreg_load;
  logic status_dir;

// Special registers
  logic [7:0] sph, spl;
  logic [7:0] ssph, sspl;
  logic [7:0] bph, bpl;
  logic [7:0] sih, sil;
  logic [7:0] dih, dil;
  logic [7:0] marh, marl;
  logic [7:0] mdrh, mdrl;
  logic [7:0] tdrh, tdrl;
  
// Buses
  logic [7:0] x_bus;
  logic [7:0] w_bus;
  logic [7:0] y_bus; 
  logic [7:0] k_bus;
  logic [7:0] z_bus; 

// ALU
  logic [7:0] alu_out;
  logic alu_zf;
  logic alu_cf_out;
  logic alu_sf;
  logic alu_of;
  logic alu_final_cf;
  logic [7:0] u_flags;
  logic alu_cf_in;
  logic irq_request;
// IRQ requests after passing through their corresponding DFFs
  logic [7:0] irq_dff;
  
// Control word fields
  logic [1:0] ctrl_typ;
  logic [6:0] ctrl_offset;
  logic ctrl_cond_invert;
  logic ctrl_cond_flag_src;
  logic [3:0] ctrl_cond_sel;
  logic ctrl_escape;
  logic [1:0] ctrl_u_zf_in_src;
  logic [1:0] ctrl_u_cf_in_src;
  logic ctrl_u_sf_in_src;
  logic ctrl_u_of_in_src;
  logic ctrl_ir_wrt;
  logic ctrl_status_wrt;
  logic [2:0] ctrl_shift_src;
  logic [1:0] ctrl_zbus_src;
  logic [5:0] ctrl_alu_a_src;
  logic [3:0] ctrl_alu_op;
  logic ctrl_alu_mode;
  logic [1:0] ctrl_alu_cf_in_src;
  logic ctrl_alu_cf_in_invert;
  logic ctrl_alu_cf_out_invert;
  logic [1:0] ctrl_zf_in_src;
  logic [2:0] ctrl_cf_in_src;
  logic [1:0] ctrl_sf_in_src;
  logic [2:0] ctrl_of_in_src;
  logic ctrl_rd;
  logic ctrl_wr;
  logic [2:0] ctrl_alu_b_src;
  logic ctrl_display_reg_load; // used during fetch to select and load register display
  logic ctrl_dl_wrt;
  logic ctrl_dh_wrt;
  logic ctrl_cl_wrt;
  logic ctrl_ch_wrt;
  logic ctrl_bl_wrt;
  logic ctrl_bh_wrt;
  logic ctrl_al_wrt;
  logic ctrl_ah_wrt;
  logic ctrl_mdr_in_src;
  logic ctrl_mdr_out_src;
  logic ctrl_mdr_out_en;
  logic ctrl_mdr_l_wrt;			
  logic ctrl_mdr_h_wrt;
  logic ctrl_tdr_l_wrt;
  logic ctrl_tdr_h_wrt;
  logic ctrl_di_l_wrt;
  logic ctrl_di_h_wrt;
  logic ctrl_si_l_wrt;
  logic ctrl_si_h_wrt;
  logic ctrl_mar_l_wrt;
  logic ctrl_mar_h_wrt;
  logic ctrl_bp_l_wrt;
  logic ctrl_bp_h_wrt;
  logic ctrl_pc_l_wrt;
  logic ctrl_pc_h_wrt;
  logic ctrl_sp_l_wrt;
  logic ctrl_sp_h_wrt;
  logic ctrl_gl_wrt;
  logic ctrl_gh_wrt;
  logic ctrl_int_vector_wrt;
  logic ctrl_irq_masks_wrt;		// wrt signals are also active low
  logic ctrl_mar_in_src;
  logic ctrl_int_ack;		      // active high
  logic ctrl_clear_all_ints;
  logic ctrl_ptb_wrt;
  logic ctrl_page_table_we; 
  logic ctrl_mdr_to_pagetable_data_en;
  logic ctrl_force_user_ptb;   // goes to board as page_table_addr_source via or gate
  logic [7:0] ctrl_immy;

// Derived signals
  logic pagetable_addr_source;
  logic bus_tristate;
  logic int_pending;

// Nets
  wire logic [15:0] mdr_to_pagetable_data;
  wire logic bus_rd;
  wire logic bus_wr;
  wire logic bus_mem_io;

  assign rd = ~bus_rd;
  assign wr = ~bus_wr;
  assign mem_io = bus_mem_io;
  assign halt = status_halt;
  assign dma_ack = status_dma_ack;

  assign status_dma_ack         = cpu_status[bitpos_cpu_status_dma_ack];
  assign status_irq_en          = cpu_status[bitpos_cpu_status_irq_en];
  assign status_mode            = cpu_status[bitpos_cpu_status_mode];
  assign status_paging_en       = cpu_status[bitpos_cpu_status_paging_en];
  assign status_halt            = cpu_status[bitpos_cpu_status_halt];
  assign status_displayreg_load = cpu_status[bitpos_cpu_status_displayreg_load];
  assign status_dir             = cpu_status[bitpos_cpu_status_dir];

/*************************
 Start of RTL code
**************************/

// ALU
  always_comb begin
    logic cf_muxed;
    case(ctrl_alu_cf_in_src)
      2'b00: cf_muxed = 1'b1;
      2'b01: cf_muxed = cpu_flags[1];
      2'b10: cf_muxed = u_flags[1];
      2'b11: cf_muxed = 1'b0;
    endcase
    alu_cf_in = cf_muxed ^ ctrl_alu_cf_in_invert;
  end
  alu u_alu(
    .a(x_bus),
    .b(y_bus),
    .cf_in(alu_cf_in),
    .op(ctrl_alu_op),
    .mode(ctrl_alu_mode),
    .alu_out(alu_out),
    .alu_cf_out(alu_cf_out)
  );
  assign alu_zf = ~|alu_out;
  assign alu_final_cf = ctrl_alu_cf_out_invert ^ alu_cf_out;
  assign alu_sf = z_bus[7];
  assign alu_of = (z_bus[7] ^ x_bus[7]) & ~((x_bus[7] ^ y_bus[7]) ^ ~(ctrl_alu_op[0] & ctrl_alu_op[3] & ~(ctrl_alu_op[2] | ctrl_alu_op[1])));
  
// CPU Flags
  always_ff @(posedge clk) begin
    case(ctrl_zf_in_src)
      2'b00: cpu_flags[bitpos_cpu_flags_zf] <= cpu_flags[bitpos_cpu_flags_zf];
      2'b01: cpu_flags[bitpos_cpu_flags_zf] <= alu_zf;
      2'b10: cpu_flags[bitpos_cpu_flags_zf] <= cpu_flags[bitpos_cpu_flags_zf] & alu_zf;
      2'b11: cpu_flags[bitpos_cpu_flags_zf] <= z_bus[0];
    endcase
    case(ctrl_cf_in_src)
      3'b000: cpu_flags[bitpos_cpu_flags_cf] <= cpu_flags[bitpos_cpu_flags_cf];
      3'b001: cpu_flags[bitpos_cpu_flags_cf] <= alu_final_cf;
      3'b010: cpu_flags[bitpos_cpu_flags_cf] <= alu_out[0];
      3'b011: cpu_flags[bitpos_cpu_flags_cf] <= z_bus[1];
      3'b100: cpu_flags[bitpos_cpu_flags_cf] <= alu_out[7];
      default: cpu_flags[bitpos_cpu_flags_cf] <= cpu_flags[bitpos_cpu_flags_cf];
    endcase
    case(ctrl_sf_in_src)
      2'b00: cpu_flags[bitpos_cpu_flags_sf] <= cpu_flags[bitpos_cpu_flags_sf];
      2'b01: cpu_flags[bitpos_cpu_flags_sf] <= z_bus[7];
      2'b10: cpu_flags[bitpos_cpu_flags_sf] <= 1'b0;
      2'b11: cpu_flags[bitpos_cpu_flags_sf] <= z_bus[2];
    endcase
    case(ctrl_of_in_src)
      3'b000: cpu_flags[bitpos_cpu_flags_of] <= cpu_flags[bitpos_cpu_flags_of];
      3'b001: cpu_flags[bitpos_cpu_flags_of] <= alu_of;
      3'b010: cpu_flags[bitpos_cpu_flags_of] <= z_bus[7];
      3'b011: cpu_flags[bitpos_cpu_flags_of] <= z_bus[3];
      3'b100: cpu_flags[bitpos_cpu_flags_of] <= u_flags[bitpos_cpu_flags_sf] ^ z_bus[7];
      default: cpu_flags[bitpos_cpu_flags_of] <= cpu_flags[bitpos_cpu_flags_of];
    endcase
  end

// z_bus assignments
  always_comb begin
    logic extremity_bit;
    case(ctrl_shift_src)
      3'b000: extremity_bit = 1'b0;
      3'b001: extremity_bit = u_flags[1]; // u_cf
      3'b010: extremity_bit = cpu_flags[1]; // msw cf
      3'b011: extremity_bit = alu_out[0];
      3'b100: extremity_bit = alu_out[7];
      3'b101: extremity_bit = 1'b1;
      3'b110: extremity_bit = 1'b1;
      3'b111: extremity_bit = 1'b1;
    endcase
    case(ctrl_zbus_src)
      2'b00: z_bus = alu_out;
      2'b01: z_bus = (alu_out >> 1) | {extremity_bit, 7'b000_0000};
      2'b10: z_bus = (alu_out << 1) | {7'b000_0000, extremity_bit};
      2'b11: z_bus = {8{alu_out[7]}};
    endcase
  end

// w_bus assignment
  always_comb begin
    case(ctrl_alu_a_src[4:0])
      5'b00000: w_bus = al;
      5'b00001: w_bus = ah;
      5'b00010: w_bus = bl;
      5'b00011: w_bus = bh;
      5'b00100: w_bus = cl;
      5'b00101: w_bus = ch;
      5'b00110: w_bus = dl;
      5'b00111: w_bus = dh;
      5'b01000: w_bus = spl;
      5'b01001: w_bus = sph;
      5'b01010: w_bus = bpl;
      5'b01011: w_bus = bph;
      5'b01100: w_bus = sil;
      5'b01101: w_bus = sih;
      5'b01110: w_bus = dil;
      5'b01111: w_bus = dih;
      5'b10000: w_bus = pcl;
      5'b10001: w_bus = pch;
      5'b10010: w_bus = marl;
      5'b10011: w_bus = marh;
      5'b10100: w_bus = mdrl;
      5'b10101: w_bus = mdrh;
      5'b10110: w_bus = tdrl;
      5'b10111: w_bus = tdrh;
      5'b11000: w_bus = sspl;
      5'b11001: w_bus = ssph;
      5'b11010: w_bus = irq_vector;
      5'b11011: w_bus = irq_masks;
      5'b11100: w_bus = irq_status;
      5'b11101: w_bus = '0;
      5'b11110: w_bus = '0;
      5'b11111: w_bus = '0;
    endcase
  end     

// x_bus assignment
  always_comb begin
    if(ctrl_alu_a_src[5] == 1'b0) begin
      x_bus = w_bus;
    end
    else begin
      case(ctrl_alu_a_src[1:0])
        2'b00: x_bus = cpu_flags;
        2'b01: x_bus = cpu_status;
        2'b10: x_bus = gl;
        2'b11: x_bus = gh;
      endcase
    end
  end
  
// k_bus assignment
  always_comb begin
    case(ctrl_alu_b_src[1:0])
      2'b00: k_bus = mdrl;
      2'b01: k_bus = mdrh;
      2'b10: k_bus = tdrl;
      2'b11: k_bus = tdrh;
    endcase
  end

// y_bus assignment
  always_comb begin
    if(ctrl_alu_b_src[2] == 1'b0) begin
      y_bus = ctrl_immy;
    end
    else begin
      y_bus = k_bus;
    end
  end

// z_bus to Registers Block
  always_ff @(posedge clk) begin
    if(ctrl_al_wrt == 1'b0) al <= z_bus;
    if(ctrl_ah_wrt == 1'b0) ah <= z_bus;
    if(ctrl_bl_wrt == 1'b0) bl <= z_bus;
    if(ctrl_bh_wrt == 1'b0) bh <= z_bus;
    if(ctrl_cl_wrt == 1'b0) cl <= z_bus;
    if(ctrl_ch_wrt == 1'b0) ch <= z_bus;
    if(ctrl_dl_wrt == 1'b0) dl <= z_bus;
    if(ctrl_dh_wrt == 1'b0) dh <= z_bus;
    if(ctrl_gl_wrt == 1'b0) gl <= z_bus;
    if(ctrl_gh_wrt == 1'b0) gh <= z_bus;

    if(ctrl_tdr_l_wrt == 1'b0) tdrl <= z_bus;
    if(ctrl_tdr_h_wrt == 1'b0) tdrh <= z_bus;
    if(ctrl_di_l_wrt == 1'b0) dil <= z_bus;
    if(ctrl_di_h_wrt == 1'b0) dih <= z_bus;
    if(ctrl_si_l_wrt == 1'b0) sil <= z_bus;
    if(ctrl_si_h_wrt == 1'b0) sih <= z_bus;
    if(ctrl_bp_l_wrt == 1'b0) bpl <= z_bus;
    if(ctrl_bp_h_wrt == 1'b0) bph <= z_bus;
    if(ctrl_sp_l_wrt == 1'b0) spl <= z_bus;
    if(ctrl_sp_h_wrt == 1'b0) sph <= z_bus;
    if(ctrl_pc_l_wrt == 1'b0) pcl <= z_bus;
    if(ctrl_pc_h_wrt == 1'b0) pch <= z_bus;
    if(ctrl_status_wrt == 1'b0) cpu_status <= z_bus;
    if(ctrl_irq_masks_wrt == 1'b0) irq_masks <= z_bus;
    if(ctrl_sp_l_wrt == 1'b0 && status_mode == 1'b0) sspl <= z_bus;
    if(ctrl_sp_h_wrt == 1'b0 && status_mode == 1'b0) ssph <= z_bus;

    if(ctrl_ir_wrt == 1'b0) ir <= data_bus;
    if(ctrl_mar_l_wrt == 1'b0) marl <= ctrl_mar_in_src ? pcl : z_bus;
    if(ctrl_mar_h_wrt == 1'b0) marh <= ctrl_mar_in_src ? pch : z_bus;
    if(ctrl_mdr_l_wrt == 1'b0) mdrl <= ctrl_mdr_in_src ? data_bus : z_bus;
    if(ctrl_mdr_h_wrt == 1'b0) mdrh <= ctrl_mdr_in_src ? data_bus : z_bus;

    if(ctrl_ptb_wrt == 1'b0) ptb <= z_bus;
  end

// Page Table
  assign pagetable_addr_source = ctrl_force_user_ptb || status_mode;
  assign mdr_to_pagetable_data = ctrl_mdr_to_pagetable_data_en ? {mdrh, mdrl} : 'z;
  memory #(PAGETABLE_RAM_SIZE) u_pagetable_low(
    .ce_n(1'b0),
    .oe_n(ctrl_mdr_to_pagetable_data_en),
    .we_n(~ctrl_page_table_we),
    .address({pagetable_addr_source ? ptb : 8'h00, marh[7:3]}),
    .data_in(mdr_to_pagetable_data[7:0]),
    .data_out(mdr_to_pagetable_data[7:0])    
  );
  memory #(PAGETABLE_RAM_SIZE) u_pagetable_high(
    .ce_n(1'b0),
    .oe_n(ctrl_mdr_to_pagetable_data_en),
    .we_n(~ctrl_page_table_we),
    .address({pagetable_addr_source ? ptb : 8'h00, marh[7:3]}),
    .data_in(mdr_to_pagetable_data[15:8]),
    .data_out(mdr_to_pagetable_data[15:8])    
  );
  assign bus_tristate = status_dma_ack || status_halt;
  assign address_bus = bus_tristate ? 'z : status_paging_en ? {mdr_to_pagetable_data[10:0], marh[2:0], marl[7:0]} : {6'b000000, marh, marl};
  assign bus_mem_io = bus_tristate ? 1'bz : status_paging_en ? mdr_to_pagetable_data[11] : 1'b1;
  assign bus_rd = bus_tristate ? 1'bz : ctrl_rd;
  assign bus_wr = bus_tristate ? 1'bz : ctrl_wr;
  assign data_bus = ctrl_mdr_out_en ? ctrl_mdr_out_src ? mdrh : mdrl : 'z;

// Interrupts
  for(genvar i = 0; i < 8; i++) begin
    assign irq_clear[i] = ctrl_int_ack && irq_vector[3:1] == i;
    always_ff @(posedge pins_irq_req[i], posedge ctrl_clear_all_ints, posedge irq_clear[i]) begin
      if(ctrl_clear_all_ints == 1'b1 || irq_clear[i] == 1'b1) irq_dff[i] <= 1'b0;
      else irq_dff[i] <= 1'b1;
    end
  end
  always_ff @(posedge clk) begin
    irq_status <= irq_dff;
  end
  // IRQ Handling Block
  always_ff @(posedge clk) begin
    logic [7:0] irqs_masked;
    logic [2:0] irq_encoded;

    irqs_masked = irq_status & irq_masks;
    irq_request = |irqs_masked; // Check if any IRQ is requested
    if(irqs_masked[0] == 1'b1) irq_encoded = 000;
    else if(irqs_masked[1] == 1'b1) irq_encoded = 3'b001;
    else if(irqs_masked[2] == 1'b1) irq_encoded = 3'b010;
    else if(irqs_masked[3] == 1'b1) irq_encoded = 3'b011;
    else if(irqs_masked[4] == 1'b1) irq_encoded = 3'b100;
    else if(irqs_masked[5] == 1'b1) irq_encoded = 3'b101;
    else if(irqs_masked[6] == 1'b1) irq_encoded = 3'b110;
    else if(irqs_masked[7] == 1'b1) irq_encoded = 3'b111;
    
    if(ctrl_int_vector_wrt == 1'b0) begin
      irq_vector <= {4'b0000, irq_encoded[2:0], 1'b0};
    end
  end
  assign int_pending = irq_request & status_irq_en;

// Microcode Sequencer
  microcode_sequencer u_microcode_sequencer(
    .arst(arst),
    .clk(clk),
    .ir(ir),
    .cpu_flags(cpu_flags),
    .cpu_status(cpu_status),
    .z_bus(z_bus),
    .alu_out(alu_out),
    .alu_zf(alu_zf),
    .alu_of(alu_of),
    .alu_final_cf(alu_final_cf),
    .dma_req(dma_req),
    ._wait(pin_wait),
    .int_pending(int_pending),
    .ext_input(ext_input),
    .u_flags(u_flags),

    .* // control word
  );


endmodule
