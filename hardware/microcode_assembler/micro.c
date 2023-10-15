#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <math.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <errno.h>
#include "def.h"


int main(int argc, char *argv[]){
  char filename_noext[256];
  char temp_filename[300];
  int instr, cycle, rom;
  int i;
  FILE *fp;
  struct stat st = {0};
  int switch_showresult = 0;
  int switch_verbose = 0;
  unsigned char rom_binary[65536];

  if(argc > 1) load_program(argv[1]);  
  else{
    printf("Usage: micro [filename]\n");
    return 0;
  }

  for(i = 0; i < argc; i++){
    if(argv[i][0] == '-'){ // Switch argument
      if(strchr(argv[i], 'v')) switch_verbose = 1;
      if(strchr(argv[i], 's')) switch_showresult = 1;
    }
  }

  strcpy(current_filename, argv[1]);
  strcpy(filename_noext, argv[1]);
  strip_ext(filename_noext);

  if(switch_verbose){
    printf("Assembling '%s'...\n", argv[1]);
  }

  initialize_microcode_defaults();
  parse_file();

  if(switch_showresult){
    for(instr = 0; instr < 256; instr++){
      printf("0x%X:  0   1   2   3   4   5   6   7   8   9  10  11  12  13\n", instr);
      for(cycle = 0; cycle < 64; cycle++){
        printf("%2X : ", cycle);
          printf("%02X  %02X  %02X  %02X  %02X  %02X  %02X  %02X  %02X  %02X  %02X  %02X  %02X  %02X  : %2d\n",  
          microcode_binary[instr][cycle][0],  microcode_binary[instr][cycle][1],  microcode_binary[instr][cycle][2], 
          microcode_binary[instr][cycle][3],  microcode_binary[instr][cycle][4],  microcode_binary[instr][cycle][5], 
          microcode_binary[instr][cycle][6],  microcode_binary[instr][cycle][7],  microcode_binary[instr][cycle][8], 
          microcode_binary[instr][cycle][9],  microcode_binary[instr][cycle][10], microcode_binary[instr][cycle][11], 
          microcode_binary[instr][cycle][12], microcode_binary[instr][cycle][13], cycle
        );
      }
      puts("");
    }
  }

  // Try creating output directory
  if (stat("output", &st) == -1) {
    if (errno == ENOENT) {
      // Directory does not exist, create it
      if (mkdir("output", 0700) == -1) {
        perror("Failed to create output directory");
        exit(1);
      }
    } else {
      // stat failed for a reason other than "No such file or directory"
      perror("Stat failed");
      exit(1);
    }
  }

  if(switch_verbose){
    printf("Generating ROM files...\n");
  }
  // Generate binary ROM files
  for(i = 0; i < 65536; i++){
    rom_binary[i] = 0;
  }
  for(rom = 0; rom < 14; rom++){
    if(switch_verbose){
      printf("Generating ROM%d...", rom);
    }
    strcpy(temp_filename, filename_noext);
    sprintf(temp_filename, "output/%s_ROM%d.bin", filename_noext, rom);
    fp = fopen(temp_filename, "wb+");
    if(fp == NULL){
      printf("Error trying to create output files.\n");
      exit(1);
    }
    for(instr = 0; instr < 256; instr++){
      for(cycle = 0; cycle < 64; cycle++){
        rom_binary[instr * 64 + cycle] = microcode_binary[instr][cycle][rom];
      }
    }

    fwrite(rom_binary, 1, 65536, fp);
/*
    for(instr = 0; instr < 256; instr++){
      for(cycle = 0; cycle < 64; cycle++){
        fwrite(&microcode_binary[instr][cycle][rom], sizeof(char), 1, fp);
      }
    }
    */
    if(switch_verbose){
      printf("OK.\n");
    }
    fclose(fp);
  }
  
  if(switch_verbose){
    printf("Assembly of '%s' is complete.\n", argv[1]);
  }
  return 0;
}

char* strip_ext(char* filename) {
  char *dot = strrchr(filename, '.'); // find last occurrence of '.'
  if(dot == NULL || dot == filename) return filename; // return if no '.' found
  *dot = '\0'; // replace '.' with null character
  return filename;
}


void load_program(char *filename){
  FILE *fp;
  int i;
  
  if((fp = fopen(filename, "rb")) == NULL){
    printf("%s: Source file not found.\n", filename);
    exit(1);
  }
  
  prog = micro_in;
  i = 0;
  do{
    *(prog++) = getc(fp);
    i++;
  } while(!feof(fp));
  *(prog - 1) = '\0'; // overwrite the EOF char with NULL
  fclose(fp);

  prog = micro_in;
}

int get_atom(){
  int atom;
  int define_index;

  just_get();
  if(tok_type == IDENTIFIER)
    if((define_index = search_define(token)) != -1)
      if(defines_table[define_index].content[0] == '0' && defines_table[define_index].content[1] == 'x') sscanf(defines_table[define_index].content, "%x", &atom);
      else atom = atoi(defines_table[define_index].content);
    else error("Undeclared macro definition: %s", token);
  else if(tok_type == INTEGER_CONST) atom = int_const;
  else error("Integer expected.");

  return atom;
}

