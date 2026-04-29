#ifndef EMULATOR_H
#define EMULATOR_H

#include <stdint.h>

#define ID_LEN          128
#define IDE_DISK_SIZE   8 * 1024 * 1024 // 8MB
#define ESCAPE          0x10

typedef enum{
  CLK_POSEDGE, 
  CLK_NEGEDGE
} clk_state_e;

typedef enum{
  IDE_IDLE, 
  IDE_READING, 
  IDE_WRITING
} ide_state_e;

typedef union{
  uint8_t byte;
  struct {
    uint8_t dma_ack          : 1;
    uint8_t irq_en           : 1;
    uint8_t cpu_mode         : 1;
    uint8_t paging_en        : 1;
    uint8_t halt             : 1;
    uint8_t display_reg_load : 1;
    uint8_t unused           : 1;
    uint8_t dir              : 1;
  };
} status_u;

typedef union {
  uint8_t byte;
  struct {
    uint8_t zf : 1;
    uint8_t cf : 1;
    uint8_t sf : 1;
    uint8_t of : 1;
    uint8_t    : 4;
  };
} arith_flags_u;

// alu_op combines the alu mode with the operand
typedef enum{
  alu_op_add    = 0x09,
  alu_op_sub    = 0x06,
  alu_op_and    = 0x1B,
  alu_op_or     = 0x1E,
  alu_op_xor    = 0x16,
  alu_op_a      = 0x1F,
  alu_op_b      = 0x1A,
  alu_op_not_a  = 0x10,
  alu_op_not_b  = 0x15,
  alu_op_nand   = 0x14,
  alu_op_nor    = 0x11,
  alu_op_nxor   = 0x19
} alu_op_e;

