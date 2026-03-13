#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <time.h>
#include "def.h"
#include "terminal.h"
#include "file_load.h"

#define EMU_QUIT_KEY 0x11  // Ctrl+Q
#define MENU_KEY     0x10  // Ctrl+P
#define U_FETCH_ADDR 16
#define U_TRAP_ADDR  32

// clock and reset
uint8_t arst;
clk_state_e clk;
uint8_t wait;
uint8_t ext_input;

// registers
uint8_t ah, bh, ch, dh, gh;
uint8_t al, bl, cl, dl, gl;
uint8_t pc_l, sp_l, ssp_l, bp_l;
uint8_t pc_h, sp_h, ssp_h, bp_h;
uint8_t si_l, di_l;
uint8_t si_h, di_h;
uint8_t tdr_h, mdr_h, mar_h;
uint8_t tdr_l, mdr_l, mar_l;
uint8_t ir;

arith_flags_u arith_flags;
status_u status;
uint8_t ptb;
uint8_t irq_status;
uint8_t irq_vector;
uint8_t irq_masks;

// wires
uint8_t alu_zf_out;
uint8_t alu_cf_out;
uint8_t alu_final_cf; // after possible inversion
uint8_t alu_of_out;

// chip selects
uint8_t bios_rom_cs;
uint8_t bios_ram_cs;
uint8_t ram_cs;
uint8_t uart0_cs;
uint8_t uart1_cs;
uint8_t ide_cs;
uint8_t rtc_cs;

// buses
uint8_t xbus, ybus;
uint8_t wbus, w_adjacent_bus, kbus;
uint8_t zbus;

// external address and data buses
uint8_t databus;
uint32_t physical_addr; // physical address is 22 bits wide for a max access of 4MB
uint8_t mem_io;

// microcode sequencer
arith_flags_u u_flags;
uint16_t u_addr;
uint16_t u_addr_nxt;

// interrupts and DMA
uint8_t irq_pending;
uint8_t any_interruption;
uint8_t irq_req;
uint8_t dma_req;
uint8_t irq_inputs;

// memory
uint16_t page_table[8192]; // virtual memory page table
uint16_t page_table_addr; // keeps the address into the page table
uint8_t memory[256 * 65536];
uint8_t bios_rom[32768];
uint8_t bios_ram[32768];

// IDE drive
uint8_t ide_disk[IDE_DISK_SIZE];
ide_state_e ide_state;
uint8_t ide_status;
uint8_t ide_data_reg;         // _ide_base + 0 ; data port   (ide base = ffd0)
uint8_t ide_err_feature_reg;  // _ide_base + 1 ; read: error code, write: feature
uint8_t ide_num_sectors_reg;  // _ide_base + 2 ; number of sectors to transfer
uint8_t ide_sect_addr0_reg;   // _ide_base + 3 ; sector address lba 0 [0:7]
uint8_t ide_sect_addr1_reg;   // _ide_base + 4 ; sector address lba 1 [8:15]
uint8_t ide_sect_addr2_reg;   // _ide_base + 5 ; sector address lba 2 [16:23]
uint8_t ide_sect_addr3_reg;   // _ide_base + 6 ; sector address lba 3 [24:27 (lsb)]
uint8_t ide_status_cmd_reg;   // _ide_base + 7 ; read: status, write: command       

// UART
uint8_t uart0_data;       //   .equ $ff80         ; data
uint8_t uart0_dlab_0;     //   .equ $ff80; divisor latch low byte
uint8_t uart0_dlab_1;     //   .equ $ff81; divisor latch high byte
uint8_t uart0_ier;        //   .equ $ff81         ; interrupt enable register
uint8_t uart0_fcr;        //   .equ $ff82         ; fifo control register
uint8_t uart0_lcr;        //   .equ $ff83         ; line control register
uint8_t uart0_lsr;        //   .equ $ff85         ; line status register

uint8_t uart1_data;       //   .equ $ff88         ; data
uint8_t uart1_dlab_0;     //   .equ $ff88; divisor latch low byte
uint8_t uart1_dlab_1;     //   .equ $ff89; divisor latch high byte
uint8_t uart1_ier;        //   .equ $ff89         ; interrupt enable register
uint8_t uart1_fcr;        //   .equ $ff8A         ; fifo control register
uint8_t uart1_lcr;        //   .equ $ff8B         ; line control register
uint8_t uart1_lsr;        //   .equ $ff8D         ; line status register

// RTC
uint8_t rtc_scratch[8];   // ffa0..ffa7
uint8_t rtc_ctrl;         // ffa8 [ w | r | s | cal4..cal0 ]
uint8_t rtc_regs[7];      // ffa9..ffaf: sec, min, hour, week, day, month, year

uint8_t debug = 0;

int main(int argc, char *argv[]){
  puts("Sol-1 Emulator starting...");
  term_raw_noecho();

  load_microcode_roms();
  load_bios_memory();
  load_ide_disk();

  reset();
  main_loop();

  term_restore();

  return 0;
}

void main_loop(){
  for(;;){
    if(debug){
      printf("\n");
      print_clk();
    }

    procees_irqs();
    process_cpu_cycle();
    process_address_decoder();
    process_memory_cycle();
    process_ide_cycle();
    process_uart_cycle();
    process_rtc_cycle();

    if(debug){
      print_state();
    }

    step_clock();
  }
}

void reset(){
  clk  = CLK_NEGEDGE;

  // microcode control
  u_addr             = 0;
  arith_flags.byte   = 0;
  u_flags.byte       = 0;
  irq_inputs         = 0;

  // ide drive
  ide_state          = IDE_IDLE;
  ide_status         = 0;
  ide_status_cmd_reg = 0;

  // uarts
  // 0010_0000 (00 | transmitter ready | 0 000 | data ready)
  uart0_data   = 0;        
  uart0_dlab_0 = 0;       
  uart0_dlab_1 = 0;       
  uart0_ier    = 0;       
  uart0_fcr    = 0;       
  uart0_lcr    = 0;       
  uart0_lsr    = 0x20; // transmitter ready     

  uart1_data   = 0;       
  uart1_dlab_0 = 0;       
  uart1_dlab_1 = 0;       
  uart1_ier    = 0;       
  uart1_fcr    = 0;       
  uart1_lcr    = 0;       
  uart1_lsr    = 0x20; // transmitter ready     

  // rtc
  memset(rtc_scratch, 0, sizeof(rtc_scratch));
  rtc_ctrl = 0;
  rtc_load_host_time();
}

void step_clock(){
  switch(clk){
    case CLK_POSEDGE:
      clk = CLK_NEGEDGE;
      break;

    case CLK_NEGEDGE:
      clk = CLK_POSEDGE;
      break;
  }
}

void procees_irqs(){
  uint8_t irqs_masked;
  uint8_t irq_encoded;

  if(clk == CLK_POSEDGE){
    irq_status = irq_inputs;
    irqs_masked = irq_status & irq_masks; // apply masks register

    // signals whether any of the IRQ inputs is non-zero
    irq_req = irqs_masked != 0x00;
    
    // priority encoder
    if      (irqs_masked & 0x01) irq_encoded = 0;
    else if (irqs_masked & 0x02) irq_encoded = 1;
    else if (irqs_masked & 0x04) irq_encoded = 2;
    else if (irqs_masked & 0x08) irq_encoded = 3;
    else if (irqs_masked & 0x10) irq_encoded = 4;
    else if (irqs_masked & 0x20) irq_encoded = 5;
    else if (irqs_masked & 0x40) irq_encoded = 6;
    else if (irqs_masked & 0x80) irq_encoded = 7;
    
    if(!irq_vector_wrt_r){
      irq_vector = irq_encoded << 1;
    }
  }

  if(clk == CLK_NEGEDGE){
    if(clear_all_ints_r) irq_inputs = 0x00;
    if(int_ack_r){
      irq_inputs = irq_inputs & ~(0x01 << (irq_vector >> 1)); // clear corresponding irq
    }
  }
}

