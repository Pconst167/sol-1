#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>
#include "def.h"

uint16_t a, b, c, d, g;
uint16_t pc, sp, ssp, bp;
uint16_t si, di;
uint16_t tdr, mdr, mar;
uint8_t  ir, ptb;
uint8_t  flags;
status_u status;

uint8_t zbus, xbus, ybus, alu_out;

uint16_t micro_addr;
uint8_t micro_condition;
uint8_t irq_pending;
uint8_t any_interruption;
uint8_t irq_req;
uint8_t dma_req;
uint8_t status_irq_enable;

uint8_t alu_a, alu_b, alu_y;
alu_op_e alu_op;
uint8_t alu_a_src, alu_b_src;

unsigned char arst;
unsigned char reset;
unsigned char clk;
unsigned char memory[256][65536];
unsigned char bios_memory[65536];
unsigned char databus;
uint32_t physical_addr; // physical address is 22 bits wide for a max access of 4MB
uint8_t page_table[256];
uint8_t page_table_addr_source;

unsigned char program_in[65536];
char int_pending;

int main(int argc, char *argv[]){
  if(argc > 1) load_program(argv[1]);  
  else{
    printf("Usage: emulator [filename]\n");
    return 0;
  }

  puts("Sol-1 Emulator starting...");
  load_microcode_roms();
  load_bios_memory();

  do_reset();
  main_loop();

  return 0;
}

void load_program(char *filename){
  unsigned char *p;
  FILE *fp;
  int i;
  
  if((fp = fopen(filename, "rb")) == NULL){
    printf("%s: Source file not found.\n", filename);
    exit(1);
  }
  
  p = program_in;
  i = 0;
  do{
    *(p++) = getc(fp);
    i++;
  } while(!feof(fp));
  *(p - 1) = '\0'; // overwrite the EOF char with NULL
  fclose(fp);

  puts("Program loaded successfully.");
}

void load_bios_memory(){
  unsigned char *p;
  FILE *fp;
  int i;
  
  puts("Loading BIOS memory...");
  if((fp = fopen("../software/obj/bios.obj", "rb")) == NULL){
    printf("BIOS file not found.\n");
    exit(1);
  }
  
  p = bios_memory;
  i = 0;
  do{
    *(p++) = getc(fp);
    i++;
  } while(!feof(fp));
  *(p - 1) = '\0'; // overwrite the EOF char with NULL
  fclose(fp);

  puts("BIOS memory loaded successfully.");
}

void do_reset(){
  a = 0;
  b = 0;
  c = 0;
  d = 0;
  g = 0;
  pc = 0;
  sp = 0;
  ssp = 0;
  bp = 0;
  si = 0;
  di = 0;
  tdr = 0;
  mdr = 0;
  mar = 0;
  ir = 0;
}

void main_loop(){
  for(int i = 0; i < 10; i++){
    clk = ~clk;
    execute_micro_instruction();

  }
}

void do_cycle(){

  int_pending = irq_req && status_irq_enable;
  any_interruption = dma_req || int_pending;

}