typedef struct{
  union{
    uint8_t byte;
    struct{
      uint8_t typ_0      : 1;
      uint8_t typ_1      : 1;
      uint8_t u_offset_0 : 1;
      uint8_t u_offset_1 : 1;
      uint8_t u_offset_2 : 1;
      uint8_t u_offset_3 : 1;
      uint8_t u_offset_4 : 1;
      uint8_t u_offset_5 : 1;
    };
  } rom_0;

  union{
    uint8_t byte;
    struct{
      uint8_t u_offset_6    : 1;
      uint8_t cond_invert   : 1;
      uint8_t cond_flag_src : 1;
      uint8_t cond_sel_0    : 1;
      uint8_t cond_sel_1    : 1;
      uint8_t cond_sel_2    : 1;
      uint8_t cond_sel_3    : 1;
      uint8_t escape        : 1;
    };
  } rom_1;

  union{
    uint8_t byte;
    struct{
      uint8_t u_zf_in_src_0        : 1;
      uint8_t u_zf_in_src_1        : 1;
      uint8_t u_cf_in_src_0        : 1;
      uint8_t u_cf_in_src_1        : 1;
      uint8_t u_sf_in_src          : 1;
      uint8_t u_of_in_src          : 1;
      uint8_t ir_wrt               : 1;
      uint8_t status_flags_wrt     : 1;
    };
  } rom_2;

  union{
    uint8_t byte;
    struct{
      uint8_t shift_src_0      : 1;
      uint8_t shift_src_1      : 1;
      uint8_t shift_src_2      : 1;
      uint8_t zbus_in_src_0    : 1;
      uint8_t zbus_in_src_1    : 1;
      uint8_t alu_a_src_0      : 1;     
      uint8_t alu_a_src_1      : 1;     
      uint8_t alu_a_src_2      : 1;
    };
  } rom_3;

  union{
    uint8_t byte;
    struct{
      uint8_t alu_a_src_3    : 1;
      uint8_t alu_a_src_4    : 1;
      uint8_t alu_a_src_5    : 1;
      uint8_t alu_op_0       : 1;
      uint8_t alu_op_1       : 1;
      uint8_t alu_op_2       : 1;
      uint8_t alu_op_3       : 1;
      uint8_t alu_mode       : 1;
    };
  } rom_4;

  union{
    uint8_t byte;
    struct{
      uint8_t alu_cf_in_src0        : 1;
      uint8_t alu_cf_in_src1        : 1;
      uint8_t alu_cf_in_invert      : 1;
      uint8_t zf_in_src_0           : 1;
      uint8_t zf_in_src_1           : 1;
      uint8_t alu_cf_out_invert     : 1;
      uint8_t cf_in_src_0           : 1;
      uint8_t cf_in_src_1           : 1;
    };
  } rom_5;

  union{
    uint8_t byte;
    struct{
      uint8_t cf_in_src_2    : 1;
      uint8_t sf_in_src_0    : 1;
      uint8_t sf_in_src_1    : 1;
      uint8_t of_in_src_0    : 1;
      uint8_t of_in_src_1    : 1;
      uint8_t of_in_src_2    : 1;
      uint8_t rd             : 1;             
      uint8_t wr             : 1;             
    };
  } rom_6;
                         
  union{
    uint8_t byte;
    struct{
      uint8_t alu_b_src_0        : 1;
      uint8_t alu_b_src_1        : 1;
      uint8_t alu_b_src_2        : 1;
      uint8_t display_reg_load   : 1;
      uint8_t dl_wrt             : 1;
      uint8_t dh_wrt             : 1;
      uint8_t cl_wrt             : 1;
      uint8_t ch_wrt             : 1;
    };
  } rom_7;

  union{
    uint8_t byte;
    struct{
      uint8_t bl_wrt         : 1;
      uint8_t bh_wrt         : 1;
      uint8_t al_wrt         : 1;
      uint8_t ah_wrt         : 1;
      uint8_t mdr_in_src     : 1;
      uint8_t mdr_out_src    : 1;
      uint8_t mdr_out_en     : 1;  
      uint8_t mdrl_wrt      : 1;  
    };
  } rom_8;

  union{
    uint8_t byte;
    struct{
      uint8_t mdrh_wrt   : 1;
      uint8_t tdrl_wrt   : 1;
      uint8_t tdrh_wrt   : 1;
      uint8_t dil_wrt    : 1;
      uint8_t dih_wrt    : 1;
      uint8_t sil_wrt    : 1;
      uint8_t sih_wrt    : 1;
      uint8_t marl_wrt   : 1;
    };
  } rom_9;

  union{
    uint8_t byte;
    struct{
      uint8_t marh_wrt   : 1;
      uint8_t bpl_wrt    : 1;
      uint8_t bph_wrt    : 1;
      uint8_t pcl_wrt    : 1;
      uint8_t pch_wrt    : 1;
      uint8_t spl_wrt    : 1;
      uint8_t sph_wrt    : 1;
      uint8_t unused0    : 1;
    };
  } rom_10;

  union{
    uint8_t byte;
    struct{
      uint8_t unused1             : 1;
      uint8_t irq_vector_wrt      : 1;
      uint8_t irq_masks_wrt       : 1;    
      uint8_t mar_in_src          : 1;
      uint8_t int_ack             : 1;    
      uint8_t clear_all_ints      : 1;
      uint8_t ptb_wrt             : 1;
      uint8_t page_table_we       : 1;
    };
  } rom_11;

  union{
    uint8_t byte;
    struct{
      uint8_t mdr_to_pagetable_data_buffer : 1;
      uint8_t force_user_ptb               : 1;
      uint8_t unused2                      : 1;
      uint8_t unused3                      : 1;
      uint8_t unused4                      : 1;
      uint8_t unused5                      : 1;
      uint8_t gl_wrt                       : 1;
      uint8_t gh_wrt                       : 1;
    };
  } rom_12;

  union{
    uint8_t byte;
    struct{
      uint8_t immy_0 : 1;
      uint8_t immy_1 : 1;
      uint8_t immy_2 : 1;
      uint8_t immy_3 : 1;
      uint8_t immy_4 : 1;
      uint8_t immy_5 : 1;
      uint8_t immy_6 : 1;
      uint8_t immy_7 : 1;
    };
  } rom_13;
} microcode_t;

typedef struct{
  char *name;
  uint8_t opcode;
} opcode_literal_t;

extern opcode_literal_t opcodes[];

extern uint8_t u_zf_in_src_0_r;
extern uint8_t u_zf_in_src_1_r;
extern uint8_t u_cf_in_src_0_r;
extern uint8_t u_cf_in_src_1_r;
extern uint8_t u_sf_in_src_r;
extern uint8_t u_of_in_src_r;
extern uint8_t ir_wrt_r;
extern uint8_t status_flags_wrt_r;

extern uint8_t shift_src_0_r;
extern uint8_t shift_src_1_r;
extern uint8_t shift_src_2_r;
extern uint8_t zbus_in_src_0_r;
extern uint8_t zbus_in_src_1_r;
extern uint8_t alu_a_src_0_r;     
extern uint8_t alu_a_src_1_r;     
extern uint8_t alu_a_src_2_r;