void process_cpu_cycle(){
  uint8_t u_mux_a, u_mux_b;
  uint8_t alu_a, alu_b, alu_out;
  alu_op_e alu_op;
  uint8_t alu_a_src_40;
  uint8_t zf_in_src;
  uint8_t cf_in_src;
  uint8_t sf_in_src;
  uint8_t of_in_src;
  uint8_t immediate;
  uint8_t int_pending;
  // arith flag muxes
  static uint8_t alu_zf_mux; // these are static as their values are used across calls/clock states
  static uint8_t alu_cf_mux;
  static uint8_t alu_sf_mux;
  static uint8_t alu_of_mux;
  // micro flags muxes
  static uint8_t u_zf_in_mux;
  static uint8_t u_cf_in_mux;
  static uint8_t u_sf_in_mux;
  static uint8_t u_of_in_mux;
  // for page table writing
  uint8_t effective_ptb;
  uint8_t page_table_addr_source;

  // on this edge, latch all registers
  // 1. latch all registers
  // 2. compute next u-address
  if(clk == CLK_POSEDGE){
    uint16_t u_offset;
    arith_flags_u selected_flags;
    uint8_t cond_sel;
    uint8_t cond_sel_mux;
    uint8_t final_condition;
    uint16_t u_adder_out;
    uint16_t u_adder_in_mux;
    uint8_t u_adder_in_mux_src;
    uint8_t escape;

    // 1. latch all registers
    u_addr = u_addr_nxt;

    // general registers
    if(!al_wrt_r) al    = zbus;
    if(!ah_wrt_r) ah    = zbus;
    if(!bl_wrt_r) bl    = zbus;
    if(!bh_wrt_r) bh    = zbus;
    if(!cl_wrt_r) cl    = zbus;
    if(!ch_wrt_r) ch    = zbus;
    if(!dl_wrt_r) dl    = zbus;
    if(!dh_wrt_r) dh    = zbus;
    if(!gl_wrt_r) gl    = zbus;
    if(!gh_wrt_r) gh    = zbus;

    if(!sil_wrt_r) si_l = zbus;
    if(!sih_wrt_r) si_h = zbus;
    if(!dil_wrt_r) di_l = zbus;
    if(!dih_wrt_r) di_h = zbus;

    if(!spl_wrt_r) sp_l = zbus;
    if(!sph_wrt_r) sp_h = zbus;
    if(!bpl_wrt_r) bp_l = zbus;
    if(!bph_wrt_r) bp_h = zbus;

    if(!(spl_wrt_r || status.cpu_mode)) ssp_l = zbus;
    if(!(sph_wrt_r || status.cpu_mode)) ssp_h = zbus;

    if(!ir_wrt_r) ir      = databus;
                          
    if(!pcl_wrt_r) pc_l   = zbus;
    if(!pch_wrt_r) pc_h   = zbus;

    if(!tdrl_wrt_r) tdr_l = zbus;
    if(!tdrh_wrt_r) tdr_h = zbus;

    if(!marl_wrt_r){
      if(mar_in_src_r)
        mar_l = pc_l;
      else
        mar_l = zbus;
    }
    if(!marh_wrt_r){
      if(mar_in_src_r)
        mar_h = pc_h;
      else
        mar_h = zbus;
    } 

    if(!mdrl_wrt_r){
      if(mdr_in_src_r)
        mdr_l = databus;
      else
        mdr_l = zbus;
    }
    if(!mdrh_wrt_r){
      if(mdr_in_src_r)
        mdr_h = databus;
      else
        mdr_h = zbus;
    }
    if(!status_flags_wrt_r) status.byte = zbus;
    if(!irq_masks_wrt_r) irq_masks = zbus;
    if(!ptb_wrt_r) ptb = zbus;

    // write arithmetic flags register
    arith_flags.zf = alu_zf_mux;
    arith_flags.cf = alu_cf_mux;
    arith_flags.sf = alu_sf_mux;
    arith_flags.of = alu_of_mux;

    // write u-arithmetic flags register
    u_flags.zf = u_zf_in_mux;
    u_flags.cf = u_cf_in_mux;
    u_flags.sf = u_sf_in_mux;
    u_flags.of = u_of_in_mux;


    // 2. compute next u-address
    cond_sel = microcode_roms[u_addr].rom_1.cond_sel_3 << 3 | 
               microcode_roms[u_addr].rom_1.cond_sel_2 << 2 | 
               microcode_roms[u_addr].rom_1.cond_sel_1 << 1 | 
               microcode_roms[u_addr].rom_1.cond_sel_0;

    u_offset = microcode_roms[u_addr].rom_0.u_offset_0       | microcode_roms[u_addr].rom_0.u_offset_1 << 1  | microcode_roms[u_addr].rom_0.u_offset_2 << 2  | 
               microcode_roms[u_addr].rom_0.u_offset_3 << 3  | microcode_roms[u_addr].rom_0.u_offset_4 << 4  | microcode_roms[u_addr].rom_0.u_offset_5 << 5  | 
               microcode_roms[u_addr].rom_1.u_offset_6 << 6  | microcode_roms[u_addr].rom_1.u_offset_6 << 8  | microcode_roms[u_addr].rom_1.u_offset_6 << 7  |
               microcode_roms[u_addr].rom_1.u_offset_6 << 15 | microcode_roms[u_addr].rom_1.u_offset_6 << 14 | microcode_roms[u_addr].rom_1.u_offset_6 << 13 | 
               microcode_roms[u_addr].rom_1.u_offset_6 << 12 | microcode_roms[u_addr].rom_1.u_offset_6 << 11 | microcode_roms[u_addr].rom_1.u_offset_6 << 10 | 
               microcode_roms[u_addr].rom_1.u_offset_6 << 9;

    int_pending = irq_req && status.irq_en;
    any_interruption = dma_req || int_pending;

    // select between micro or normal arithmetic flags
    if(microcode_roms[u_addr].rom_1.cond_flag_src)
      selected_flags.byte = u_flags.byte;
    else
      selected_flags.byte = arith_flags.byte;
      
    // micro condition selection mux
    switch(cond_sel){
      case 0:
        cond_sel_mux = selected_flags.zf;
        break;
      case 1:
        cond_sel_mux = selected_flags.cf;
        break;
      case 2:
        cond_sel_mux = selected_flags.sf;
        break;
      case 3:
        cond_sel_mux = selected_flags.of;
        break;
      case 4:
        cond_sel_mux = selected_flags.sf ^ selected_flags.of; 
        break;
      case 5:
        cond_sel_mux = (selected_flags.sf ^ selected_flags.of) | selected_flags.zf; 
        break;
      case 6:
        cond_sel_mux = selected_flags.zf | selected_flags.cf; 
        break;
      case 7:
        cond_sel_mux = dma_req;
        break;
      case 8:
        cond_sel_mux = status.cpu_mode;
        break;
      case 9:
        cond_sel_mux = wait;
        break;
      case 10:
        cond_sel_mux = int_pending;
        break;
      case 11:
        cond_sel_mux = ext_input;
        break;
      case 12:
        cond_sel_mux = status.dir;
        break;
      case 13:
        cond_sel_mux = status.display_reg_load;
        break;
      default:
        cond_sel_mux = 0;
    }

    final_condition = cond_sel_mux ^ microcode_roms[u_addr].rom_1.cond_invert;

    // micro address next
    u_mux_a = microcode_roms[u_addr].rom_0.typ_1 && (microcode_roms[u_addr].rom_0.typ_0 || (!microcode_roms[u_addr].rom_0.typ_0 && any_interruption));
    u_mux_b = microcode_roms[u_addr].rom_0.typ_1 && !microcode_roms[u_addr].rom_0.typ_0;

    u_adder_in_mux_src = !(!final_condition && microcode_roms[u_addr].rom_0.typ_0 && !microcode_roms[u_addr].rom_0.typ_1);
    u_adder_in_mux     = u_adder_in_mux_src ? u_offset : 1;
    u_adder_out        = u_addr + u_adder_in_mux; // micro address adder

    escape = microcode_roms[u_addr].rom_1.escape;

    if(u_mux_b == 0 && u_mux_a == 0){
      u_addr_nxt = u_adder_out;
    }
    else if(u_mux_b == 0 && u_mux_a == 1){
      u_addr_nxt = (ir << 6) | (escape ? ESCAPE : 0x00);
    }
    else if(u_mux_b == 1 && u_mux_a == 0){
      u_addr_nxt = U_FETCH_ADDR;
    }
    else if(u_mux_b == 1 && u_mux_a == 1){
      u_addr_nxt = U_TRAP_ADDR;
    }
  }

  // 1. latch current control word into "flip-flops"
  // 2. compute values of all datapath elements
  if(clk == CLK_NEGEDGE){
    uint8_t alu_cf_in_src;
    uint8_t alu_cf_in;
    uint8_t w_prime_bus;
    uint8_t alu_a_src_10;
    uint8_t alu_b_src_10;
    uint8_t shift_src;
    uint8_t shift_mux;
    uint8_t zbus_in_src;
    uint8_t u_zf_in_src;
    uint8_t u_cf_in_src;
    uint8_t u_sf_in_src;
    uint8_t u_of_in_src;

    // 1. latch current control word into "flip-flops"
    latch_microcode_ctrl_word();

    // 2. compute values of all datapath elements
    immediate     = immy_7_r         << 7 | immy_6_r      << 6 | immy_5_r      << 5 | immy_4_r      << 4 | immy_3_r << 3 | immy_2_r << 2 | immy_1_r << 1 | immy_0_r ;
    alu_op        = alu_mode_r       << 4 | alu_op_3_r    << 3 | alu_op_2_r    << 2 | alu_op_1_r    << 1 | alu_op_0_r;
    alu_a_src_40  = alu_a_src_4_r    << 4 | alu_a_src_3_r << 3 | alu_a_src_2_r << 2 | alu_a_src_1_r << 1 | alu_a_src_0_r;
    alu_cf_in_src = alu_cf_in_src1_r << 1 | alu_cf_in_src0_r;
    alu_b_src_10  = alu_b_src_1_r    << 1 | alu_b_src_0_r;
    alu_a_src_10  = alu_a_src_1_r    << 1 | alu_a_src_0_r;

    // shift source
    shift_src = shift_src_2_r << 2 | shift_src_1_r << 1 | shift_src_0_r;

    // zbus source
    zbus_in_src = zbus_in_src_1_r << 1 | zbus_in_src_0_r;

    // alu flags
    zf_in_src = zf_in_src_1_r << 1 | zf_in_src_0_r;
    cf_in_src = cf_in_src_2_r << 2 | cf_in_src_1_r << 1 | cf_in_src_0_r;
    sf_in_src = sf_in_src_1_r << 1 | sf_in_src_0_r;
    of_in_src = of_in_src_2_r << 2 | of_in_src_1_r << 1 | of_in_src_0_r;

    // micro flags input muxes
    u_zf_in_src = u_zf_in_src_1_r << 1 | u_zf_in_src_0_r;
    u_cf_in_src = u_cf_in_src_1_r << 1 | u_cf_in_src_0_r;
    u_sf_in_src = u_sf_in_src_r;
    u_of_in_src = u_of_in_src_r;

    // w bus multiplexer
    switch(alu_a_src_40){
      case 0x00:
        wbus = al;
        break;
      case 0x01:
        wbus = ah;
        break;
      case 0x02:
        wbus = bl;
        break;
      case 0x03:
        wbus = bh;
        break;
      case 0x04:
        wbus = cl;
        break;
      case 0x05:
        wbus = ch;
        break;
      case 0x06:
        wbus = dl;
        break;
      case 0x07:
        wbus = dh;
        break;
      case 0x08:
        wbus = sp_l;
        break;
      case 0x09:
        wbus = sp_h;
        break;
      case 0x0A:
        wbus = bp_l;
        break;
      case 0x0B:
        wbus = bp_h;
        break;
      case 0x0C:
        wbus = si_l;
        break;
      case 0x0D:
        wbus = si_h;
        break;
      case 0x0E:
        wbus = di_l;
        break;
      case 0x0F:
        wbus = di_h;
        break;
      case 0x10:
        wbus = pc_l;
        break;
      case 0x11:
        wbus = pc_h;
        break;
      case 0x12:
        wbus = mar_l;
        break;
      case 0x13:
        wbus = mar_h;
        break;
      case 0x14:
        wbus = mdr_l;
        break;
      case 0x15:
        wbus = mdr_h;
        break;
      case 0x16:
        wbus = tdr_l;
        break;
      case 0x17:
        wbus = tdr_h;
        break;
      case 0x18:
        wbus = ssp_l;
        break;
      case 0x19:
        wbus = ssp_h;
        break;
      case 0x1A:
        wbus = irq_vector;
        break;
      case 0x1B:
        wbus = irq_masks;
        break;
      case 0x1C:
        wbus = irq_status;
        break;
      default:
        wbus = 0x00;
    }

    // w bus multiplexer
    switch(alu_a_src_10){
      case 0:
        w_adjacent_bus = arith_flags.byte;
        break;
      case 1:
        w_adjacent_bus = status.byte;
        break;
      case 2:
        w_adjacent_bus = gl;
        break;
      case 3:
        w_adjacent_bus = gh;
        break;
      default:
        w_adjacent_bus = 0;
    }

    // k bus multiplexer
    switch(alu_b_src_10){
      case 0:
        kbus = mdr_l;
        break;
      case 1:
        kbus = mdr_h;
        break;
      case 2:
        kbus = tdr_l;
        break;
      case 3:
        kbus = tdr_h;
        break;
      default:
        kbus = 0;
    }

    // x and y bus multiplexers
    xbus = alu_a_src_5_r ? w_adjacent_bus : wbus;
    ybus = alu_b_src_2_r ? kbus : immediate;

    // alu inputs
    alu_a = xbus;
    alu_b = ybus;

    // set carry-flag-in value
    switch(alu_cf_in_src){
      case 0:
        alu_cf_in = 1;
        break;
      case 1:
        alu_cf_in = arith_flags.cf;
        break;
      case 2:
        alu_cf_in = u_flags.cf;
        break;
      default:
        alu_cf_in = 0;
    }

    alu_cf_in = alu_cf_in ^ alu_cf_in_invert_r;
  
    switch(alu_op){
      case(alu_op_add): 
        alu_out = alu_a + alu_b + !alu_cf_in; // 181 ALU has low active carries
        break;

      case(alu_op_sub): 
        alu_out = alu_a + ~alu_b + !alu_cf_in; // 181 ALU has low active carries
        break;

      case(alu_op_and): 
        alu_out = alu_a & alu_b;
        break;

      case(alu_op_or): 
        alu_out = alu_a | alu_b;
        break;

      case(alu_op_xor): 
        alu_out = alu_a ^ alu_b;
        break;

      case(alu_op_a): 
        alu_out = alu_a;
        break;

      case(alu_op_b): 
        alu_out = alu_b;
        break;

      case(alu_op_not_a): 
        alu_out = ~alu_a;
        break;

      case(alu_op_not_b): 
        alu_out = ~alu_b;
        break;

      case(alu_op_nand): 
        alu_out = ~(alu_a & alu_b);
        break;

      case(alu_op_nor): 
        alu_out = ~(alu_a | alu_b);
        break;

      case(alu_op_nxor): 
        alu_out = ~(alu_a ^ alu_b);
        break;

      default: 
        alu_out = 0;
    }

    // zbus
    switch(shift_src){
      case 0:
        shift_mux = 0;
        break;
      case 1:
        shift_mux = u_flags.cf;
        break;
      case 2:
        shift_mux = arith_flags.cf;
        break;
      case 3:
        shift_mux = alu_out & 0x01;
        break;
      case 4:
        shift_mux = (alu_out >> 7) & 0x01;
        break;
      default:
        shift_mux = 1;
    }

    switch(zbus_in_src){
      case 0:
        zbus = alu_out;
        break;
      case 1:
        zbus = alu_out >> 1u | shift_mux << 7u;
        break;
      case 2:
        zbus = alu_out << 1u | shift_mux;
        break;
      case 3:
        zbus = (alu_out & 0x80) ? 0xFF : 0x00; // used for sign extension
        break;
    }

    // carry and borrow calculations
    // the 74HC181 has active low logic for carries.
    // also, for 2's complement subtractions, remember that carry == 1 means no borrow occurred, and carry == 0 means borrow occurred
    // but then again since the carry output is inverted, carry == 1 == no borrow, and when it is inverted, we get a 0 == no borrow, so it works out nicely
    if(alu_op == alu_op_add){
      uint16_t tmp = (uint16_t)alu_a + (uint16_t)alu_b + (uint16_t)!alu_cf_in;
      alu_cf_out = (tmp >> 8) & 0x01;
      alu_cf_out = !alu_cf_out; // invert carry out to follow 74HC181 ALU specs

      alu_of_out = ((alu_a ^ zbus) & (alu_b ^ zbus) & 0x80) != 0;
    }
    else if(alu_op == alu_op_sub){
      uint16_t tmp = (uint16_t)alu_a + (uint16_t)(uint8_t)(~alu_b) + (uint16_t)!alu_cf_in; // need to convert the ~alu_b term to uint8_t first, because the ~ operator casts to 16bits here and that totally messes with the result
      alu_cf_out = (tmp >> 8) & 0x01;
      alu_cf_out = !alu_cf_out; // invert carry out to follow 74HC181 ALU specs

      alu_of_out = ((alu_a ^ alu_b) & (alu_a ^ zbus) & 0x80) != 0;

      //printf("tmp: %x, a: %x, b: %x, out: %x, cin: %x, flag: %x, cout: %x, alu_cf_out: %x, cf in inv: %x, cf out inv: %x, cf_in_src: %x\n", tmp, alu_a, alu_b, alu_out, alu_cf_in, arith_flags.cf, alu_final_cf, alu_cf_out, alu_cf_in_invert_r, alu_cf_out_invert_r, alu_cf_in_src);
    }
    else{
      alu_cf_out = 1; // carry flag is not changed/written for non-arithmetical ops, so this can be anything
      alu_of_out = 0;
    }
    alu_final_cf = alu_cf_out ^ alu_cf_out_invert_r; // optional inversion
    alu_zf_out = zbus == 0;
    
    // calculate the values of the mux outputs, for writing into the flags register on rising edge
    // zf mux
    switch(zf_in_src){
      case 0:
        alu_zf_mux = arith_flags.zf; // keep same value
        break;
      case 1:
        alu_zf_mux = alu_zf_out; // new alu zf
        break;
      case 2:
        alu_zf_mux = arith_flags.zf && alu_zf_out; // AND of new zf and current zf
        break;
      case 3:
        alu_zf_mux = zbus & 0x01;
        break;
      default:
        alu_zf_mux = arith_flags.zf; // keep same value on default as precaution
    }
    // cf mux
    switch(cf_in_src){
      case 0:
        alu_cf_mux = arith_flags.cf; // keep same value
        break;
      case 1:
        alu_cf_mux = alu_final_cf; 
        break;
      case 2:
        alu_cf_mux = alu_out & 0x01; // alu_output_0
        break;
      case 3:
        alu_cf_mux = (zbus & 0x02) >> 1; // zbus_1
        break;
      case 4:
        alu_cf_mux = (alu_out & 0x80) >> 7; // alu_output_7
        break;
      default:
        alu_cf_mux = arith_flags.cf; // keep same value on default as precaution
    }
    // sf mux
    switch(sf_in_src){
      case 0:
        alu_sf_mux = arith_flags.sf; // keep same value
        break;
      case 1:
        alu_sf_mux = (zbus & 0x80) >> 7; // zbus_7
        break;
      case 2:
        alu_sf_mux = 0;
        break;
      case 3:
        alu_sf_mux = (zbus & 0x04) >> 2; // zbus_2
        break;
      default:
        alu_sf_mux = arith_flags.sf; // keep same value on default as precaution
    }
    // of mux
    switch(of_in_src){
      case 0:
        alu_of_mux = arith_flags.of; // keep same value
        break;
      case 1:
        alu_of_mux = alu_of_out;
        break;
      case 2:
        alu_of_mux = (zbus & 0x80) >> 7; // zbus_7
        break;
      case 3:
        alu_of_mux = (zbus & 0x08) >> 3; // zbus_3
        break;
      case 4:
        alu_of_mux = ((zbus & 0x80) >> 7) ^ u_flags.sf; // zbus_7 XOR u_sf
        break;
      default:
        alu_of_mux = arith_flags.of; // keep same value on default as precaution
    }

    // the arithmetic flags register is written on the rising edge, so not here!
    // it is written in fact on every rising edge, and depends on the input mux selection, which dictates whether it changes, keeps existing values
    // or takes on the newly calculated ones

    // micro flags
    // micro zf mux in
    switch(u_zf_in_src){
      case 0:
        u_zf_in_mux = u_flags.zf;
        break;
      case 1:
        u_zf_in_mux = alu_zf_out;
        break;
      case 2:
        u_zf_in_mux = u_flags.zf && alu_zf_out;
        break;
      case 3:
        u_zf_in_mux = 0x00;
        break;
      default:
        u_zf_in_mux = u_flags.zf;
    }
    // micro cf mux in
    switch(u_cf_in_src){
      case 0:
        u_cf_in_mux = u_flags.cf;
        break;
      case 1:
        u_cf_in_mux = alu_final_cf;
        break;
      case 2:
        u_cf_in_mux = alu_out & 0x01;
        break;
      case 3:
        u_cf_in_mux = (alu_out & 0x80) >> 7;
        break;
      default:
        u_cf_in_mux = u_flags.cf;
    }
    // micro sf mux in
    switch(u_sf_in_src){
      case 0:
        u_sf_in_mux = u_flags.sf;
        break;
      case 1:
        u_sf_in_mux = zbus >> 7;
        break;
      default:
        u_sf_in_mux = u_flags.sf;
    }
    // micro of mux in
    switch(u_of_in_src){
      case 0:
        u_of_in_mux = u_flags.of;
        break;
      case 1:
        u_of_in_mux = alu_of_out;
        break;
      default:
        u_of_in_mux = u_flags.of;
    }

    // mdr out to databus in
    if(mdr_out_en_r){
      if(mdr_out_src_r)
        databus = mdr_h;
      else
        databus = mdr_l;
    }

    // write page table
    page_table_addr_source = force_user_ptb_r || status.cpu_mode;
    effective_ptb = page_table_addr_source ? ptb : 0x00; // select between 0 (kernel ptb) or actual ptb value
    page_table_addr = ((uint16_t)effective_ptb << 5) | (uint16_t)(mar_h >> 3);

    if(page_table_we_r)
      page_table[page_table_addr] = (mdr_h << 8) | mdr_l;
  }
}