void skip_block(int braces){
  do{
    just_get();
    if(tok == OPENING_BRACE) braces++;
    else if(tok == CLOSING_BRACE) braces--;
  } while(braces && tok_type != END);

  if(braces && tok_type == END) error("Closing brace expected.");
}

void parse_file(){
  do{
    just_get();
    if(tok_type == END) return;
    if(tok_type != INTEGER_CONST && tok != CLOSING_BRACE) error("Instruction opcode expected.");
    back();
    parse_instruction();
  } while(tok_type != END);
}


void parse_instruction(void){
  int opcode;
  get_toktype(INTEGER_CONST, "Instruction opcode expected: %s", token);
  opcode = current_instr = int_const;
  get_tok(COMMA, "Comma expected.");
  get_toktype(STRING_CONST, "Instruction mnemonic expected.");
  printf("  %s, 0x%x,\n", token, opcode);
  get_tok(OPENING_BRACE, "Opening brace expected.");

  do{
    just_get(); if(tok == CLOSING_BRACE) break;
    back();
    parse_cycle();
  } while(tok_type != END);
}

void initialize_microcode_defaults(){
  int instr, cycle;
  set_microcode_field_defaults();
  for(instr = 0; instr < 256; instr++){
    for(cycle = 0; cycle < 64; cycle++){  
      microcode_binary[instr][cycle][0]  = ((u_offset & 0x7F) << 2)    | u_next;       
      microcode_binary[instr][cycle][1]  = (u_escape << 7)             | (u_condition << 3)      | (u_cond_flags_src << 2)  | (u_condition_inv << 1) | ((u_offset & 0x7F) >> 6);
      microcode_binary[instr][cycle][2]  = (u_status_wrt << 7)         | (u_ir_wrt << 6)         | (u_uof_in_src << 5)      | (u_usf_in_src << 4)    | (u_ucf_in_src << 2)       | (u_uzf_in_src);
      microcode_binary[instr][cycle][3]  = ((u_alu_x & 0x07) << 5)     | (u_zbus_out_src << 3)   | (u_shift_src);
      microcode_binary[instr][cycle][4]  = (u_alu_mode << 7)           | (u_alu_op << 3)         | (u_alu_x >> 3);
      microcode_binary[instr][cycle][5]  = ((u_cf_in_src & 0x03) << 6) | (u_alu_cf_out_inv << 5) | (u_zf_in_src << 3)       | (u_alu_cf_in_inv << 2) | (u_alu_cf_in);
      microcode_binary[instr][cycle][6]  = (u_wr << 7)                 | (u_rd << 6)             | (u_of_in_src << 3)       | (u_sf_in_src << 1)     | (u_cf_in_src >> 2);
      microcode_binary[instr][cycle][7]  = (u_ch_wrt << 7)             | (u_cl_wrt << 6)         | (u_dh_wrt << 5)          | (u_dl_wrt << 4)        | (u_display_reg_load << 3) | (u_alu_y);
      microcode_binary[instr][cycle][8]  = (u_mdrl_wrt << 7)           | (u_mdr_out_en << 6)     | (u_mdr_out_src << 5)     | (u_mdr_in_src << 4)    | (u_ah_wrt << 3)           | (u_al_wrt << 2)        | (u_bh_wrt << 1)         | (u_bl_wrt);
      microcode_binary[instr][cycle][9]  = (u_marl_wrt << 7)           | (u_sih_wrt << 6)        | (u_sil_wrt << 5)         | (u_dih_wrt << 4)       | (u_dil_wrt << 3)          | (u_tdrh_wrt << 2)      | (u_tdrl_wrt << 1)       | (u_mdrh_wrt);
      microcode_binary[instr][cycle][10] = 0x80                        | (u_sph_wrt << 6)        | (u_spl_wrt << 5)         | (u_pch_wrt << 4)       | (u_pcl_wrt << 3)          | (u_bph_wrt << 2)       | (u_bpl_wrt << 1)        | (u_marh_wrt);
      microcode_binary[instr][cycle][11] = (u_pagetable_we << 7)       | (u_ptb_wrt << 6)        | (u_clear_all_irqs << 5)  | (u_irq_ack << 4)       | (u_mar_in_src << 3)       | (u_irq_masks_wrt << 2) | (u_irq_vector_wrt << 1) | 0x01;
      microcode_binary[instr][cycle][12] = (u_gh_wrt << 7)             | (u_gl_wrt << 6)           /* unused */               /* unused */             /* unused */                /* unused */           | (u_force_user_ptb << 1) | (u_mdr_to_pagetable_buffer_en);
      microcode_binary[instr][cycle][13] = u_immediate;
    }
  }
}

