// Compiler Defines
#define ID_LEN            256
#define CONST_LEN         512
#define STRING_CONST_SIZE 512
#define PROG_SIZE         1024 * 1024 * 30  // 30MB
#define MAX_DEFS          4096
#define ROM_SIZE          65536

// Microcode Defines
#define NUM_INSTR 256
#define NUM_CYCLES_PER_INSTR 64
#define NUM_ROMS 15
#define TOTAL_MICROCODE_BYTES NUM_INSTR * NUM_CYCLES_PER_INSTR * NUM_ROMS

typedef enum {
  // Special Tokens
  TOK_UNDEF = 0, 
  INCLUDE, 
  DEF, 
  META, 
  PROGRAM,
  BACKTICK, 
  COMMA, 
  HASH,
  SEMICOLON,
  OPENING_BRACE, 
  CLOSING_BRACE,
  EQUAL,
  PLUS,
  MINUS,
  NOT,

  // Microcode Tokens
  TRUE,
  FALSE,
  DATABUS,
  ZBUS,
  UNCHANGED,

  NEXT, NEXT_OFFSET, NEXT_BRANCH, NEXT_FETCH, NEXT_IR,
  OFFSET,
  COND_FLAGS_SRC,
  CPU_FLAGS,
  MICRO_FLAGS,
  CONDITION,
  CONDITION_INV,
  CF,
  UCF,
  ZF,
  UZF,
  SF,
  USF,
  OF,
  UOF,
  LT,
  LTU,
  LTE,
  LTEU,
  GTEU,
  GTE,
  GT,
  GTU,
  DMA_REQ,
  CPU_MODE,
  WAIT,
  IRQ_PENDING,
  EXT_INPUT,
  DIRECTION_FLAG,

  ESCAPE,
  UZF_IN_SRC, 
  ALU_ZF, 
  ALU_ZF_AND_UZF,

  UCF_IN_SRC, 
  ALU_FINAL_CF, 
  ALU_OUT_0, 
  ALU_OUT_7,

  USF_IN_SRC, ZBUS_7,
  UOF_IN_SRC, ALU_OF,
  SHIFT_SRC, 
  
  ZBUS_OUT_SRC, 
  ALU_OUT, 
  SHIFTED_RIGHT, 
  SHIFTED_LEFT, 
  SIGN_EXTENDED,

  ALU_X,
  ALU_Y,
  ALU_OP,
  ALU_MODE,
  ARITHMETIC, LOGIC,
  ALU_CF_IN,
  ALU_CF_IN_INV,
  ALU_CF_OUT_INV,
  VCC,
  GND,
  ZF_IN_SRC,
  ALU_ZF_AND_ZF,
  ZBUS_0,

  CF_IN_SRC,
  ZBUS_1,

  SF_IN_SRC,
  ZBUS_2,

  OF_IN_SRC,
  ZBUS_3,
  USF_XOR_ZBUS_7,

  RD,
  WR,
  DISPLAY_REG_LOAD,
  MDR_IN_SRC,
  MDR_OUT_SRC,
  MDR_OUT_EN,
  MAR_IN_SRC,
  IRQ_ACK,
  CLEAR_ALL_IRQS,
  PAGETABLE_WE,
  MDR_TO_PAGETABLE_BUFFER_EN,
  FORCE_USER_PTB,
  IMMEDIATE,                     
  AL_WRT,
  AH_WRT,
  BL_WRT,
  BH_WRT,
  CL_WRT,
  CH_WRT,
  DL_WRT,
  DH_WRT,
  GL_WRT,
  GH_WRT,
  MDRL_WRT,
  MDRH_WRT,
  TDRL_WRT,
  TDRH_WRT,
  DIL_WRT,
  DIH_WRT,
  SIL_WRT,
  SIH_WRT,
  MARL_WRT,
  MARH_WRT,
  BPL_WRT,
  BPH_WRT,
  SPL_WRT,
  SPH_WRT,
  PCL_WRT,
  PCH_WRT,
  IR_WRT,
  STATUS_WRT,
  IRQ_VECTOR_WRT,
  IRQ_MASKS_WRT,
  PTB_WRT,

  MDRL,
  MDRH,
  PC
} t_token; // internal token representation