void process_address_decoder(){
  uint8_t effective_ptb;
  uint8_t physical_addr_7_to_14_all_true;
  uint8_t devices_select;
  uint8_t page_table_addr_source;

  page_table_addr_source = force_user_ptb_r || status.cpu_mode;
  effective_ptb = page_table_addr_source ? ptb : 0x00; // select between 0 (kernel ptb) or actual ptb value
  page_table_addr = ((uint16_t)effective_ptb << 5) | (uint16_t)(mar_h >> 3);

  if(status.paging_en)
    physical_addr = ((uint32_t)(page_table[page_table_addr]) << 11) | ((uint32_t)(mar_h & 0x07) << 8) | (uint32_t)mar_l;
  else
    physical_addr = 0x00400000 | ((uint32_t)mar_h << 8) | (uint32_t)mar_l; // mem_io | marh | marl

  // address decoder
  physical_addr_7_to_14_all_true = (physical_addr & 0x00007F80) == 0x00007F80;
  
  mem_io         = (physical_addr & 0x00400000) != 0; // bit 22 is mem_io
  bios_rom_cs    = (physical_addr & 0x003F0000) == 0 && (physical_addr & 0x00008000) == 0 && mem_io == 1;
  bios_ram_cs    = (physical_addr & 0x003F0000) == 0 && (physical_addr & 0x00008000) != 0 && mem_io == 1 && !physical_addr_7_to_14_all_true;
  ram_cs         = mem_io == 0;
  devices_select = mem_io && physical_addr_7_to_14_all_true && (physical_addr & 0x00008000) != 0;
  
  uart0_cs       = devices_select && (physical_addr & 0x00000078) == 0x00000000; // phys[6:3] == 0
  uart1_cs       = devices_select && (physical_addr & 0x00000078) == 0x00000008; // phys[6:3] == 1

  ide_cs         = devices_select && (physical_addr & 0x00000070) == 0x00000050; // phys[6:4] == 5

  rtc_cs         = devices_select && (physical_addr & 0x00000070) == 0x00000020; // phys[6:4] == 2
}