void set_microcode_field_defaults(){
  u_next                        = 0;                                 
  u_offset                      = 0;
  u_cond_flags_src              = 0;
  u_condition                   = 0;
  u_condition_inv               = 0;
  u_escape                      = 0;
  u_uzf_in_src                  = 0;
  u_ucf_in_src                  = 0;
  u_usf_in_src                  = 0;
  u_uof_in_src                  = 0;
  u_shift_src                   = 0;
  u_zbus_out_src                = 0;
  u_alu_x                       = 0;
  u_alu_y                       = 0;
  u_alu_op                      = 0;
  u_alu_mode                    = 0;
  u_alu_cf_in                   = 0;
  u_alu_cf_in_inv               = 0;
  u_alu_cf_out_inv              = 0;
  u_zf_in_src                   = 0;
  u_cf_in_src                   = 0;
  u_sf_in_src                   = 0;
  u_of_in_src                   = 0;
  u_rd                          = 0;
  u_wr                          = 0;
  u_display_reg_load            = 0;
  u_mdr_in_src                  = 0;
  u_mdr_out_src                 = 0;
  u_mdr_out_en                  = 0;
  u_mar_in_src                  = 0;
  u_irq_ack                     = 0;
  u_clear_all_irqs              = 0;
  u_pagetable_we                = 0;
  u_mdr_to_pagetable_buffer_en  = 0;
  u_force_user_ptb              = 0;
  u_immediate                   = 0;
  u_al_wrt                      = 1;
  u_ah_wrt                      = 1;
  u_bl_wrt                      = 1;
  u_bh_wrt                      = 1;
  u_cl_wrt                      = 1;
  u_ch_wrt                      = 1;
  u_dl_wrt                      = 1;
  u_dh_wrt                      = 1;
  u_gl_wrt                      = 1;
  u_gh_wrt                      = 1;
  u_mdrl_wrt                    = 1;
  u_mdrh_wrt                    = 1;
  u_tdrl_wrt                    = 1;
  u_tdrh_wrt                    = 1;
  u_dil_wrt                     = 1;
  u_dih_wrt                     = 1;
  u_sil_wrt                     = 1;
  u_sih_wrt                     = 1;
  u_marl_wrt                    = 1;
  u_marh_wrt                    = 1;
  u_bpl_wrt                     = 1;
  u_bph_wrt                     = 1;
  u_spl_wrt                     = 1;
  u_sph_wrt                     = 1;
  u_pcl_wrt                     = 1;
  u_pch_wrt                     = 1;
  u_ir_wrt                      = 1;
  u_status_wrt                  = 1;
  u_irq_vector_wrt              = 1;
  u_irq_masks_wrt               = 1;
  u_ptb_wrt                     = 1;                                            
}