void execute_micro_instruction(){
  uint16_t micro_offset;
  char mux_a, mux_b;

  printf("\n\n\nClk: %c\n", clk ? 'H' : 'L');  

  // Rising edge
  // Register Writes
  if(clk){
    update_control_bits(); 

    micro_offset = u_offset_0 | u_offset_1 << 1 | u_offset_2 << 2 | u_offset_3 << 3 | u_offset_4 << 4 | u_offset_5 << 5 | u_offset_6 << 6 |
    // below is for sign-extending micro_address.
                   u_offset_6 << 15 | u_offset_6 << 14 | u_offset_6 << 13 | u_offset_6 << 12 | u_offset_6 << 11 | u_offset_6 << 10 | u_offset_6 << 9 |
                   u_offset_6 << 8 | u_offset_6 << 7;

    // micro address next
    mux_a = typ_1 && (typ_0 || !typ_0 && any_interruption);
    mux_b = typ_1 && !typ_0;

    if(typ_1 == 0 && typ_0 == 0){
      micro_addr += micro_offset;
    }
    else if(typ_1 == 0 && typ_0 == 1){
      if(micro_condition == 0) micro_addr += 1;
      else micro_addr += micro_offset;
    }
    else if(typ_1 == 1 && typ_0 == 0){
      micro_addr = 16;
    }
    else if(typ_1 == 1 && typ_0 == 1){
      micro_addr = ir << 6;
    }

    // register writes
    if(ir_wrt) ir = databus;
    if(al_wrt) a = (a & 0xFF00) | zbus;
    if(ah_wrt) a = (a & 0x00FF) | (zbus << 8);
    if(bl_wrt) b = (b & 0xFF00) | zbus;
    if(bh_wrt) b = (b & 0x00FF) | (zbus << 8);
    if(cl_wrt) c = (c & 0xFF00) | zbus;
    if(ch_wrt) c = (c & 0x00FF) | (zbus << 8);
    if(dl_wrt) d = (d & 0xFF00) | zbus;
    if(dh_wrt) d = (d & 0x00FF) | (zbus << 8);

    if(pcl_wrt) pc = (pc & 0xFF00) | zbus;
    if(pch_wrt) pc = (pc & 0x00FF) | (zbus << 8);
    if(marl_wrt) mar = (mar & 0xFF00) | zbus;
    if(marh_wrt) mar = (mar & 0x00FF) | (zbus << 8);
    if(mdrl_wrt){
      if(mdr_in_src) mdr = (mdr & 0xFF00) | databus;
      else mdr = (mdr & 0xFF00) | zbus;
    }
    if(mdrh_wrt){
      if(mdr_in_src) mdr = (mdr & 0x00FF) | databus;
      else mdr = (mdr & 0x00FF) | (zbus << 8);
    }
    if(status_flags_wrt) status.byte = zbus;

  }
  // Falling edge
  // Update Microcode Word D-FlipFlops
  // Update any logic that depends on immediate values of micro-control word
  if(!clk){
    alu_op = alu_op_3 << 3 | alu_op_2 << 2 | alu_op_1 << 1 | alu_op_0;
    alu_a_src = alu_a_src_5 << 5 | alu_a_src_4 << 4 | alu_a_src_3 << 3 | alu_a_src_2 << 2 | alu_a_src_1 << 1 | alu_a_src_0;
    alu_b_src = alu_b_src_2 << 2 | alu_b_src_1 << 1 | alu_b_src_0;
    alu_a = 0;
    alu_b = 0;
    switch(alu_op){
      case(alu_op_add): alu_y = alu_a + alu_b;
    }

    page_table_addr_source = force_user_ptb || status.cpu_mode;

    if(rd){
      databus = bios_memory[mar];
      printf("databus: %x\n", databus);
    }
    else if(wr){
      bios_memory[mar] = databus;
      printf("databus: %x\n", databus);
    }
  }


  printf("Typ: %d, %d\n", typ_1, typ_0);  
  printf("uaddr: %d\n", micro_addr);  
  printf("uaddr: %2x : %d\n", micro_addr >> 6, micro_addr & 0x3F);  
  printf("IR: %x\n", ir);
  printf("PC: %x\n", pc);
}

void microcode_step(){

}