void process_memory_cycle(){
  if(clk == CLK_NEGEDGE){
    if(rd_r){
      if(bios_rom_cs){
        databus = bios_rom[physical_addr & 0x00007FFF];
        //printf("bios rom read at 0x%x: 0x%x\n", physical_addr & 0x00007FFF, databus);
      }
      else if(bios_ram_cs){
        databus = bios_ram[physical_addr & 0x00007FFF];
        //printf("bios ram read at 0x%x: 0x%x\n", physical_addr & 0x00007FFF, databus);
      }
      else if(ram_cs){
        databus = memory[physical_addr];
        //printf("ram memory read at 0x%x: 0x%x\n", physical_addr, databus);
      }
    }
    if(wr_r){
      if(bios_ram_cs){
        bios_ram[physical_addr & 0x00007FFF] = databus;
        //printf("bios ram written at 0x%x: 0x%x\n", physical_addr & 0x00007FFF, databus);
      }
      else if(ram_cs){
        memory[physical_addr] = databus;
        //printf("ram memory written at 0x%x: 0x%x\n", physical_addr & 0x00007FFF, databus);
      }
    }
  }
}

// uint8_t uart0_data  ;        //   .equ $ff80         ; data
// uint8_t uart0_dlab_0;        //   .equ $ff80         ; divisor latch low byte
// uint8_t uart0_dlab_1;        //   .equ $ff81         ; divisor latch high byte
// uint8_t uart0_ier   ;        //   .equ $ff81         ; interrupt enable register
// uint8_t uart0_fcr   ;        //   .equ $ff82         ; fifo control register
// uint8_t uart0_lcr   ;        //   .equ $ff83         ; line control register
// uint8_t uart0_lsr   ;        //   .equ $ff85         ; line status register
// 
// uint8_t uart1_data  ;        //   .equ $ff88         ; data
// uint8_t uart1_dlab_0;        //   .equ $ff88         ; divisor latch low byte
// uint8_t uart1_dlab_1;        //   .equ $ff89         ; divisor latch high byte
// uint8_t uart1_ier   ;        //   .equ $ff89         ; interrupt enable register
// uint8_t uart1_fcr   ;        //   .equ $ff8A         ; fifo control register
// uint8_t uart1_lcr   ;        //   .equ $ff8B         ; line control register
// uint8_t uart1_lsr   ;        //   .equ $ff8D         ; line status register
void process_uart_cycle(){
  uint8_t uart_reg_addr;
  static uint32_t count = 0;

  count++;

  uart_reg_addr = physical_addr & 0x0007;

  // only poll once every 100k counts in order to speed up
  if(count % 100000 == 0){
    // uart receive character (one IRQ per key)
    if (kbhit()) {
      uint8_t c;
      if (read_stdin_byte(&c)) {
        // Map terminal Backspace (DEL) to ASCII Backspace (BS)
        if (c == 0x7F) c = 0x08;

        uart0_data = c;
        uart0_lsr |= 0x01; // data ready

        // ---- QUIT SHORTCUT ----
        if (c == EMU_QUIT_KEY) {
          printf("\nExiting emulator (Ctrl+Q)\n");
          exit(0);
        }
        // ---- MENU SHORTCUT ----
        if (c == MENU_KEY) {
          print_state();
        }

        if (uart0_ier) {
          irq_inputs |= 0x80; // IRQ7
        }
      }
    }
  }

  if(clk == CLK_NEGEDGE){
    if(uart0_cs){
      if(rd_r){
        switch(uart_reg_addr){
          case 0:
            if(uart0_lcr & 0x80) databus = uart0_dlab_0;
            else{
              databus = uart0_data;
              uart0_lsr &= 0xFE; // clear data ready
            }
            break;
          case 1:
            if(uart0_lcr & 0x80) databus = uart0_dlab_1;
            else databus = uart0_ier;
            break;
          case 2:
            databus = 0x00; // interrupt identification register (read)  (unimplemented)
            break;
          case 3:
            databus = uart0_lcr;
            break;
          case 4:
            databus = 0x00;
            break;
          case 5:
            databus = uart0_lsr;
            break;
          default:
            databus = 0x00;
        }
      }
      else if(wr_r){
        switch(uart_reg_addr){
          case 0:
            if(uart0_lcr & 0x80) uart0_dlab_0 = databus;
            else{
              uart0_data = databus;
              putchar(uart0_data);
            }
            break;
          case 1:
            if(uart0_lcr & 0x80) uart0_dlab_1 = databus;
            else uart0_ier = databus;
            break;
          case 2:
            uart0_fcr = databus;
            break;
          case 3:
            uart0_lcr = databus;
            break;
          case 4:
            // modem control (unimplemented)
            break;
          case 5:
            // not reccommended for writing (line status register)
            break;
        }
      }
    }

    if(uart1_cs){
      if(rd_r){
        switch(uart_reg_addr){
          case 0:
            if(uart1_lcr & 0x80) databus = uart1_dlab_0;
            else{
              databus = uart1_data;
              uart1_lsr &= 0xFE; // clear data ready
            }
            break;
          case 1:
            if(uart1_lcr & 0x80) databus = uart1_dlab_1;
            else databus = uart1_ier;
            break;
          case 2:
            databus = 0x00; // interrupt identification register (read)  (unimplemented)
            break;
          case 3:
            databus = uart1_lcr;
            break;
          case 4:
            databus = 0x00;
            break;
          case 5:
            databus = uart1_lsr;
            break;
          default:
            databus = 0x00;
        }
      }
      else if(wr_r){
        switch(uart_reg_addr){
          case 0:
            if(uart1_lcr & 0x80) uart1_dlab_0 = databus;
            else{
              uart1_data = databus;
              // uart1 output commented out as we don#t want double printouts
              //putchar(uart1_data);
            }
            break;
          case 1:
            if(uart1_lcr & 0x80) uart1_dlab_1 = databus;
            else uart1_ier = databus;
            break;
          case 2:
            uart1_fcr = databus;
            break;
          case 3:
            uart1_lcr = databus;
            break;
          case 4:
            // modem control (unimplemented)
            break;
          case 5:
            // not reccommended for writing (line status register)
            break;
        }
      }
    }
  }
}

                                 // $ffd0         ; ide base