void parse_cycle(void){
  char *temp_prog;
  get_toktype(INTEGER_CONST, "Instruction cycle expected.");
  current_cycle = int_const;
  get_tok(OPENING_BRACE, "Opening brace expected.");
  
  set_microcode_field_defaults(); 
  temp_prog = prog;
  do{
    just_get();
    if(tok == CLOSING_BRACE) break;
    switch(tok){
      case NEXT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        switch(tok){
          case NEXT_OFFSET:
            u_next = 0;
            break;
          case NEXT_BRANCH:
            u_next = 1;
            break;
          case NEXT_FETCH:
            u_next = 2;
            break;
          case NEXT_IR:
            u_next = 3;
            break;
          default: error("Unknown value for field 'next'.");
        }
        break;
      case OFFSET:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok_type != INTEGER_CONST) error("Integer expected for microcode field value.");
        u_offset = int_const;
        break;
      case COND_FLAGS_SRC:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == CPU_FLAGS) u_cond_flags_src = 0;
        else if(tok == MICRO_FLAGS) u_cond_flags_src = 1;
        else error("Unknown value for field 'cond_src'.");
        break;
      case CONDITION:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        u_condition = get_u_condition();
        break;
      case CONDITION_INV:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_condition_inv = 1;
        else if(tok == FALSE) u_condition_inv = 0;
        else error("Invalid value for field 'condition_inv'.");
        break;
      case IMMEDIATE:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok_type != INTEGER_CONST) error("Integer expected for microcode field value.");
        u_immediate = int_const;
        break;
      case ALU_X:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        u_alu_x = get_alu_x_operand(token);
        break;
      case ALU_Y:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        u_alu_y = get_alu_y_operand(token);
        break;
      case ALU_OP:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        u_alu_op = get_alu_op(token);
        break;
      case ALU_MODE:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == ARITHMETIC) u_alu_mode = 0;
        else if(tok == LOGIC) u_alu_mode = 1;
        else error("Invalid value for field 'alu_mode'");
        break;
      case ALU_CF_IN:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        u_alu_cf_in = get_alu_cf_in();
        break;
      case ALU_CF_IN_INV:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_alu_cf_in_inv = 1;
        else if(tok == FALSE) u_alu_cf_in_inv = 0;
        else error("Invalid value for field 'u_alu_cf_in_inv'.");
        break;
      case ALU_CF_OUT_INV:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_alu_cf_out_inv = 1;
        else if(tok == FALSE) u_alu_cf_out_inv = 0;
        else error("Invalid value for field 'alu_cf_out_inv'.");
        break;
      case MDR_IN_SRC:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == ZBUS) u_mdr_in_src = 0;
        else if(tok == DATABUS) u_mdr_in_src = 1;
        else error("Invalid value for field 'mdr_in_src'.");
        break;
      case MDR_OUT_SRC:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == MDRL) u_mdr_out_src = 0;
        else if(tok == MDRH) u_mdr_out_src = 1;
        else error("Invalid value for field 'mdr_out_src'.");
        break;
      case MDR_OUT_EN:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_mdr_out_en = 1;
        else if(tok == FALSE) u_mdr_out_en = 0;
        else error("Invalid value for field 'mdr_out_en'.");
        break;
      case ESCAPE:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_escape = 1;
        else if(tok == FALSE) u_escape = 0;
        else error("Invalid value for field 'escape'.");
        break;
      case UZF_IN_SRC:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        switch(tok){
          case UNCHANGED:       u_uzf_in_src = 0; break;
          case ALU_ZF:          u_uzf_in_src = 1; break;
          case ALU_ZF_AND_UZF:  u_uzf_in_src = 2; break;
          case GND:             u_uzf_in_src = 3; break;
          default:              error("Invalid value for field 'u_uzf_in_src'.");
        }
        break;
      case UCF_IN_SRC:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        switch(tok){
          case UNCHANGED:       u_ucf_in_src = 0; break;
          case ALU_FINAL_CF:    u_ucf_in_src = 1; break;
          case ALU_OUT_0:       u_ucf_in_src = 2; break;
          case ALU_OUT_7:       u_ucf_in_src = 3; break;
          default:              error("Invalid value for field 'u_ucf_in_src'.");
        }
        break;
      case USF_IN_SRC:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        switch(tok){
          case UNCHANGED:       u_usf_in_src = 0; break;
          case ZBUS_7:          u_usf_in_src = 1; break;
          default:              error("Invalid value for field 'u_usf_in_src'.");
        }
        break;
      case UOF_IN_SRC:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        switch(tok){
          case UNCHANGED:       u_uof_in_src = 0; break;
          case ALU_OF:          u_uof_in_src = 1; break;
          default:              error("Invalid value for field 'u_uof_in_src'.");
        }
        break;
      case ZF_IN_SRC:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        switch(tok){
          case UNCHANGED:       u_zf_in_src = 0; break;
          case ALU_ZF:          u_zf_in_src = 1; break;
          case ALU_ZF_AND_ZF:   u_zf_in_src = 2; break;
          case ZBUS_0:          u_zf_in_src = 3; break;
          default:              error("Invalid value for field 'zf_in_src'.");
        }
        break;
      case CF_IN_SRC:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        switch(tok){
          case UNCHANGED:       u_cf_in_src = 0; break;
          case ALU_FINAL_CF:    u_cf_in_src = 1; break;
          case ALU_OUT_0:       u_cf_in_src = 2; break;
          case ZBUS_1:          u_cf_in_src = 3; break;
          case ALU_OUT_7:       u_cf_in_src = 4; break;
          default:              error("Invalid value for field 'cf_in_src'.");
        }
        break;
      case SF_IN_SRC:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        switch(tok){
          case UNCHANGED:       u_sf_in_src = 0; break;
          case ZBUS_7:          u_sf_in_src = 1; break;
          case GND:             u_sf_in_src = 2; break;
          case ZBUS_2:          u_sf_in_src = 3; break;
          default:              error("Invalid value for field 'sf_in_src'.");
        }
        break;
      case OF_IN_SRC:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        switch(tok){
          case UNCHANGED:       u_of_in_src = 0; break;
          case ALU_OF:          u_of_in_src = 1; break;
          case ZBUS_7:          u_of_in_src = 2; break;
          case ZBUS_3:          u_of_in_src = 3; break;
          case USF_XOR_ZBUS_7:  u_of_in_src = 4; break;
          default:              error("Invalid value for field 'of_in_src'.");
        }
        break;
      case RD:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_rd = 1;
        else if(tok == FALSE) u_rd = 0;
        else error("Invalid value for field 'rd'.");
        break;
      case WR:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_wr = 1;
        else if(tok == FALSE) u_wr = 0;
        else error("Invalid value for field 'rd'.");
        break;
      case MDRL_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_mdrl_wrt = 0;
        else if(tok == FALSE) u_mdrl_wrt = 1;
        else error("Invalid value for field 'mdrl_wrt'.");
        break;
      case MDRH_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_mdrh_wrt = 0;
        else if(tok == FALSE) u_mdrh_wrt = 1;
        else error("Invalid value for field 'mdrh_wrt'.");
        break;
      case AL_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_al_wrt = 0;
        else if(tok == FALSE) u_al_wrt = 1;
        else error("Invalid value for field 'al_wrt'.");
        break;
      case AH_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_ah_wrt = 0;
        else if(tok == FALSE) u_ah_wrt = 1;
        else error("Invalid value for field 'ah_wrt'.");
        break;
      case BL_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_bl_wrt = 0;
        else if(tok == FALSE) u_bl_wrt = 1;
        else error("Invalid value for field 'bl_wrt'.");
        break;
      case BH_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_bh_wrt = 0;
        else if(tok == FALSE) u_bh_wrt = 1;
        else error("Invalid value for field 'bh_wrt'.");
        break;
      case CL_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_cl_wrt = 0;
        else if(tok == FALSE) u_cl_wrt = 1;
        else error("Invalid value for field 'cl_wrt'.");
        break;
      case CH_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_ch_wrt = 0;
        else if(tok == FALSE) u_ch_wrt = 1;
        else error("Invalid value for field 'ch_wrt'.");
        break;
      case DL_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_dl_wrt = 0;
        else if(tok == FALSE) u_dl_wrt = 1;
        else error("Invalid value for field 'dl_wrt'.");
        break;
      case DH_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_dh_wrt = 0;
        else if(tok == FALSE) u_dh_wrt = 1;
        else error("Invalid value for field 'dh_wrt'.");
        break;
      case GL_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_gl_wrt = 0;
        else if(tok == FALSE) u_gl_wrt = 1;
        else error("Invalid value for field 'gl_wrt'.");
        break;
      case GH_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_gh_wrt = 0;
        else if(tok == FALSE) u_gh_wrt = 1;
        else error("Invalid value for field 'gh_wrt'.");
        break;
      case IR_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_ir_wrt = 0;
        else if(tok == FALSE) u_ir_wrt = 1;
        else error("Invalid value for field 'ir_wrt'.");
        break;
      case STATUS_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_status_wrt = 0;
        else if(tok == FALSE) u_status_wrt = 1;
        else error("Invalid value for field 'status_wrt'.");
        break;
      case MARL_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_marl_wrt = 0;
        else if(tok == FALSE) u_marl_wrt = 1;
        else error("Invalid value for field 'marl_wrt'.");
        break;
      case MARH_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_marh_wrt = 0;
        else if(tok == FALSE) u_marh_wrt = 1;
        else error("Invalid value for field 'marh_wrt'.");
        break;
      case TDRL_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_tdrl_wrt = 0;
        else if(tok == FALSE) u_tdrl_wrt = 1;
        else error("Invalid value for field 'tdrl_wrt'.");
        break;
      case TDRH_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_tdrh_wrt = 0;
        else if(tok == FALSE) u_tdrh_wrt = 1;
        else error("Invalid value for field 'tdrh_wrt'.");
        break;
      case SIL_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_sil_wrt = 0;
        else if(tok == FALSE) u_sil_wrt = 1;
        else error("Invalid value for field 'sil_wrt'.");
        break;
      case SIH_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_sih_wrt = 0;
        else if(tok == FALSE) u_sih_wrt = 1;
        else error("Invalid value for field 'sih_wrt'.");
        break;
      case DIL_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_dil_wrt = 0;
        else if(tok == FALSE) u_dil_wrt = 1;
        else error("Invalid value for field 'dil_wrt'.");
        break;
      case DIH_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_dih_wrt = 0;
        else if(tok == FALSE) u_dih_wrt = 1;
        else error("Invalid value for field 'dih_wrt'.");
        break;
      case BPL_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_bpl_wrt = 0;
        else if(tok == FALSE) u_bpl_wrt = 1;
        else error("Invalid value for field 'bpl_wrt'.");
        break;
      case BPH_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_bph_wrt = 0;
        else if(tok == FALSE) u_bph_wrt = 1;
        else error("Invalid value for field 'bph_wrt'.");
        break;
      case SPL_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_spl_wrt = 0;
        else if(tok == FALSE) u_spl_wrt = 1;
        else error("Invalid value for field 'spl_wrt'.");
        break;
      case SPH_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_sph_wrt = 0;
        else if(tok == FALSE) u_sph_wrt = 1;
        else error("Invalid value for field 'sph_wrt'.");
        break;
      case PCL_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_pcl_wrt = 0;
        else if(tok == FALSE) u_pcl_wrt = 1;
        else error("Invalid value for field 'pcl_wrt'.");
        break;
      case PCH_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_pch_wrt = 0;
        else if(tok == FALSE) u_pch_wrt = 1;
        else error("Invalid value for field 'pch_wrt'.");
        break;
      case IRQ_VECTOR_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_irq_vector_wrt = 0;
        else if(tok == FALSE) u_irq_vector_wrt = 1;
        else error("Invalid value for field 'irq_vector_wrt'.");
        break;
      case IRQ_MASKS_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_irq_masks_wrt = 0;
        else if(tok == FALSE) u_irq_masks_wrt = 1;
        else error("Invalid value for field 'irq_masks_wrt'.");
        break;
      case CLEAR_ALL_IRQS:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_clear_all_irqs = 1;
        else if(tok == FALSE) u_clear_all_irqs = 0;
        else error("Invalid value for field 'clear_all_irqs'.");
        break;
      case PTB_WRT:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_ptb_wrt = 0;
        else if(tok == FALSE) u_ptb_wrt = 1;
        else error("Invalid value for field 'ptb_wrt'.");
        break;
      case DISPLAY_REG_LOAD:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_display_reg_load = 1;
        else if(tok == FALSE) u_display_reg_load = 0;
        else error("Invalid value for field 'display_reg_load'.");
        break;
      case IRQ_ACK:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_irq_ack = 1;
        else if(tok == FALSE) u_irq_ack = 0;
        else error("Invalid value for field 'irq_ack'.");
        break;
      case FORCE_USER_PTB:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_force_user_ptb = 1;
        else if(tok == FALSE) u_force_user_ptb = 0;
        else error("Invalid value for field 'force_user_ptb'.");
        break;
      case MDR_TO_PAGETABLE_BUFFER_EN:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_mdr_to_pagetable_buffer_en = 1;
        else if(tok == FALSE) u_mdr_to_pagetable_buffer_en = 0;
        else error("Invalid value for field 'mdr_to_pagetable_buffer_en'.");
        break;
      case PAGETABLE_WE:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == TRUE) u_pagetable_we = 1;
        else if(tok == FALSE) u_pagetable_we = 0;
        else error("Invalid value for field 'pagetable_we'.");
        break;
      case MAR_IN_SRC:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == ZBUS) u_mar_in_src = 0;
        else if(tok == PC) u_mar_in_src = 1;
        else error("Invalid value for field 'mar_in_src'.");
        break;
      case ZBUS_OUT_SRC:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == ALU_OUT) u_zbus_out_src = 0;
        else if(tok == SHIFTED_RIGHT) u_zbus_out_src = 1;
        else if(tok == SHIFTED_LEFT) u_zbus_out_src = 2;
        else if(tok == SIGN_EXTENDED) u_zbus_out_src = 3;
        else error("Invalid value for field 'zbus_out_src'.");
        break;
      case SHIFT_SRC:
        just_get();
        if(tok != EQUAL) error("Equal sign expected.");
        just_get();
        if(tok == GND) u_shift_src = 0;
        else if(tok == UCF) u_shift_src = 1;
        else if(tok == CF) u_shift_src = 2;
        else if(tok == ALU_OUT_0) u_shift_src = 3;
        else if(tok == ALU_OUT_7) u_shift_src = 4;
        else error("Invalid value for field 'shift_src'.");
        break;
      default:
        error("Unknown microcode field.");
    }
    //just_get();
    //if(tok != SEMICOLON) error("Semicolon expected.");
  } while(tok_type != END);



  // Shift Amount = New Position - Field Width + 1
  microcode_binary[current_instr][current_cycle][0]  = ((u_offset & 0x7F) << 2)    | u_next;        
  microcode_binary[current_instr][current_cycle][1]  = (u_escape << 7)             | (u_condition << 3)      | (u_cond_flags_src << 2)  | (u_condition_inv << 1) | ((u_offset & 0x7F) >> 6);
  microcode_binary[current_instr][current_cycle][2]  = (u_status_wrt << 7)         | (u_ir_wrt << 6)         | (u_uof_in_src << 5)      | (u_usf_in_src << 4)    | (u_ucf_in_src << 2)       | (u_uzf_in_src);
  microcode_binary[current_instr][current_cycle][3]  = ((u_alu_x & 0x07) << 5)     | (u_zbus_out_src << 3)   | (u_shift_src);
  microcode_binary[current_instr][current_cycle][4]  = (u_alu_mode << 7)           | (u_alu_op << 3)         | (u_alu_x >> 3);
  microcode_binary[current_instr][current_cycle][5]  = ((u_cf_in_src & 0x03) << 6) | (u_alu_cf_out_inv << 5) | (u_zf_in_src << 3)       | (u_alu_cf_in_inv << 2) | (u_alu_cf_in);
  microcode_binary[current_instr][current_cycle][6]  = (u_wr << 7)                 | (u_rd << 6)             | (u_of_in_src << 3)       | (u_sf_in_src << 1)     | (u_cf_in_src >> 2);
  microcode_binary[current_instr][current_cycle][7]  = (u_ch_wrt << 7)             | (u_cl_wrt << 6)         | (u_dh_wrt << 5)          | (u_dl_wrt << 4)        | (u_display_reg_load << 3) | (u_alu_y);
  microcode_binary[current_instr][current_cycle][8]  = (u_mdrl_wrt << 7)           | (u_mdr_out_en << 6)     | (u_mdr_out_src << 5)     | (u_mdr_in_src << 4)    | (u_ah_wrt << 3)           | (u_al_wrt << 2)        | (u_bh_wrt << 1)         | (u_bl_wrt);
  microcode_binary[current_instr][current_cycle][9]  = (u_marl_wrt << 7)           | (u_sih_wrt << 6)        | (u_sil_wrt << 5)         | (u_dih_wrt << 4)       | (u_dil_wrt << 3)          | (u_tdrh_wrt << 2)      | (u_tdrl_wrt << 1)       | (u_mdrh_wrt);
  microcode_binary[current_instr][current_cycle][10] = 0x80                        | (u_sph_wrt << 6)        | (u_spl_wrt << 5)         | (u_pch_wrt << 4)       | (u_pcl_wrt << 3)          | (u_bph_wrt << 2)       | (u_bpl_wrt << 1)        | (u_marh_wrt);
  microcode_binary[current_instr][current_cycle][11] = (u_pagetable_we << 7)       | (u_ptb_wrt << 6)        | (u_clear_all_irqs << 5)  | (u_irq_ack << 4)       | (u_mar_in_src << 3)       | (u_irq_masks_wrt << 2) | (u_irq_vector_wrt << 1) | 0x01;
  microcode_binary[current_instr][current_cycle][12] = (u_gh_wrt << 7)             | (u_gl_wrt << 6)           /* unused */               /* unused */             /* unused */                /* unused */           | (u_force_user_ptb << 1) | (u_mdr_to_pagetable_buffer_en);
  microcode_binary[current_instr][current_cycle][13] = u_immediate;
}