typedef enum {
  TYPE_UNDEF = 0, 
  DELIMITER,
  INTEGER_CONST, 
  STRING_CONST,
  IDENTIFIER, 
  RESERVED, 
  END
} t_token_type;

struct {
  char *keyword;
  t_token key;
} keyword_table[] = {
  "include",                        INCLUDE,                                                         
  "def",                            DEF, 
  "meta",                           META, 
  "program",                        PROGRAM,
  "backtick",                       BACKTICK, 
  "comma",                          COMMA, 
  "hash",                           HASH,
  "semicolon",                      SEMICOLON,
  "opening_brace",                  OPENING_BRACE, 
  "closing_brace",                  CLOSING_BRACE,
  "equal",                          EQUAL,
  "plus",                           PLUS,
  "minus",                          MINUS,
  "not",                            NOT,
                                    
  "true",                           TRUE,
  "false",                          FALSE,
  "databus",                        DATABUS,
  "zbus",                           ZBUS,
  "unchanged",                      UNCHANGED,
                                    
  "next",                           NEXT, 
  "next_offset",                    NEXT_OFFSET, 
  "next_branch",                    NEXT_BRANCH, 
  "next_fetch",                     NEXT_FETCH, 
  "next_ir",                        NEXT_IR,   
  "offset",                         OFFSET,
  "cond_flags_src",                 COND_FLAGS_SRC,
  "cpu_flags",                      CPU_FLAGS,
  "micro_flags",                    MICRO_FLAGS,
  "condition",                      CONDITION,
  "condition_inv",                  CONDITION_INV,
  "cf",                             CF,
  "ucf",                           UCF,
  "zf",                             ZF,
  "uzf",                           UZF,
  "sf",                             SF,
  "usf",                           USF,
  "of",                             OF,
  "uof",                           UOF,
  "lt",                             LT,
  "ltu",                            LTU,
  "lte",                            LTE,
  "lteu",                           LTEU,
  "gteu",                           GTEU,
  "gte",                            GTE,
  "gt",                             GT,
  "gtu",                            GTU,
  "dma_req",                        DMA_REQ,
  "cpu_mode",                       CPU_MODE,
  "wait",                           WAIT,
  "irq_pending",                    IRQ_PENDING,
  "ext_input",                      EXT_INPUT,
  "direction_flag",                 DIRECTION_FLAG,
                                    
  "escape",                         ESCAPE,
  "uzf_in_src",                    UZF_IN_SRC, 
  "alu_zf",                         ALU_ZF, 
  "alu_zf_and_uzf",                 ALU_ZF_AND_UZF,
                                    
  "ucf_in_src",                     UCF_IN_SRC, 
  "alu_final_cf",                   ALU_FINAL_CF, 
  "alu_out_0",                      ALU_OUT_0, 
  "alu_out_7",                      ALU_OUT_7,
                                    
  "usf_in_src",                    USF_IN_SRC, 
  "zbus_7",                         ZBUS_7,
  "uof_in_src",                    UOF_IN_SRC, 
  "alu_of",                         ALU_OF,
  "shift_src",                      SHIFT_SRC, 
                                    
  "zbus_out_src",                   ZBUS_OUT_SRC, 
  "alu_out",                        ALU_OUT, 
  "shifted_right",                  SHIFTED_RIGHT, 
  "shifted_left",                   SHIFTED_LEFT, 
  "sign_extended",                  SIGN_EXTENDED,
                                    
  "alu_x",                          ALU_X,
  "alu_y",                          ALU_Y,
  "alu_op",                         ALU_OP,
  "alu_mode",                       ALU_MODE,
  "arithmetic",                     ARITHMETIC,
  "logic",                          LOGIC,
  "alu_cf_in",                      ALU_CF_IN,
  "alu_cf_in_inv",                  ALU_CF_IN_INV,
  "alu_cf_out_inv",                 ALU_CF_OUT_INV,
  "vcc",                            VCC,
  "gnd",                            GND,
  "zf_in_src",                      ZF_IN_SRC,
  "alu_zf_and_zf",                  ALU_ZF_AND_ZF,
  "zbus_0",                         ZBUS_0,
                                    
  "cf_in_src",                      CF_IN_SRC,
  "zbus_1",                         ZBUS_1,
                                    
  "sf_in_src",                      SF_IN_SRC,
  "zbus_2",                         ZBUS_2,
                                    
  "of_in_src",                      OF_IN_SRC,
  "zbus_3",                         ZBUS_3,
  "usf_xor_zbus_7",                 USF_XOR_ZBUS_7,
                                    
  "rd",                             RD,
  "wr",                             WR,
  "display_reg_load",               DISPLAY_REG_LOAD,
  "mdr_in_src",                     MDR_IN_SRC,
  "mdr_out_src",                    MDR_OUT_SRC,
  "mdr_out_en",                     MDR_OUT_EN,
  "mar_in_src",                     MAR_IN_SRC,
  "irq_ack",                        IRQ_ACK,
  "clear_all_irqs",                 CLEAR_ALL_IRQS,
  "pagetable_we",                   PAGETABLE_WE,
  "mdr_to_pagetable_buffer_en",     MDR_TO_PAGETABLE_BUFFER_EN,
  "force_user_ptb",                 FORCE_USER_PTB,
  "immediate",                      IMMEDIATE,                     
  "al_wrt",                         AL_WRT,
  "ah_wrt",                         AH_WRT,
  "bl_wrt",                         BL_WRT,
  "bh_wrt",                         BH_WRT,
  "cl_wrt",                         CL_WRT,
  "ch_wrt",                         CH_WRT,
  "dl_wrt",                         DL_WRT,
  "dh_wrt",                         DH_WRT,
  "gl_wrt",                         GL_WRT,
  "gh_wrt",                         GH_WRT,
  "mdrl_wrt",                       MDRL_WRT,
  "mdrh_wrt",                       MDRH_WRT,
  "tdrl_wrt",                       TDRL_WRT,
  "tdrh_wrt",                       TDRH_WRT,
  "dil_wrt",                        DIL_WRT,
  "dih_wrt",                        DIH_WRT,
  "sil_wrt",                        SIL_WRT,
  "sih_wrt",                        SIH_WRT,
  "marl_wrt",                       MARL_WRT,
  "marh_wrt",                       MARH_WRT,
  "bpl_wrt",                        BPL_WRT,
  "bph_wrt",                        BPH_WRT,
  "spl_wrt",                        SPL_WRT,
  "sph_wrt",                        SPH_WRT,
  "pcl_wrt",                        PCL_WRT,
  "pch_wrt",                        PCH_WRT,
  "ir_wrt",                         IR_WRT,
  "status_wrt",                     STATUS_WRT,
  "irq_vector_wrt",                 IRQ_VECTOR_WRT,
  "irq_masks_wrt",                  IRQ_MASKS_WRT,
  "ptb_wrt",                        PTB_WRT,

  "mdrl",                           MDRL,
  "mdrh",                           MDRH,
  "pc",                             PC,

  "",                               0
};