// uint8_t ide_data_reg;         // _ide_base + 0 ; data port
// uint8_t ide_err_feature_reg;  // _ide_base + 1 ; read: error code, write: feature
// uint8_t ide_num_sectors_reg;  // _ide_base + 2 ; number of sectors to transfer
// uint8_t ide_sect_addr0_reg;   // _ide_base + 3 ; sector address lba 0 [0:7]
// uint8_t ide_sect_addr1_reg;   // _ide_base + 4 ; sector address lba 1 [8:15]
// uint8_t ide_sect_addr2_reg;   // _ide_base + 5 ; sector address lba 2 [16:23]
// uint8_t ide_sect_addr3_reg;   // _ide_base + 6 ; sector address lba 3 [24:27 (lsb)]
// uint8_t ide_status_cmd_reg;   // _ide_base + 7 ; read: status, write: command       
// status: bit 7: busy flag(1 = busy), bit 3: DRQ flag(0 = read/write process ended, 1 = not ended)
// cmd: 0x20 : read sector
// cmd: 0x30 : write sector
void process_ide_cycle(){
  uint8_t ide_reg_addr;
  static uint32_t ide_byte_addr;
  static uint32_t ide_byte_count;

  ide_reg_addr = physical_addr & 0x0007;

  if(clk == CLK_NEGEDGE){
    if(ide_cs){
      if(rd_r){
        switch(ide_reg_addr){
          case 0:
            if(ide_state == IDE_READING){
              ide_data_reg = ide_disk[ide_byte_addr];
              ide_byte_addr++;
              ide_byte_count++;
              databus = ide_data_reg;
              if(ide_byte_count == (uint32_t)ide_num_sectors_reg * 512u){
                ide_state = IDE_IDLE;
                ide_status = 0x00; // writing process ended
              }
            }
            break;
          case 1:
            databus = ide_err_feature_reg;
            break;
          case 2:
            databus = ide_num_sectors_reg;
            break;
          case 3:
            databus = ide_sect_addr0_reg;
            break;
          case 4:
            databus = ide_sect_addr1_reg;
            break;
          case 5:
            databus = ide_sect_addr2_reg;
            break;
          case 6:
            databus = ide_sect_addr3_reg;
            break;
          case 7:
            databus = ide_status;
            break;
        }
      }
      else if(wr_r){
        switch(ide_reg_addr){
          case 0:
            ide_data_reg = databus;
            if(ide_state == IDE_WRITING){
              ide_disk[ide_byte_addr] = ide_data_reg;
              ide_byte_addr++;
              ide_byte_count++;
              if(ide_byte_count == (uint32_t)ide_num_sectors_reg * 512u){
                ide_state = IDE_IDLE;
                ide_status = 0x00; // writing process ended
                ide_write_to_disk();
              }
            }
            break;
          case 1:
            ide_err_feature_reg = databus;
            break;
          case 2:
            ide_num_sectors_reg = databus;
            break;
          case 3:
            ide_sect_addr0_reg = databus;
            break;
          case 4:
            ide_sect_addr1_reg = databus;
            break;
          case 5:
            ide_sect_addr2_reg = databus;
            break;
          case 6:
            ide_sect_addr3_reg = databus;
            break;
          case 7:
            ide_status_cmd_reg = databus;
            switch(ide_status_cmd_reg){
              case 0x20:
                if(ide_state == IDE_IDLE){
                  ide_state = IDE_READING;
                  ide_status = 0x08; // not busy, reading process not ended
                  ide_byte_count = 0;
                  ide_byte_addr = ((uint32_t)ide_sect_addr3_reg & 0x0F) << 24 | (uint32_t)ide_sect_addr2_reg << 16 | (uint32_t)ide_sect_addr1_reg << 8 | (uint32_t)ide_sect_addr0_reg;
                  ide_byte_addr *= 512;
                }
                break;
              case 0x30:
                if(ide_state == IDE_IDLE){
                  ide_state = IDE_WRITING;
                  ide_status = 0x08; // not busy, writing process not ended
                  ide_byte_count = 0;
                  ide_byte_addr = ((uint32_t)ide_sect_addr3_reg & 0x0F) << 24 | (uint32_t)ide_sect_addr2_reg << 16 | (uint32_t)ide_sect_addr1_reg << 8 | (uint32_t)ide_sect_addr0_reg;
                  ide_byte_addr *= 512;
                }
                break;
            }
            break;
        }
      }
    }
  }
}