void process_include(){
  char *temp_prog;
  char previous_filename[ID_LEN];
  int previous_line_number;
  FILE *fp;
  int i;
  
  just_get(); // get filename
  if(tok_type != STRING_CONST) error("String constant expected.");
  strcpy(previous_filename, current_filename);
  strcpy(current_filename, string_const);
  previous_line_number = current_line;

  if((fp = fopen(string_const, "rb")) == NULL){
    printf("%s: Source file not found.\n", string_const);
    exit(1);
  }
  
  temp_prog = prog;
  prog = includes_file;
  i = 0;
  do{
    *prog = getc(fp);
    prog++;
    i++;
  } while(!feof(fp));
  *(prog - 1) = '\0'; // overwrite the EOF char with NULL
  fclose(fp);

  prog = includes_file;
  current_line = 1;
  parse_file();
  prog = temp_prog;
  // Because prog was at a different file (the includes file) and we reached the end, we get END as tok_type there
  // which will cause the main parse_file loop to exit.
  // So we need to change tok_type here before returning. Set it to STRING_CONST since this was in fact the last token before
  // We started parsing the includes file.
  tok_type = STRING_CONST;
  strcpy(current_filename, previous_filename);
  current_line = previous_line_number;
}

void declare_define(){
  just_get(); // get define's name
  if(tok_type != IDENTIFIER) error("Identifier expected in 'def' statement.");
  strcpy(defines_table[defines_tos].name, token);
  just_get(); // get definition
  strcpy(defines_table[defines_tos].content, token);
  defines_tos++;

  //just_get();
  //if(tok != SEMICOLON) error("Semicolon expected.");
}