void update_control_bits(){
  typ_0                        = microcode[micro_addr].rom_0.typ_0      ;
  typ_1                        = microcode[micro_addr].rom_0.typ_1      ;
  u_offset_0                   = microcode[micro_addr].rom_0.u_offset_0 ;
  u_offset_1                   = microcode[micro_addr].rom_0.u_offset_1 ;
  u_offset_2                   = microcode[micro_addr].rom_0.u_offset_2 ;
  u_offset_3                   = microcode[micro_addr].rom_0.u_offset_3 ;
  u_offset_4                   = microcode[micro_addr].rom_0.u_offset_4 ;
  u_offset_5                   = microcode[micro_addr].rom_0.u_offset_5 ;
  
  u_offset_6                   = microcode[micro_addr].rom_1.u_offset_6   ;
  cond_invert                  = microcode[micro_addr].rom_1.cond_invert  ;
  cond_flag_src                = microcode[micro_addr].rom_1.cond_flag_src;
  cond_sel_0                   = microcode[micro_addr].rom_1.cond_sel_0   ;
  cond_sel_1                   = microcode[micro_addr].rom_1.cond_sel_1   ;
  cond_sel_2                   = microcode[micro_addr].rom_1.cond_sel_2   ;
  cond_sel_3                   = microcode[micro_addr].rom_1.cond_sel_3   ;
  escape                       = microcode[micro_addr].rom_1.escape       ;
  
  u_zf_in_src_0                = microcode[micro_addr].rom_2.u_zf_in_src_0    ;
  u_zf_in_src_1                = microcode[micro_addr].rom_2.u_zf_in_src_1    ;
  u_cf_in_src_0                = microcode[micro_addr].rom_2.u_cf_in_src_0    ;
  u_cf_in_src_1                = microcode[micro_addr].rom_2.u_cf_in_src_1    ;
  u_sf_in_src                  = microcode[micro_addr].rom_2.u_sf_in_src      ;
  u_of_in_src                  = microcode[micro_addr].rom_2.u_of_in_src      ;
  ir_wrt                       = microcode[micro_addr].rom_2.ir_wrt           ;
  status_flags_wrt             = microcode[micro_addr].rom_2.status_flags_wrt ;
  
  shift_src_0                  = microcode[micro_addr].rom_3.shift_src_0      ;
  shift_src_1                  = microcode[micro_addr].rom_3.shift_src_1      ;
  shift_src_2                  = microcode[micro_addr].rom_3.shift_src_2      ;
  zbus_in_src_0                = microcode[micro_addr].rom_3.zbus_in_src_0    ;
  zbus_in_src_1                = microcode[micro_addr].rom_3.zbus_in_src_1    ;
  alu_a_src_0                  = microcode[micro_addr].rom_3.alu_a_src_0      ;
  alu_a_src_1                  = microcode[micro_addr].rom_3.alu_a_src_1      ;
  alu_a_src_2                  = microcode[micro_addr].rom_3.alu_a_src_2      ;
  
  alu_a_src_3                  = microcode[micro_addr].rom_4.alu_a_src_3    ;
  alu_a_src_4                  = microcode[micro_addr].rom_4.alu_a_src_4    ;
  alu_a_src_5                  = microcode[micro_addr].rom_4.alu_a_src_5    ;
  alu_op_0                     = microcode[micro_addr].rom_4.alu_op_0       ;
  alu_op_1                     = microcode[micro_addr].rom_4.alu_op_1       ;
  alu_op_2                     = microcode[micro_addr].rom_4.alu_op_2       ;
  alu_op_3                     = microcode[micro_addr].rom_4.alu_op_3       ;
  alu_mode                     = microcode[micro_addr].rom_4.alu_mode       ;
  
  alu_cf_in_src0               = microcode[micro_addr].rom_5.alu_cf_in_src0        ;
  alu_cf_in_src1               = microcode[micro_addr].rom_5.alu_cf_in_src1        ;
  alu_cf_in_invert             = microcode[micro_addr].rom_5.alu_cf_in_invert      ;
  zf_in_src_0                  = microcode[micro_addr].rom_5.zf_in_src_0           ;
  zf_in_src_1                  = microcode[micro_addr].rom_5.zf_in_src_1           ;
  alu_cf_out_invert            = microcode[micro_addr].rom_5.alu_cf_out_invert     ;
  cf_in_src_0                  = microcode[micro_addr].rom_5.cf_in_src_0           ;
  cf_in_src_1                  = microcode[micro_addr].rom_5.cf_in_src_1           ;
  
  cf_in_src_2                  = microcode[micro_addr].rom_6.cf_in_src_2    ;
  sf_in_src_0                  = microcode[micro_addr].rom_6.sf_in_src_0    ;
  sf_in_src_1                  = microcode[micro_addr].rom_6.sf_in_src_1    ;
  of_in_src_0                  = microcode[micro_addr].rom_6.of_in_src_0    ;
  of_in_src_1                  = microcode[micro_addr].rom_6.of_in_src_1    ;
  of_in_src_2                  = microcode[micro_addr].rom_6.of_in_src_2    ;
  rd                           = microcode[micro_addr].rom_6.rd             ;
  wr                           = microcode[micro_addr].rom_6.wr             ;

  alu_b_src_0                  = microcode[micro_addr].rom_7.alu_b_src_0        ;
  alu_b_src_1                  = microcode[micro_addr].rom_7.alu_b_src_1        ;
  alu_b_src_2                  = microcode[micro_addr].rom_7.alu_b_src_2        ;
  display_reg_load             = microcode[micro_addr].rom_7.display_reg_load   ;
  dl_wrt                       = microcode[micro_addr].rom_7.dl_wrt             ;
  dh_wrt                       = microcode[micro_addr].rom_7.dh_wrt             ;
  cl_wrt                       = microcode[micro_addr].rom_7.cl_wrt             ;
  ch_wrt                       = microcode[micro_addr].rom_7.ch_wrt             ;
  
  bl_wrt                       = microcode[micro_addr].rom_8.bl_wrt         ;
  bh_wrt                       = microcode[micro_addr].rom_8.bh_wrt         ;
  al_wrt                       = microcode[micro_addr].rom_8.al_wrt         ;
  ah_wrt                       = microcode[micro_addr].rom_8.ah_wrt         ;
  mdr_in_src                   = microcode[micro_addr].rom_8.mdr_in_src     ;
  mdr_out_src                  = microcode[micro_addr].rom_8.mdr_out_src    ;
  mdr_out_en                   = microcode[micro_addr].rom_8.mdr_out_en       ;
  mdrl_wrt                    = microcode[micro_addr].rom_8.mdrl_wrt        ;
  
  mdrh_wrt                    = microcode[micro_addr].rom_9.mdrh_wrt   ;
  tdrl_wrt                    = microcode[micro_addr].rom_9.tdrl_wrt   ;
  tdrh_wrt                    = microcode[micro_addr].rom_9.tdrh_wrt   ;
  dil_wrt                     = microcode[micro_addr].rom_9.dil_wrt    ;
  dih_wrt                     = microcode[micro_addr].rom_9.dih_wrt    ;
  sil_wrt                     = microcode[micro_addr].rom_9.sil_wrt    ;
  sih_wrt                     = microcode[micro_addr].rom_9.sih_wrt    ;
  marl_wrt                    = microcode[micro_addr].rom_9.marl_wrt   ;
  
  marh_wrt                    = microcode[micro_addr].rom_10.marh_wrt   ;
  bpl_wrt                     = microcode[micro_addr].rom_10.bpl_wrt    ;
  bph_wrt                     = microcode[micro_addr].rom_10.bph_wrt    ;
  pcl_wrt                     = microcode[micro_addr].rom_10.pcl_wrt    ;
  pch_wrt                     = microcode[micro_addr].rom_10.pch_wrt    ;
  spl_wrt                     = microcode[micro_addr].rom_10.spl_wrt    ;
  sph_wrt                     = microcode[micro_addr].rom_10.sph_wrt    ;
  unused                       = microcode[micro_addr].rom_10.unused      ;
  
  unused                       = microcode[micro_addr].rom_11.unused           ;
  irq_vector_wrt               = microcode[micro_addr].rom_11.irq_vector_wrt   ;
  irq_masks_wrt                = microcode[micro_addr].rom_11.irq_masks_wrt    ;
  mar_in_src                   = microcode[micro_addr].rom_11.mar_in_src       ;
  int_ack                      = microcode[micro_addr].rom_11.int_ack          ;
  clear_all_ints               = microcode[micro_addr].rom_11.clear_all_ints   ;
  ptb_wrt                      = microcode[micro_addr].rom_11.ptb_wrt          ;
  page_table_we                = microcode[micro_addr].rom_11.page_table_we    ;
  
  mdr_to_pagetable_data_buffer = microcode[micro_addr].rom_12.mdr_to_pagetable_data_buffer ;
  force_user_ptb               = microcode[micro_addr].rom_12.force_user_ptb               ;
  unused2                      = microcode[micro_addr].rom_12.unused2                      ;
  unused3                      = microcode[micro_addr].rom_12.unused3                      ;
  unused4                      = microcode[micro_addr].rom_12.unused4                      ;
  unused5                      = microcode[micro_addr].rom_12.unused5                      ;
  gl_wrt                       = microcode[micro_addr].rom_12.gl_wrt                       ;
  gh_wrt                       = microcode[micro_addr].rom_12.gh_wrt                       ;
  
  immy_0                       = microcode[micro_addr].rom_13.immy_0 ;
  immy_1                       = microcode[micro_addr].rom_13.immy_1 ;
  immy_2                       = microcode[micro_addr].rom_13.immy_2 ;
  immy_3                       = microcode[micro_addr].rom_13.immy_3 ;
  immy_4                       = microcode[micro_addr].rom_13.immy_4 ;
  immy_5                       = microcode[micro_addr].rom_13.immy_5 ;
  immy_6                       = microcode[micro_addr].rom_13.immy_6 ;
  immy_7                       = microcode[micro_addr].rom_13.immy_7 ;
}