void ide_write_to_disk(){
  FILE *fp;

  if((fp = fopen("disk.bin", "wb+")) == NULL){
    printf("\nerror: unable to create local disk file.\n");
    return;
  }

  fwrite(ide_disk, sizeof(uint8_t), IDE_DISK_SIZE, fp);
}

// rtc emulation - added with chatgpt
void process_rtc_cycle(){
  uint8_t rtc_reg_addr;

  rtc_reg_addr = physical_addr & 0x000F; // ffa0..ffaf -> low nibble 0..15

  if(clk == CLK_NEGEDGE){
    if(rtc_cs){
      if(rd_r){
        // scratch RAM: ffa0..ffa7
        if(rtc_reg_addr <= 0x07){
          databus = rtc_scratch[rtc_reg_addr];
        }
        // control register: ffa8
        else if(rtc_reg_addr == 0x08){
          databus = rtc_ctrl;
        }
        // time/date registers: ffa9..ffaf
        else if(rtc_reg_addr >= 0x09 && rtc_reg_addr <= 0x0F){
          uint8_t idx = rtc_reg_addr - 0x09;

          databus = rtc_regs[idx];
        }
        else{
          databus = 0x00;
        }
      }
      else if(wr_r){
        // scratch RAM: ffa0..ffa7
        if(rtc_reg_addr <= 0x07){
          rtc_scratch[rtc_reg_addr] = databus;
        }
        // control register: ffa8
        else if(rtc_reg_addr == 0x08){
          rtc_ctrl = databus;
        }
        // time/date registers: ffa9..ffaf
        else if(rtc_reg_addr >= 0x09 && rtc_reg_addr <= 0x0F){
          uint8_t idx = rtc_reg_addr - 0x09;

          // only allow writes when W bit is set
          // bit layout: [w | r | s | cal4..cal0]
          // so w = 0x80
          if(rtc_ctrl & 0x80)
            rtc_regs[idx] = databus;
        }
      }
    }
  }
}