int search_define(char *name){
  int i;
  for(i = 0; i < defines_tos; i++) 
    if(!strcmp(defines_table[i].name, name)) return i;
  return -1;
}

void error(const char* format, ...){
  int line = 1;
  char tempbuffer[1024];
  va_list args;
  va_start(args, format);
  vsnprintf(tempbuffer, sizeof(tempbuffer), format, args);
  va_end(args);

  printf("Error: %s\n", tempbuffer);

  prog = micro_in;
  while(prog != prog_before_error){
    if(*prog == '\n') line++;
    prog++;
  }

  printf("Filename: %s\n", current_filename);
  printf("Line Number: %d\n", line);
  just_get();
  printf("Near: %s\n\n", token);

  exit(1);
}

void get_tok(t_token token, char *format, ...){
  char tempbuffer[1024];
  va_list args;
  va_start(args, format);
  vsnprintf(tempbuffer, sizeof(tempbuffer), format, args);
  va_end(args);

  just_get();
  if(tok != token) error(tempbuffer);
}

void get_toktype(t_token_type token_type, char *format, ...){
  char tempbuffer[1024];
  va_list args;
  va_start(args, format);
  vsnprintf(tempbuffer, sizeof(tempbuffer), format, args);
  va_end(args);

  just_get();
  if(tok_type != token_type) error(tempbuffer);
}