struct {
  char *operand;
  char key;
} alu_x_operands[] = {
  "al",                0x0,
  "ah",                0x1,
  "bl",                0x2,
  "bh",                0x3,
  "cl",                0x4,
  "ch",                0x5,
  "dl",                0x6,
  "dh",                0x7,
  "spl",               0x8,
  "sph",               0x9,
  "bpl",               0xA,
  "bph",               0xB,
  "sil",               0xC,
  "sih",               0xD,
  "dil",               0xE,
  "dih",               0xF,
  "pcl",               0x10,
  "pch",               0x11,
  "marl",              0x12,
  "marh",              0x13,
  "mdrl",              0x14,
  "mdrh",              0x15,
  "tdrl",              0x16,
  "tdrh",              0x17,
  "kspl",              0x18,
  "ksph",              0x19,
  "irq_vector",        0x1A,
  "irq_masks",         0x1B,
  "irq_status",        0x1C,
  "arithmetic_flags",  0x20,
  "status_flags",      0x21,
  "gl",                0x22,
  "gh",                0x23,
  "",                  0
};

struct {
  char *operand;
  unsigned char key;
} alu_y_operands[] = {
  "immediate",  0,
  "mdrl",       4,
  "mdrh",       5,
  "tdrl",       6,
  "tdrh",       7,
  "",           0
};

struct {
  char *op;
  char key;
} alu_op[] = {
  "plus",   0x9,
  "minus",  0x6,
  "and",    0xB,
  "or",     0xE,
  "xor",    0x6,
  "x",      0xF,
  "y",      0xA,
  "nota",   0x0,
  "notb",   0x5,
  "nand",   0x4,
  "nor",    0x1,
  "nxor",   0x9,  
  "",       0
};