void latch_microcode_ctrl_word(){
  u_zf_in_src_0_r = microcode_roms[u_addr].rom_2.u_zf_in_src_0;
  u_zf_in_src_1_r = microcode_roms[u_addr].rom_2.u_zf_in_src_1;
  u_cf_in_src_0_r = microcode_roms[u_addr].rom_2.u_cf_in_src_0;
  u_cf_in_src_1_r = microcode_roms[u_addr].rom_2.u_cf_in_src_1;
  u_sf_in_src_r = microcode_roms[u_addr].rom_2.u_sf_in_src;
  u_of_in_src_r = microcode_roms[u_addr].rom_2.u_of_in_src;
  ir_wrt_r = microcode_roms[u_addr].rom_2.ir_wrt;
  status_flags_wrt_r = microcode_roms[u_addr].rom_2.status_flags_wrt;
  
  shift_src_0_r = microcode_roms[u_addr].rom_3.shift_src_0;
  shift_src_1_r = microcode_roms[u_addr].rom_3.shift_src_1;
  shift_src_2_r = microcode_roms[u_addr].rom_3.shift_src_2;
  zbus_in_src_0_r = microcode_roms[u_addr].rom_3.zbus_in_src_0;
  zbus_in_src_1_r = microcode_roms[u_addr].rom_3.zbus_in_src_1;
  alu_a_src_0_r = microcode_roms[u_addr].rom_3.alu_a_src_0;
  alu_a_src_1_r = microcode_roms[u_addr].rom_3.alu_a_src_1;
  alu_a_src_2_r = microcode_roms[u_addr].rom_3.alu_a_src_2;
  
  alu_a_src_3_r = microcode_roms[u_addr].rom_4.alu_a_src_3;
  alu_a_src_4_r = microcode_roms[u_addr].rom_4.alu_a_src_4;
  alu_a_src_5_r = microcode_roms[u_addr].rom_4.alu_a_src_5;
  alu_op_0_r = microcode_roms[u_addr].rom_4.alu_op_0;
  alu_op_1_r = microcode_roms[u_addr].rom_4.alu_op_1;
  alu_op_2_r = microcode_roms[u_addr].rom_4.alu_op_2;
  alu_op_3_r = microcode_roms[u_addr].rom_4.alu_op_3;
  alu_mode_r = microcode_roms[u_addr].rom_4.alu_mode;
  
  alu_cf_in_src0_r = microcode_roms[u_addr].rom_5.alu_cf_in_src0;
  alu_cf_in_src1_r = microcode_roms[u_addr].rom_5.alu_cf_in_src1;
  alu_cf_in_invert_r = microcode_roms[u_addr].rom_5.alu_cf_in_invert;
  zf_in_src_0_r = microcode_roms[u_addr].rom_5.zf_in_src_0;
  zf_in_src_1_r = microcode_roms[u_addr].rom_5.zf_in_src_1;
  alu_cf_out_invert_r = microcode_roms[u_addr].rom_5.alu_cf_out_invert;
  cf_in_src_0_r = microcode_roms[u_addr].rom_5.cf_in_src_0;
  cf_in_src_1_r = microcode_roms[u_addr].rom_5.cf_in_src_1;
  
  cf_in_src_2_r = microcode_roms[u_addr].rom_6.cf_in_src_2;
  sf_in_src_0_r = microcode_roms[u_addr].rom_6.sf_in_src_0;
  sf_in_src_1_r = microcode_roms[u_addr].rom_6.sf_in_src_1;
  of_in_src_0_r = microcode_roms[u_addr].rom_6.of_in_src_0;
  of_in_src_1_r = microcode_roms[u_addr].rom_6.of_in_src_1;
  of_in_src_2_r = microcode_roms[u_addr].rom_6.of_in_src_2;
  rd_r = microcode_roms[u_addr].rom_6.rd;
  wr_r = microcode_roms[u_addr].rom_6.wr;

  alu_b_src_0_r = microcode_roms[u_addr].rom_7.alu_b_src_0;
  alu_b_src_1_r = microcode_roms[u_addr].rom_7.alu_b_src_1;
  alu_b_src_2_r = microcode_roms[u_addr].rom_7.alu_b_src_2;
  display_reg_load_r = microcode_roms[u_addr].rom_7.display_reg_load;
  dl_wrt_r = microcode_roms[u_addr].rom_7.dl_wrt;
  dh_wrt_r = microcode_roms[u_addr].rom_7.dh_wrt;
  cl_wrt_r = microcode_roms[u_addr].rom_7.cl_wrt;
  ch_wrt_r = microcode_roms[u_addr].rom_7.ch_wrt;
  
  bl_wrt_r = microcode_roms[u_addr].rom_8.bl_wrt;
  bh_wrt_r = microcode_roms[u_addr].rom_8.bh_wrt;
  al_wrt_r = microcode_roms[u_addr].rom_8.al_wrt;
  ah_wrt_r = microcode_roms[u_addr].rom_8.ah_wrt;
  mdr_in_src_r = microcode_roms[u_addr].rom_8.mdr_in_src;
  mdr_out_src_r = microcode_roms[u_addr].rom_8.mdr_out_src;
  mdr_out_en_r = microcode_roms[u_addr].rom_8.mdr_out_en;
  mdrl_wrt_r = microcode_roms[u_addr].rom_8.mdrl_wrt;
  
  mdrh_wrt_r = microcode_roms[u_addr].rom_9.mdrh_wrt;
  tdrl_wrt_r = microcode_roms[u_addr].rom_9.tdrl_wrt;
  tdrh_wrt_r = microcode_roms[u_addr].rom_9.tdrh_wrt;
  dil_wrt_r = microcode_roms[u_addr].rom_9.dil_wrt;
  dih_wrt_r = microcode_roms[u_addr].rom_9.dih_wrt;
  sil_wrt_r = microcode_roms[u_addr].rom_9.sil_wrt;
  sih_wrt_r = microcode_roms[u_addr].rom_9.sih_wrt;
  marl_wrt_r = microcode_roms[u_addr].rom_9.marl_wrt;
  
  marh_wrt_r = microcode_roms[u_addr].rom_10.marh_wrt;
  bpl_wrt_r = microcode_roms[u_addr].rom_10.bpl_wrt;
  bph_wrt_r = microcode_roms[u_addr].rom_10.bph_wrt;
  pcl_wrt_r = microcode_roms[u_addr].rom_10.pcl_wrt;
  pch_wrt_r = microcode_roms[u_addr].rom_10.pch_wrt;
  spl_wrt_r = microcode_roms[u_addr].rom_10.spl_wrt;
  sph_wrt_r = microcode_roms[u_addr].rom_10.sph_wrt;
  unused0_r = microcode_roms[u_addr].rom_10.unused0;
  
  unused1_r = microcode_roms[u_addr].rom_11.unused1;
  irq_vector_wrt_r = microcode_roms[u_addr].rom_11.irq_vector_wrt;
  irq_masks_wrt_r = microcode_roms[u_addr].rom_11.irq_masks_wrt;
  mar_in_src_r = microcode_roms[u_addr].rom_11.mar_in_src;
  int_ack_r = microcode_roms[u_addr].rom_11.int_ack;
  clear_all_ints_r = microcode_roms[u_addr].rom_11.clear_all_ints;
  ptb_wrt_r = microcode_roms[u_addr].rom_11.ptb_wrt;
  page_table_we_r = microcode_roms[u_addr].rom_11.page_table_we;
  
  mdr_to_pagetable_data_buffer_r = microcode_roms[u_addr].rom_12.mdr_to_pagetable_data_buffer;
  force_user_ptb_r = microcode_roms[u_addr].rom_12.force_user_ptb;
  unused2_r = microcode_roms[u_addr].rom_12.unused2;
  unused3_r = microcode_roms[u_addr].rom_12.unused3;
  unused4_r = microcode_roms[u_addr].rom_12.unused4;
  unused5_r = microcode_roms[u_addr].rom_12.unused5;
  gl_wrt_r = microcode_roms[u_addr].rom_12.gl_wrt;
  gh_wrt_r = microcode_roms[u_addr].rom_12.gh_wrt;
  
  immy_0_r = microcode_roms[u_addr].rom_13.immy_0;
  immy_1_r = microcode_roms[u_addr].rom_13.immy_1;
  immy_2_r = microcode_roms[u_addr].rom_13.immy_2;
  immy_3_r = microcode_roms[u_addr].rom_13.immy_3;
  immy_4_r = microcode_roms[u_addr].rom_13.immy_4;
  immy_5_r = microcode_roms[u_addr].rom_13.immy_5;
  immy_6_r = microcode_roms[u_addr].rom_13.immy_6;
  immy_7_r = microcode_roms[u_addr].rom_13.immy_7;
}