void just_get(void){
  char *t;

  *token = '\0';
  tok = TOK_UNDEF;
  tok_type = TYPE_UNDEF;
  t = token;

  // Save the position of prog before getting a token. If an 'unexpected token' error occurs,
  // the position of prog before lines were skipped, will be known.  
  prog_before_error = prog;

/* Skip comments and whitespaces */
  do{
    while(is_space(*prog)){
      if(*prog == '\n') current_line++;
      prog++;
    }
    if(*prog == '/' && *(prog+1) == '/'){
      while(*prog != '\n' && *prog != '\0') prog++;
      if(*prog == '\n'){
        current_line++;
        prog++;
      }
    }
  } while(is_space(*prog) || (*prog == '/'));

  if(*prog == '\0'){
    tok_type = END;
    return;
  }
  
  if(is_identifier_char(*prog)){
    while(is_identifier_char(*prog) || is_digit(*prog)) *t++ = *prog++;
    *t = '\0';

    if((tok = search_keyword(token)) != -1) tok_type = RESERVED;
    else tok_type = IDENTIFIER;
  }
  else if(is_digit(*prog) || *prog == '-'){
    char temp_hex[64];
    char *p = temp_hex;
    if(*prog == '-'){
      *p++ = *prog;
      *t++ = *prog++;
    }
    if(*prog == '0' && *(prog+1) == 'x'){
      *p++ = *prog++;
      *p++ = *prog++;
      while(is_hex_digit(*prog)) *p++ = *prog++;
      *p = '\0';
      strcpy(token, temp_hex);
      sscanf(temp_hex, "%x", &int_const);
    }
    else{
      while(is_digit(*prog)) *t++ = *prog++;
      *t = '\0';
      sscanf(token, "%d", &int_const);
    }
    tok_type = INTEGER_CONST;
    return; // return to avoid *t = '\0' line at the end of function
  }
  else if(*prog == '%'){
    *t ++ = *prog++;
    while(*prog == '0' || *prog == '1' || *prog == '_') *t++ = *prog++;
    *t = '\0';
    int_const = binstr_to_int(token);
    tok_type = INTEGER_CONST;
    return; // return to avoid *t = '\0' line at the end of function
  }
  else if(*prog == '\"'){
    *t++ = '\"';
    prog++;
    while(*prog != '\"' && *prog) *t++ = *prog++;
    if(*prog != '\"') error("Closing double quotes expected.");
    *t++ = '\"';
    prog++;
    tok_type = STRING_CONST;
    *t = '\0';
    convert_constant(); 
  }
  else if(*prog == '='){
    *t++ = *prog++;
    tok = EQUAL;
    tok_type = DELIMITER;
  }
  else if(*prog == '~'){
    *t++ = *prog++;
    tok = NOT;
    tok_type = DELIMITER;
  }
  else if(*prog == '+'){
    *t++ = *prog++;
    tok = PLUS;
    tok_type = DELIMITER;
  }
  else if(*prog == ';'){
    *t++ = *prog++;
    tok = SEMICOLON;
    tok_type = DELIMITER;
  }
  else if(*prog == '#'){
    *t++ = *prog++;
    tok = HASH;
    tok_type = DELIMITER;
  }
  else if(*prog == '{'){
    *t++ = *prog++;
    tok = OPENING_BRACE;
    tok_type = DELIMITER;
  }
  else if(*prog == '}'){
    *t++ = *prog++;
    tok = CLOSING_BRACE;
    tok_type = DELIMITER;
  }
  else if(*prog == '`'){
    *t++ = *prog++;
    *t = '\0';
    tok_type = DELIMITER;
    tok = BACKTICK;
  }
  else if(*prog == ','){
    *t++ = *prog++;
    *t = '\0';
    tok_type = DELIMITER;
    tok = COMMA;
  }

  *t = '\0';
}