void load_microcode_roms(){
  FILE *fp;
  int rom, rom_addr;
  char filename[256];
  
  puts("Loading microcode ROMS...");
  for(rom = 0; rom < 14; rom++){
    sprintf(filename, "../hardware/microcode_assembler/output/sol-1_ROM%d.bin", rom);
    if((fp = fopen(filename, "rb")) == NULL){
      printf("Microcode binary file not found.\n");
      exit(1);
    }
    rom_addr = 0;
    switch(rom){
      case 0:
        do{
          microcode[rom_addr].rom_0.as_array = getc(fp);
          rom_addr++;
        } while(!feof(fp));
        fclose(fp);
        break;
      case 1:
        do{
          microcode[rom_addr].rom_1.as_array = getc(fp);
          rom_addr++;
        } while(!feof(fp));
        fclose(fp);
        break;
      case 2:
        do{
          microcode[rom_addr].rom_2.as_array = getc(fp);
          rom_addr++;
        } while(!feof(fp));
        fclose(fp);
        break;
      case 3:
        do{
          microcode[rom_addr].rom_3.as_array = getc(fp);
          rom_addr++;
        } while(!feof(fp));
        fclose(fp);
        break;
      case 4:
        do{
          microcode[rom_addr].rom_4.as_array = getc(fp);
          rom_addr++;
        } while(!feof(fp));
        fclose(fp);
        break;
      case 5:
        do{
          microcode[rom_addr].rom_5.as_array = getc(fp);
          rom_addr++;
        } while(!feof(fp));
        fclose(fp);
        break;
      case 6:
        do{
          microcode[rom_addr].rom_6.as_array = getc(fp);
          rom_addr++;
        } while(!feof(fp));
        fclose(fp);
        break;
      case 7:
        do{
          microcode[rom_addr].rom_7.as_array = getc(fp);
          rom_addr++;
        } while(!feof(fp));
        fclose(fp);
        break;
      case 8:
        do{
          microcode[rom_addr].rom_8.as_array = getc(fp);
          rom_addr++;
        } while(!feof(fp));
        fclose(fp);
        break;
      case 9:
        do{
          microcode[rom_addr].rom_9.as_array = getc(fp);
          rom_addr++;
        } while(!feof(fp));
        fclose(fp);
        break;
      case 10:
        do{
          microcode[rom_addr].rom_10.as_array = getc(fp);
          rom_addr++;
        } while(!feof(fp));
        fclose(fp);
        break;
      case 11:
        do{
          microcode[rom_addr].rom_11.as_array = getc(fp);
          rom_addr++;
        } while(!feof(fp));
        fclose(fp);
        break;
      case 12:
        do{
          microcode[rom_addr].rom_12.as_array = getc(fp);
          rom_addr++;
        } while(!feof(fp));
        fclose(fp);
        break;
      case 13:
        do{
          microcode[rom_addr].rom_13.as_array = getc(fp);
          rom_addr++;
        } while(!feof(fp));
        fclose(fp);
        break;
    }
  }
  puts("ROMS loaded successfully.");
}