void print_clk(){
  switch(clk){
    case CLK_LOW:
      printf("clk         : LOW\n");
      break;
    case CLK_POSEDGE:
      printf("clk         : POSEDGE\n");
      break;
    case CLK_HIGH:
      printf("clk         : HIGH\n");
      break;
    case CLK_NEGEDGE:
      printf("clk         : NEGEDGE\n");
      break;
  }
}

void print_state(){
  printf("\n\r");
  printf("typ         : %d, %d\n", microcode_roms[u_addr].rom_0.typ_1, microcode_roms[u_addr].rom_0.typ_0);  
  printf("uaddr       : %d (%d)\n", u_addr, u_addr & 0x3F);  
  printf("uaddr hex   : %x (%x)\n", u_addr, u_addr & 0x3F);  
  printf("ir          : 0x%02x - %s\n", ir, opcodes[ir].name);
  printf("pc          : 0x%04x\n", (pc_h << 8) | pc_l);
  printf("ptb         : 0x%02x\n", ptb);
  printf("regs        : a(%x), b(%x), c(%x), d(%x), g(%x), ssp(%x), sp(%x), bp(%x), si(%x), di(%x)\n", ah<<8|al, bh<<8|bl, ch<<8|cl, dh<<8|dl, gh<<8|gl, ssp_h<<8|ssp_l, sp_h<<8|sp_l, bp_h<<8|bp_l, si_h<<8|si_l, di_h<<8|di_l);
  printf("status      : 0x%02x\n", status.byte);
  printf("status      : dma ack(%d),irq en(%d), mode(%d), paging(%d), halt(%d), display(%d), dir(%d)\n", status.dma_ack, status.irq_en, status.cpu_mode, status.paging_en, status.halt, status.display_reg_load, status.dir);
  printf("flags       : zf(%d), cf(%d), sf(%d), of(%d)\n", arith_flags.zf, arith_flags.cf, arith_flags.sf, arith_flags.of);
  printf("u-flags     : zf(%d), cf(%d), sf(%d), of(%d)\n", u_flags.zf, u_flags.cf, u_flags.sf, u_flags.of);
  printf("xbus        : 0x%02x\n", xbus);
  printf("ybus        : 0x%02x\n", ybus);
  printf("zbus        : 0x%02x\n", zbus);
  printf("mar         : 0x%02x%02x\n", mar_h, mar_l);
  printf("mdr         : 0x%02x%02x\n", mdr_h, mdr_l);
  printf("tdr         : 0x%02x%02x\n", tdr_h, tdr_l);
  printf("rd          : %u\n", rd_r);
  printf("wr          : %u\n", wr_r);
  printf("mem_io      : %u\n", mem_io);
  printf("phys addr   : 0x%x\n", physical_addr);
  printf("bios rom cs : %d\n", bios_rom_cs);
  printf("bios ram cs : %d\n", bios_ram_cs);
  printf("ram cs      : %d\n", ram_cs);
  printf("uart0 cs    : %d\n", uart0_cs);
  printf("uart1 cs    : %d\n", uart1_cs);
  printf("ide cs      : %d\n", ide_cs);
  printf("irq inputs  : 0x%02x\n", irq_inputs);
  printf("irq masks   : 0x%02x\n", irq_masks);
}

void load_microcode_roms(void){
  char filename[256];

  printf("Loading microcode ROMS...");
  for(int rom = 0; rom < 14; rom++){
    snprintf(filename, sizeof(filename), "../hardware/photon/roms/rom%d", rom);

    FILE *fp = fopen(filename, "rb");
    if(!fp){
      fprintf(stderr, "\nERROR: cannot open '%s': %s\n", filename, strerror(errno));
      exit(1);
    }

    size_t rom_addr = 0;
    int c;
    while((c = fgetc(fp)) != EOF){
      if(rom_addr >= 16384) break;

      uint8_t b = (uint8_t)c;
      switch(rom){
        case 0:  microcode_roms[rom_addr].rom_0.byte  = b; break;
        case 1:  microcode_roms[rom_addr].rom_1.byte  = b; break;
        case 2:  microcode_roms[rom_addr].rom_2.byte  = b; break;
        case 3:  microcode_roms[rom_addr].rom_3.byte  = b; break;
        case 4:  microcode_roms[rom_addr].rom_4.byte  = b; break;
        case 5:  microcode_roms[rom_addr].rom_5.byte  = b; break;
        case 6:  microcode_roms[rom_addr].rom_6.byte  = b; break;
        case 7:  microcode_roms[rom_addr].rom_7.byte  = b; break;
        case 8:  microcode_roms[rom_addr].rom_8.byte  = b; break;
        case 9:  microcode_roms[rom_addr].rom_9.byte  = b; break;
        case 10: microcode_roms[rom_addr].rom_10.byte = b; break;
        case 11: microcode_roms[rom_addr].rom_11.byte = b; break;
        case 12: microcode_roms[rom_addr].rom_12.byte = b; break;
        case 13: microcode_roms[rom_addr].rom_13.byte = b; break;
        default: break;
      }

      rom_addr++;
    }

    if(ferror(fp)){
      fprintf(stderr, "\nERROR: read error on '%s': %s\n", filename, strerror(errno));
      fclose(fp);
      exit(1);
    }

    fclose(fp);
  }

  printf(" [OK]\n");
}

void load_bios_memory(void){
  printf("Loading BIOS ROM...");
  size_t n = read_file_all_fgetc_or_die("../software/obj/bios.obj", bios_rom, sizeof(bios_rom));
  printf(" [OK] (%zu bytes)\n", n);
}

void load_ide_disk(void){
  FILE *fp = fopen("disk.bin", "r");
  size_t n;
  char *ide_filename = "../disk_backups/03Oct2023";

  /* File may be any size; read only up to IDE_DISK_SIZE bytes. */
  if(fp){
    printf("Loading IDE disk image: disk.bin");
    n = read_file_up_to_fgetc_or_die("disk.bin", ide_disk, (size_t)IDE_DISK_SIZE);
    fclose(fp);
  }
  else{
    printf("Loading IDE disk image: %s", ide_filename);
    n = read_file_up_to_fgetc_or_die(ide_filename, ide_disk, (size_t)IDE_DISK_SIZE);
  }
  //size_t n = read_file_up_to_fgetc_or_die("../solfs/disk.bin", ide_disk, (size_t)IDE_DISK_SIZE);
  printf(" [OK] (%zu bytes read, max %u)\n", n, (unsigned)IDE_DISK_SIZE);
}


static uint8_t bin_to_bcd(uint8_t v){
  return (uint8_t)(((v / 10u) << 4) | (v % 10u));
}

static uint8_t bcd_to_bin(uint8_t v){
  return (uint8_t)(((v >> 4) * 10u) + (v & 0x0F));
}

static void rtc_load_host_time(void){
  time_t now;
  struct tm *tm_now;

  now = time(NULL);
  tm_now = localtime(&now);
  if(tm_now == NULL){
    memset(rtc_regs, 0, sizeof(rtc_regs));
    return;
  }

  rtc_regs[0] = bin_to_bcd((uint8_t)tm_now->tm_sec);
  rtc_regs[1] = bin_to_bcd((uint8_t)tm_now->tm_min);
  rtc_regs[2] = bin_to_bcd((uint8_t)tm_now->tm_hour);
  rtc_regs[3] = bin_to_bcd((uint8_t)(tm_now->tm_wday));
  rtc_regs[4] = bin_to_bcd((uint8_t)tm_now->tm_mday);
  rtc_regs[5] = bin_to_bcd((uint8_t)(tm_now->tm_mon + 1));
  rtc_regs[6] = bin_to_bcd((uint8_t)(tm_now->tm_year % 100));
}