void back(void){
  char *t = token;

  while(*t++) prog--;
  tok = TOK_UNDEF;
  tok_type = TYPE_UNDEF;
  token[0] = '\0';
}

// Remove quoted from string
void convert_constant(){
  char *s = string_const;
  char *t = token;
  
  if(tok_type == STRING_CONST){
    t++;
    while(*t != '\"' && *t) *s++ = *t++;
  }
  *s = '\0';
}

unsigned char get_u_condition(){
  just_get();
  switch(tok){
    case ZF:                return 0x00;
    case CF:                return 0x01;
    case SF:                return 0x02;
    case OF:                return 0x03;
    case LT:                return 0x04;
    case LTU:               return 0x01;
    case LTE:               return 0x05;
    case LTEU:              return 0x06;
    case DMA_REQ:           return 0x07;
    case CPU_MODE:          return 0x08;
    case WAIT:              return 0x09;
    case IRQ_PENDING:       return 0x0A;
    case EXT_INPUT:         return 0x0B;
    case DIRECTION_FLAG:    return 0x0C;
    case DISPLAY_REG_LOAD:  return 0x0D;
    default:                error("Unknown field value for 'condition'.");
  }
}

char get_alu_cf_in(){
  just_get();
  switch(tok){
    case VCC:   return 0;
    case CF:    return 1;
    case UCF:   return 2;
    default:    error("Unknown field value for alu_cf_in.");
  }
}

char get_alu_op(char *op){
  register int i;
  
  for(i = 0; *alu_op[i].op; i++)
    if (!strcmp(alu_op[i].op, op)) return alu_op[i].key;
  
  error("Invalid alu operand: %s", op);
}

char get_alu_x_operand(char *operand){
  register int i;
  
  for(i = 0; *alu_x_operands[i].operand; i++)
    if (!strcmp(alu_x_operands[i].operand, operand)) return alu_x_operands[i].key;
  
  error("Invalid operand for alu x input: %s", operand);
}

char get_alu_y_operand(char *operand){
  register int i;
  
  for(i = 0; *alu_y_operands[i].operand; i++)
    if (!strcmp(alu_y_operands[i].operand, operand)) return (char)alu_y_operands[i].key;
  
  error("Invalid operand for alu y input: %s", operand);
}

int search_keyword(char *keyword){
  register int i;
  
  for(i = 0; *keyword_table[i].keyword; i++)
    if (!strcmp(keyword_table[i].keyword, keyword)) return keyword_table[i].key;
  
  return -1;
}

char is_hex_digit(char c){
  return c >= '0' && c <= '9' || 
         c >= 'a' && c <= 'f' || 
         c >= 'A' && c <= 'F';
}

char is_digit(char c){
  return c >= '0' && c <= '9';
}

char is_identifier_char(char c){
  return c >= 'a' && c <= 'z' || 
         c >= 'A' && c <= 'Z' || 
         c == '_';
}

char is_space(char c){
  return c == ' '  || 
         c == '\t' || 
         c == '\n' || 
         c == '\r';
}

// %1111_0000
int binstr_to_int(char *s){
  int result = 0;
  int current_power;
  int len;
  char *p, *p2;
  char s_without_separators[10];

  p2 = s_without_separators;
  p = s;
  while(*p){
    if(*p == '0' || *p == '1'){
      *p2 = *p;
      p2++;
    }
    p++;
  }
  *p2 = '\0';

  len = strlen(s_without_separators);
  current_power = len - 1;
  p = s_without_separators;

  while(*p){
    if(*p == '1'){
      result += pow(2.0, (double)(current_power));
      current_power--;
    }
    else if(*p == '0'){
      current_power--;
    }
    else error("Unexpected character in binary string: %c", *p);
    p++;
  }

  return result;
  
}