struct{
  char name[ID_LEN];
  char content[256];
} defines_table[MAX_DEFS];

int current_line = 1;
char current_filename[128];
t_token_type tok_type;
t_token tok;
char token[CONST_LEN];            // string token representation
char string_const[STRING_CONST_SIZE];  // holds string and char constants without quotes and with escape sequences converted into the correct bytes
int int_const;
char *prog;                           // pointer to the current program position
int pc;
char micro_in[PROG_SIZE];               
char file_out[ROM_SIZE];
char *prog_before_error;
int defines_tos;
char includes_file[PROG_SIZE]; // Used to store an included file for processing

unsigned int current_instr;
unsigned int current_cycle;
// Array to keep final microcode output binary
unsigned char microcode_binary[NUM_INSTR][NUM_CYCLES_PER_INSTR][NUM_ROMS];

// Microcode field variables
unsigned char u_next;                                 
char u_offset;
unsigned char u_cond_flags_src;
unsigned char u_condition;
unsigned char u_condition_inv;
unsigned char u_escape;
unsigned char u_uzf_in_src;
unsigned char u_ucf_in_src;
unsigned char u_usf_in_src;
unsigned char u_uof_in_src;
unsigned char u_shift_src;
unsigned char u_zbus_out_src;
unsigned char u_alu_x;
unsigned char u_alu_y;
unsigned char u_alu_op;
unsigned char u_alu_mode;
unsigned char u_alu_cf_in;
unsigned char u_alu_cf_in_inv;
unsigned char u_alu_cf_out_inv;
unsigned char u_zf_in_src;
unsigned char u_cf_in_src;
unsigned char u_sf_in_src;
unsigned char u_of_in_src;
unsigned char u_rd;
unsigned char u_wr;
unsigned char u_display_reg_load;
unsigned char u_mdr_in_src;
unsigned char u_mdr_out_src;
unsigned char u_mdr_out_en;
unsigned char u_mar_in_src;
unsigned char u_irq_ack;
unsigned char u_clear_all_irqs;
unsigned char u_pagetable_we;
unsigned char u_mdr_to_pagetable_buffer_en;
unsigned char u_force_user_ptb;
unsigned char u_immediate;
unsigned char u_al_wrt;
unsigned char u_ah_wrt;
unsigned char u_bl_wrt;
unsigned char u_bh_wrt;
unsigned char u_cl_wrt;
unsigned char u_ch_wrt;
unsigned char u_dl_wrt;
unsigned char u_dh_wrt;
unsigned char u_gl_wrt;
unsigned char u_gh_wrt;
unsigned char u_mdrl_wrt;
unsigned char u_mdrh_wrt;
unsigned char u_tdrl_wrt;
unsigned char u_tdrh_wrt;
unsigned char u_dil_wrt;
unsigned char u_dih_wrt;
unsigned char u_sil_wrt;
unsigned char u_sih_wrt;
unsigned char u_marl_wrt;
unsigned char u_marh_wrt;
unsigned char u_bpl_wrt;
unsigned char u_bph_wrt;
unsigned char u_spl_wrt;
unsigned char u_sph_wrt;
unsigned char u_pcl_wrt;
unsigned char u_pch_wrt;
unsigned char u_ir_wrt;
unsigned char u_status_wrt;
unsigned char u_irq_vector_wrt;
unsigned char u_irq_masks_wrt;
unsigned char u_ptb_wrt;                                            

// functions
char is_identifier_char(char c);
int search_keyword(char *keyword);
void load_program(char *filename);


void just_get(void);
int get_atom();
void get_line(void);
void back(void);
void error(const char* format, ...);

void parse_file();
void parse_instruction();
void parse_cycle();

void initialize_microcode_defaults();
void set_microcode_field_defaults();
char get_alu_x_operand();
char get_alu_y_operand();
char get_alu_op(char *op);
char get_alu_cf_in();
unsigned char get_u_condition();

char is_hex_digit(char c);
char is_digit(char c);
char is_space(char c);
char* strip_ext(char* filename);

void declare_define();
int search_define(char *name);
void process_include();
void convert_constant();

int binstr_to_int(char *s);

void skip_block(int braces);
void get_tok(t_token token, char *format, ...);
void get_toktype(t_token_type token_type, char *format, ...);