extern uint8_t alu_a_src_3_r;
extern uint8_t alu_a_src_4_r;
extern uint8_t alu_a_src_5_r;
extern uint8_t alu_op_0_r;
extern uint8_t alu_op_1_r;
extern uint8_t alu_op_2_r;
extern uint8_t alu_op_3_r;
extern uint8_t alu_mode_r;

extern uint8_t alu_cf_in_src0_r;
extern uint8_t alu_cf_in_src1_r;
extern uint8_t alu_cf_in_invert_r;
extern uint8_t zf_in_src_0_r;
extern uint8_t zf_in_src_1_r;
extern uint8_t alu_cf_out_invert_r;
extern uint8_t cf_in_src_0_r;
extern uint8_t cf_in_src_1_r;

extern uint8_t cf_in_src_2_r;
extern uint8_t sf_in_src_0_r;
extern uint8_t sf_in_src_1_r;
extern uint8_t of_in_src_0_r;
extern uint8_t of_in_src_1_r;
extern uint8_t of_in_src_2_r;
extern uint8_t rd_r;             
extern uint8_t wr_r;             

extern uint8_t alu_b_src_0_r;
extern uint8_t alu_b_src_1_r;
extern uint8_t alu_b_src_2_r;
extern uint8_t display_reg_load_r;
extern uint8_t dl_wrt_r;
extern uint8_t dh_wrt_r;
extern uint8_t cl_wrt_r;
extern uint8_t ch_wrt_r;

extern uint8_t bl_wrt_r;
extern uint8_t bh_wrt_r;
extern uint8_t al_wrt_r;
extern uint8_t ah_wrt_r;
extern uint8_t mdr_in_src_r;
extern uint8_t mdr_out_src_r;
extern uint8_t mdr_out_en_r;  
extern uint8_t mdrl_wrt_r;  

extern uint8_t mdrh_wrt_r;
extern uint8_t tdrl_wrt_r;
extern uint8_t tdrh_wrt_r;
extern uint8_t dil_wrt_r;
extern uint8_t dih_wrt_r;
extern uint8_t sil_wrt_r;
extern uint8_t sih_wrt_r;
extern uint8_t marl_wrt_r;

extern uint8_t marh_wrt_r;
extern uint8_t bpl_wrt_r;
extern uint8_t bph_wrt_r;
extern uint8_t pcl_wrt_r;
extern uint8_t pch_wrt_r;
extern uint8_t spl_wrt_r;
extern uint8_t sph_wrt_r;
extern uint8_t unused0_r;

extern uint8_t unused1_r;
extern uint8_t irq_vector_wrt_r;
extern uint8_t irq_masks_wrt_r;    
extern uint8_t mar_in_src_r;
extern uint8_t int_ack_r;    
extern uint8_t clear_all_ints_r;
extern uint8_t ptb_wrt_r;
extern uint8_t page_table_we_r;

extern uint8_t mdr_to_pagetable_data_buffer_r;
extern uint8_t force_user_ptb_r;
extern uint8_t unused2_r;
extern uint8_t unused3_r;
extern uint8_t unused4_r;
extern uint8_t unused5_r;
extern uint8_t gl_wrt_r;
extern uint8_t gh_wrt_r;

extern uint8_t immy_0_r;
extern uint8_t immy_1_r;
extern uint8_t immy_2_r;
extern uint8_t immy_3_r;
extern uint8_t immy_4_r;
extern uint8_t immy_5_r;
extern uint8_t immy_6_r;
extern uint8_t immy_7_r;

// all microcode roms
extern microcode_t microcode_roms[64 * 256];

void reset();
void step_clock();

void load_bios_memory();
void load_ide_disk();
void load_microcode_roms();
void emulator_cycle(int64_t num_cycles);
int emulator_setup();
void emulator_finish();

void latch_microcode_ctrl_word();

void procees_irqs();
void process_cpu_cycle();
void process_address_decoder();
void process_memory_cycle();
void process_ide_cycle();
void ide_write_to_disk();
void process_uart_cycle();
void process_rtc_cycle();

void print_clk();
void print_state();


uint8_t bin_to_bcd(uint8_t v);
uint8_t bcd_to_bin(uint8_t v);
void rtc_load_host_time(void);

#endif