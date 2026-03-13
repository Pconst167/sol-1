#ifndef DEF_H
#define DEF_H

#include <stdint.h>

#define ID_LEN          128
#define IDE_DISK_SIZE   8 * 1024 * 1024 // 8MB
#define ESCAPE          0x10

typedef enum{
  CLK_LOW, 
  CLK_POSEDGE, 
  CLK_HIGH, 
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

struct t_opcode{
  char *name;
  uint8_t opcode;
} opcodes[] = {
  "rst/fetch/trap/dma", 0x0,
  "setptb", 0x1,
  "pagemap", 0x2,
  "store", 0x3,
  "load", 0x4,
  "syscall u8", 0x5,
  "sysret - paging_off", 0x6,
  "call {u16, [a + i16]}", 0x7,
  "call a - supcpy", 0x8,
  "ret - paging_on", 0x9,
  "jmp {u16, [u16 + al]}", 0xa,
  "jmp {a, [u16 + bl]}", 0xb,
  "lodstat - sti", 0xc,
  "stostat - cli", 0xd,
  "lodflgs - lodmsks", 0xe,
  "stoflgs - stomsks", 0xf,
  "mov a, i16 - cla", 0x10,
  "mov a, {b, pc}", 0x11,
  "mov a, {c, g}", 0x12,
  "mov a, d - mma u16", 0x13,
  "mov a, [u16] - clb", 0x14,
  "mov a, [d]", 0x15,
  "mov a, [d + i16]", 0x16,
  "mov a, [{bp, sp} + i16]", 0x17,
  "mov a, [{bp, sp} + d]", 0x18,
  "mov al, i8", 0x19,
  "mov al, {ah, gl}", 0x1a,
  "mov al, {bl, gh}", 0x1b,
  "mov al, bh", 0x1c,
  "mov al, [u16]", 0x1d,
  "mov al, [d]", 0x1e,
  "mov al, [d + i16]", 0x1f,
  "mov al, [{bp, sp} + i16]", 0x20,
  "mov al, [{bp, sp} + d]", 0x21,
  "mov ah, i8", 0x22,
  "mov ah, {al, gl}", 0x23,
  "mov ah, {bl, gh}", 0x24,
  "mov ah, bh", 0x25,
  "mov b, i16", 0x26,
  "mov b, {a, g}", 0x27,
  "mov b, c - mov si, b", 0x28,
  "mov b, [u16]", 0x29,
  "mov b, [d] - mov d, [d]", 0x2a,
  "mov b, [d + i16]", 0x2b,
  "mov b, [{bp, sp} + i16]", 0x2c,
  "mov b, d", 0x2d,
  "mov bl, i8", 0x2e,
  "mov bl, {al, gl}", 0x2f,
  "mov bl, {bh, gh}", 0x30,
  "mov bl, [u16]", 0x31,
  "mov bl, [d]", 0x32,
  "mov bl, [d + i16]", 0x33,
  "mov bl, [{bp, sp} + i16]", 0x34,
  "mov bl, [{bp, sp} + d]", 0x35,
  "mov bh, {al, gl}", 0x36,
  "mov bh, {bl, gh}", 0x37,
  "mov c, {u16, g}", 0x38,
  "mov c, {a, b}", 0x39,
  "mov cl, {u8, gl}", 0x3a,
  "mov d, {u16, g}", 0x3b,
  "mov d, {a, c}", 0x3c,
  "mov [u16], {al, bl}", 0x3d,
  "mov [d], {al, bl}", 0x3e,
  "mov [d + i16], {al, bl}", 0x3f,
  "mov [{bp, sp} + i16], al", 0x40,
  "mov [{bp, sp} + d], al", 0x41,
  "mov [u16], {a, b}", 0x42,
  "mov [d], {a, b}", 0x43,
  "mov [d + i16], {a, b}", 0x44,
  "mov [{bp, sp} + i16], a", 0x45,
  "mov [{bp, sp} + d], a", 0x46,
  "mov sp, {a, u16}", 0x47,
  "mov a, sp", 0x48,
  "mov bp, {a, u16}", 0x49,
  "mov a, bp - cmc", 0x4a,
  "pusha", 0x4b,
  "popa", 0x4c,
  "mov si, {a, u16}", 0x4d,
  "mov a, si - mov si, d", 0x4e,
  "mov di, {a, u16}", 0x4f,
  "mov a, di - mov di, d", 0x50,
  "add sp, i16 - inc sp", 0x51,
  "sub sp, i16 - dec sp", 0x52,
  "add a, i16 - stc", 0x53,
  "add a, b  - clc", 0x54,
  "add b, i16 - add a, c", 0x55,
  "add b, a  - add a, d", 0x56,
  "add c, i16 - add b, c", 0x57,
  "add d, i16 - add b, d", 0x58,
  "add d, a  - add c, a", 0x59,
  "add d, b  - add c, b", 0x5a,
  "adc a, i16 - add c, d", 0x5b,
  "adc a, b  - add d, c", 0x5c,
  "adc b, i16 - sub a, c", 0x5d,
  "adc c, i16 - sub a, d", 0x5e,
  "sub a, i16 - sub b, a", 0x5f,
  "sub a, b  - sub b, c", 0x60,
  "sub b, i16 - sub b, d", 0x61,
  "sub c, i16 - sub c, a", 0x62,
  "sub d, i16 - sub c, b", 0x63,
  "sub d, a  - sub c, d", 0x64,
  "sub d, b  - sub d, c", 0x65,
  "sbb a, i16 - add al, ah", 0x66,
  "sbb a, b  - add al, bh", 0x67,
  "sbb b, i16 - add al, cl", 0x68,
  "sbb c, i16 - add al, ch", 0x69,
  "add al, i8 - add al, dl", 0x6a,
  "add al, bl - add al, dh", 0x6b,
  "add bl, i8 - add bl, al", 0x6c,
  "add cl, i8 - add bl, ah", 0x6d,
  "add ch, i8 - add cl, al", 0x6e,
  "sub al, i8 - add cl, ah", 0x6f,
  "sub al, bl - or b, a", 0x70,
  "sub cl, i8 - seq", 0x71,
  "sub ch, i8 - sneq", 0x72,
  "dec ah - slt", 0x73,
  "mov d, b - sle", 0x74,
  "inc ah - slu", 0x75,
  "cmp ah, i8 - sleu", 0x76,
  "inc {a, b}", 0x77,
  "inc c  - mov g, a", 0x78,
  "inc d  - mov g, b", 0x79,
  "inc al - mov g, c", 0x7a,
  "inc cl - mov g, d", 0x7b,
  "inc ch - mov g, si", 0x7c,
  "dec {a, b}", 0x7d,
  "dec c - mov g, di", 0x7e,
  "dec d - sgt", 0x7f,
  "dec al - sge", 0x80,
  "dec cl - sgu", 0x81,
  "dec ch - sgeu", 0x82,
  "mov cl, {al, gh}", 0x83,
  "mov al, cl - nand al, u8", 0x84,
  "and a, u16 - nand a, u16", 0x85,
  "and a, b  - nand a, b", 0x86,
  "and al, u8 - and bl, u8", 0x87,
  "and al, bl - nand al, bl", 0x88,
  "or a, u16  - nor a, u16", 0x89,
  "or a, b  - nor a, b", 0x8a,
  "or al, u8  - or bl, u8", 0x8b,
  "or al, bl  - nor al, bl", 0x8c,
  "xor a, u16 - nor al, u8", 0x8d,
  "xor a, b  - ashr b, cl", 0x8e,
  "xor al, u8  - ashr bl, cl", 0x8f,
  "xor al, bl  - ashr b, u8", 0x90,
  "test a, u16 - ashr bl, u8", 0x91,
  "test a, b - and b, a", 0x92,
  "test al, u8 - test bl, u8", 0x93,
  "test al, bl - test cl, u8", 0x94,
  "not a  - neg a", 0x95,
  "not al - neg al", 0x96,
  "not b  - neg b", 0x97,
  "not bl - neg bl", 0x98,
  "mov bl, ah - shl a", 0x99,
  "mov bh, ah - shl al", 0x9a,
  "mov bp, sp - shr a", 0x9b,
  "mov sp, bp - shr al", 0x9c,
  "shl a, {cl, u8}", 0x9d,
  "shl al, {cl, u8}", 0x9e,
  "shl b, {cl, u8}", 0x9f,
  "shl bl, {cl, u8}", 0xa0,
  "shr a, {cl, u8}", 0xa1,
  "shr al, {cl, u8}", 0xa2,
  "shr b, {cl, u8}", 0xa3,
  "shr bl, {cl, u8}", 0xa4,
  "ashr a, {cl, u8}", 0xa5,
  "ashr al, {cl, u8}", 0xa6,
  "mov bh, u8 - sand", 0xa7,
  "mov al, ch - sor a, b", 0xa8,
  "loopc u16 - loopb u16", 0xa9,
  "snex a - swp A", 0xaa,
  "snex b - swp B", 0xab,
  "mul a, {b, c}", 0xac,
  "mul al, bl", 0xad,
  "div a, b", 0xae,
  "cmp a, i16", 0xaf,
  "cmp a, b", 0xb0,
  "cmp a, c", 0xb1,
  "cmp a, d", 0xb2,
  "cmp word[u16], u16", 0xb3,
  "cmp word[d], u16", 0xb4,
  "cmp word[d + i16], u16", 0xb5,
  "cmp word[{bp,sp}+i16], u16", 0xb6,
  "mov a, [a + i16]", 0xb7,
  "mov word[u16], u16", 0xb8,
  "cmp al, i8", 0xb9,
  "cmp al, bl", 0xba,
  "cmp al, cl", 0xbb,
  "cmp byte[u16], u8", 0xbc,
  "cmp byte[d], u8", 0xbd,
  "cmp byte[d + i16], u8", 0xbe,
  "cmp byte[{bp,sp}+i16], u8", 0xbf,
  "cmp b, i16 - cmp b, c", 0xc0,
  "cmp bl, i8", 0xc1,
  "cmp c, i16", 0xc2,
  "cmp cl, i8 - add byte [u16], i8", 0xc3,
  "cmp ch, i8 - add byte [d], i8", 0xc4,
  "cmp d, i16 - add byte [d+i16], i8", 0xc5,
  "jz u16  - add byte [bp+i16], i8", 0xc6,
  "jnz u16  - add byte [sp+i16], i8", 0xc7,
  "jc/jlu u16 - add word [u16], i16", 0xc8,
  "jnc/jgeu u16 - add word [d], i16", 0xc9,
  "jneg u16 - add word [d+i16], i16", 0xca,
  "jpos u16 - add word [bp+i16], i16", 0xcb,
  "jl u16 - add word [sp+i16], i16", 0xcc,
  "jle u16 - sub byte [u16], i8", 0xcd,
  "jg u16 - sub byte [d], i8", 0xce,
  "jge u16 - sub byte [d+i16], i8", 0xcf,
  "jleu u16 - sub byte [bp+i16], i8", 0xd0,
  "jgu u16 - sub byte [sp+i16], i8", 0xd1,
  "push bp - sub word [u16], i16", 0xd2,
  "add si, i16 - sub word [d], i16", 0xd3,
  "add di, i16 - sub word [d+i16], i16", 0xd4,
  "sub si, i16 - sub word [bp+i16], i16", 0xd5,
  "sub di, i16 - sub word [sp+i16], i16", 0xd6,
  "push {a, word u16}", 0xd7,
  "push {b, g}", 0xd8,
  "push c", 0xd9,
  "push d", 0xda,
  "push {al, byte u8}", 0xdb,
  "push ah", 0xdc,
  "push bl", 0xdd,
  "push bh - rol a, cl", 0xde,
  "push cl - rol al, cl", 0xdf,
  "push ch - rlc a, cl", 0xe0,
  "pushf  - rlc al, cl", 0xe1,
  "push si - ror a, cl", 0xe2,
  "push di - ror al, cl", 0xe3,
  "pop a  - rrc a, cl", 0xe4,
  "pop b  - rrc al, cl", 0xe5,
  "pop c  - rol b, cl", 0xe6,
  "pop d  - rol bl, cl", 0xe7,
  "pop al  - rlc b, cl", 0xe8,
  "pop ah  - rlc bl, cl", 0xe9,
  "pop bl  - ror b, cl", 0xea,
  "pop bh  - ror bl, cl", 0xeb,
  "pop cl  - rrc b, cl", 0xec,
  "pop ch  - rrc bl, cl", 0xed,
  "popf", 0xee,
  "pop si", 0xef,
  "pop di", 0xf0,
  "pop {bp, g}", 0xf1,
  "mov byte[u16], u8", 0xf2,
  "{repz}cmpsb", 0xf3,
  "scansb", 0xf4,
  "{rep}movsb", 0xf5,
  "lodsb - repnz cmpsb", 0xf6,
  "{rep}stosb", 0xf7,
  "enter u16 - lea d, [bp + A*2^u8 + B]", 0xf8,
  "leave - lea d, [u16 + A*2^u8 + B]", 0xf9,
  "lea d, [{bp, sp} + u16]", 0xfa,
  "lea d, [si + u16]", 0xfb,
  "lea d, [di + u16]", 0xfc,
  "esc u8", 0xfd,
  "nop - strcmp", 0xfe,
  "halt", 0xff,
};

uint8_t u_zf_in_src_0_r;
uint8_t u_zf_in_src_1_r;
uint8_t u_cf_in_src_0_r;
uint8_t u_cf_in_src_1_r;
uint8_t u_sf_in_src_r;
uint8_t u_of_in_src_r;
uint8_t ir_wrt_r;
uint8_t status_flags_wrt_r;

uint8_t shift_src_0_r;
uint8_t shift_src_1_r;
uint8_t shift_src_2_r;
uint8_t zbus_in_src_0_r;
uint8_t zbus_in_src_1_r;
uint8_t alu_a_src_0_r;     
uint8_t alu_a_src_1_r;     
uint8_t alu_a_src_2_r;

uint8_t alu_a_src_3_r;
uint8_t alu_a_src_4_r;
uint8_t alu_a_src_5_r;
uint8_t alu_op_0_r;
uint8_t alu_op_1_r;
uint8_t alu_op_2_r;
uint8_t alu_op_3_r;
uint8_t alu_mode_r;

uint8_t alu_cf_in_src0_r;
uint8_t alu_cf_in_src1_r;
uint8_t alu_cf_in_invert_r;
uint8_t zf_in_src_0_r;
uint8_t zf_in_src_1_r;
uint8_t alu_cf_out_invert_r;
uint8_t cf_in_src_0_r;
uint8_t cf_in_src_1_r;

uint8_t cf_in_src_2_r;
uint8_t sf_in_src_0_r;
uint8_t sf_in_src_1_r;
uint8_t of_in_src_0_r;
uint8_t of_in_src_1_r;
uint8_t of_in_src_2_r;
uint8_t rd_r;             
uint8_t wr_r;             
                   
uint8_t alu_b_src_0_r;
uint8_t alu_b_src_1_r;
uint8_t alu_b_src_2_r;
uint8_t display_reg_load_r;
uint8_t dl_wrt_r;
uint8_t dh_wrt_r;
uint8_t cl_wrt_r;
uint8_t ch_wrt_r;

uint8_t bl_wrt_r;
uint8_t bh_wrt_r;
uint8_t al_wrt_r;
uint8_t ah_wrt_r;
uint8_t mdr_in_src_r;
uint8_t mdr_out_src_r;
uint8_t mdr_out_en_r;  
uint8_t mdrl_wrt_r;  

uint8_t mdrh_wrt_r;
uint8_t tdrl_wrt_r;
uint8_t tdrh_wrt_r;
uint8_t dil_wrt_r;
uint8_t dih_wrt_r;
uint8_t sil_wrt_r;
uint8_t sih_wrt_r;
uint8_t marl_wrt_r;

uint8_t marh_wrt_r;
uint8_t bpl_wrt_r;
uint8_t bph_wrt_r;
uint8_t pcl_wrt_r;
uint8_t pch_wrt_r;
uint8_t spl_wrt_r;
uint8_t sph_wrt_r;
uint8_t unused0_r;

uint8_t unused1_r;
uint8_t irq_vector_wrt_r;
uint8_t irq_masks_wrt_r;    
uint8_t mar_in_src_r;
uint8_t int_ack_r;    
uint8_t clear_all_ints_r;
uint8_t ptb_wrt_r;
uint8_t page_table_we_r;

uint8_t mdr_to_pagetable_data_buffer_r;
uint8_t force_user_ptb_r;
uint8_t unused2_r;
uint8_t unused3_r;
uint8_t unused4_r;
uint8_t unused5_r;
uint8_t gl_wrt_r;
uint8_t gh_wrt_r;

uint8_t immy_0_r;
uint8_t immy_1_r;
uint8_t immy_2_r;
uint8_t immy_3_r;
uint8_t immy_4_r;
uint8_t immy_5_r;
uint8_t immy_6_r;
uint8_t immy_7_r;

// all microcode roms
microcode_t microcode_roms[64 * 256];

void reset();
void step_clock();

void load_bios_memory();
void load_ide_disk();
void load_microcode_roms();
void main_loop();

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


static uint8_t bin_to_bcd(uint8_t v);
static uint8_t bcd_to_bin(uint8_t v);
static void rtc_load_host_time(void);

#endif