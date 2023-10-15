/*
  A C compiler for the Sol-1 Homebrew Minicomputer

  TODO:
  ** a change is needed so that when include files are used, only the functions that are actually used in the code
  are imported into the file, and not the whole of the included file.
  Process:
  read entire included files recursively.
  add them all to a single text file.
  scan thru main program, finding functions and then looking in the resulting include file for the function
  add function to main program.

  ** CORRECT MICROCODE FOR PUSHING INTO STACK !!!!

  ** fix goto: at present we cannot jump to a label that is declared after the goto.

  ** implement mov d, [bp + ...] instruction
  ** implement mov [b+ + ...], b
  ** implement lea di, [bp+@], etc
  ** implement lea si, [bp+@], etc

  ** fix array variable declarations.
*/

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <ctype.h>
#include <math.h>
#include "def.h"


int main(
  int argc, 
  char *argv[]
){
  int main_index;

  if(argc > 1) load_program(argv[1]);  
  else{
    printf("Usage: cc [filename]\n");
    return 0;
  }
  asm_p = asm_out;  // set ASM out pointer to the ASM array beginning
  data_block_p = data_block_asm; // data block pointer

  declare_heap();

  pre_processor();
  pre_scan();
  if((main_index = search_function("main")) != -1){
    if(search_function_parameter(main_index, "argc") != -1 && search_function_parameter(main_index, "argv") != -1){
      insert_runtime();
    }
  }

  emitln("; --- FILENAME: %s", argv[1]);
  if(include_kernel_exp) emitln(".include \"lib/kernel.exp\"");
  emitln(".include \"lib/bios.exp\"");
  emitln(".org %s", org);

  emit("\n; --- BEGIN TEXT BLOCK");
  parse_functions();
  emitln("; --- END TEXT BLOCK");

  optimize();

  asm_p = asm_out;
  while(*asm_p) asm_p++; 
  
  emitln("\n; --- BEGIN DATA BLOCK");
  emit_string_table_data();
  // Emit heap
  emit_data("\n_heap_top: .dw _heap\n");
  emit_data("_heap: .db 0\n");
  emit(data_block_asm);
  emitln("; --- END DATA BLOCK");

  emitln("\n.end");
  *asm_p = '\0';
  generate_file("a.s"); // generate a.s assembly file

  return 0;
}

void insert_runtime() {
  int i;
  int main_index;
  char *loc;

  main_index = -1;
  for(i = 0; i < function_table_tos; i++){
    if(!strcmp(function_table[i].name, "main")){
      main_index = i;
      break;
    }
  }
  if(main_index == -1) return;
  // Insert argc/argv grabbing code into main();
  loc = function_table[main_index].code_location;
  while(*loc != '{') loc++;
  insert(loc, runtime_argc_argv_getter);
}


void optimize(){
  optimize2();
  optimize1();
  optimize2();
  optimize1();
}

int is_register(
  char *name
){
  if(!strcmp(name, "a") ||
     !strcmp(name, "ah") ||
     !strcmp(name, "al") ||
     !strcmp(name, "b") ||
     !strcmp(name, "bh") ||
     !strcmp(name, "bl") ||
     !strcmp(name, "c") ||
     !strcmp(name, "ch") ||
     !strcmp(name, "cl") ||
     !strcmp(name, "d") ||
     !strcmp(name, "dh") ||
     !strcmp(name, "dl") ||
     !strcmp(name, "gh") ||
     !strcmp(name, "gl") ||
     !strcmp(name, "g") ||
     !strcmp(name, "si") ||
     !strcmp(name, "di") ||
     !strcmp(name, "sp") ||
     !strcmp(name, "bp")
  )
    return 1;
  else return 0;
}

void optimize2(){
  char *recovery, *temp_prog, *temp_prog2, *temp_prog3, *temp_prog4;
  char *address_p;
  char address[ID_LEN];
  char var_name[ID_LEN];
  int integer;
  prog = asm_out;

  for(;;){
    temp_prog = prog;
    get();
    if(toktype == END) break;
    if(!strcmp(token, "push")){
      get();
      if(!strcmp(token, "d")){
        temp_prog2 = prog;
        for(;;){
          temp_prog3 = prog;
          get();
          if(!strcmp(token, "pop")){
            get();
            if(!strcmp(token, "d")){
              delete(temp_prog, temp_prog2 - temp_prog);
              delete(temp_prog3, prog - temp_prog3);
              break;
            }
          }
          else if(!strcmp(token, "d") || !strcmp(token, "call")) break;
        }
      }
    }
  }
}

void optimize1(){
  char *recovery, *temp_prog, *temp_prog2, *temp_prog3, *temp_prog4;
  char *address_p;
  char address[ID_LEN];
  char var_name[ID_LEN];
  int integer;
  prog = asm_out;

  for(;;){
    temp_prog = prog;
    get();
    if(toktype == END) break;
    // mov d, ...
    // mov b, [d]
    if(!strcmp(token, "mov")){
      get();
      if(!strcmp(token, "d")){
        get();
        if(!strcmp(token, ",")){
          get();
          if(toktype == IDENTIFIER && !is_register(token)){
            strcpy(address, token);
            temp_prog2 = prog;
            get();
            if(tok == SEMICOLON){
              get();
              get();
              strcpy(var_name, token); // copy var name
              temp_prog2 = prog;
              get();
            }
            if(!strcmp(token, "mov")){
              get();
              if(!strcmp(token, "b")){
                get();
                if(!strcmp(token, ",")){
                  get();                 
                  if(!strcmp(token, "[")){
                    get();
                    if(!strcmp(token, "d")){
                      get();
                      if(!strcmp(token, "]")){
                        while(*temp_prog != '\n') temp_prog++;
                        temp_prog++;
                        delete(temp_prog, prog - temp_prog);
                        asm_p = temp_prog;
                        emit("  mov b, [%s] ; $%s", address, var_name);
                      }
                    }
                  }
                  else if(!strcmp(token, "d")){
                    while(*temp_prog != '\n') temp_prog++;
                    temp_prog++;
                    delete(temp_prog, prog - temp_prog);
                    asm_p = temp_prog;
                    emit("  mov b, %s ; $%s", address, var_name);
                  }
                }
              }
            }
            else prog = temp_prog2;
          }
        }
      }
      else if(!strcmp(token, "b") || !strcmp(token, "a")){
        get();
        if(!strcmp(token, ",")){
          get();
          if(toktype == IDENTIFIER && !is_register(token)){
            strcpy(address, token);
            temp_prog2 = prog;
            get();
            if(tok == SEMICOLON){
              get();
              get();
              strcpy(var_name, token); // copy var name
              temp_prog2 = prog;
              get();
            }
            if(!strcmp(token, "mov")){
              get();
              if(!strcmp(token, "si")){
                get();
                if(!strcmp(token, ",")){
                  get();                 
                  if(!strcmp(token, "b") || !strcmp(token, "a")){
                    while(*temp_prog != '\n') temp_prog++;
                    temp_prog++;
                    delete(temp_prog, prog - temp_prog);
                    asm_p = temp_prog;
                    emit("  mov si, %s ; $%s", address, var_name);
                  }
                }
              }
            }
            else prog = temp_prog2;
          }
        }
      }
    }
    // lea d, [bp + ...]
    // mov b, [d]
    else if(!strcmp(token, "lea")){
      get();
      if(!strcmp(token, "d")){
        get();
        if(!strcmp(token, ",")){
          get();
          if(!strcmp(token, "[")){
            address_p = address;
            while(*prog != ']'){
              *address_p++ = *prog++;
            }
            *address_p = '\0';
            prog++;
            get();
            if(tok == SEMICOLON){
              get();
              get();
              strcpy(var_name, token); // copy var name
              recovery = prog;
              get();
            } 
            else{
              back();
              recovery = prog;
              get();
            }
            if(!strcmp(token, "mov")){
              get();
              if(!strcmp(token, "b")){
                get();
                if(!strcmp(token, ",")){
                  get();                 
                  if(!strcmp(token, "[")){
                    get();
                    if(!strcmp(token, "d")){
                      get();
                      if(!strcmp(token, "]")){
                        while(*temp_prog != '\n') temp_prog++;
                        temp_prog++;
                        delete(temp_prog, prog - temp_prog);
                        asm_p = temp_prog;
                        emit("  mov b, [%s] ; $%s", address, var_name);
                      }
                    }
                  }
                  else{
                    prog = recovery;
                  }
                }
              }/*
              else if(!strcmp(token, "[")){
                get();
                if(!strcmp(token, "d")){
                  get();                 
                  if(!strcmp(token, "]")){
                    get();
                    if(!strcmp(token, ",")){
                      get();
                      if(!strcmp(token, "b")){
                        while(*temp_prog != '\n') temp_prog++;
                        temp_prog++;
                        delete(temp_prog, prog - temp_prog);
                        asm_p = temp_prog;
                        emit("  mov [%s], b ; $%s", address, var_name);
                      }
                    }
                  }
                  else{
                    prog = recovery;
                  }
                }
              }*/
              else if(!strcmp(token, "a")){
                get();
                if(!strcmp(token, ",")){
                  get();                 
                  if(!strcmp(token, "[")){
                    get();
                    if(!strcmp(token, "d")){
                      get();
                      if(!strcmp(token, "]")){
                        while(*temp_prog != '\n') temp_prog++;
                        temp_prog++;
                        delete(temp_prog, prog - temp_prog);
                        asm_p = temp_prog;
                        emit("  mov a, [%s] ; $%s", address, var_name);
                      }
                    }
                  }
                }
              }
              else if(!strcmp(token, "bl")){
                get();
                if(!strcmp(token, ",")){
                  get();                 
                  if(!strcmp(token, "[")){
                    get();
                    if(!strcmp(token, "d")){
                      get();
                      if(!strcmp(token, "]")){
                        get();
                        if(!strcmp(token, "mov")){
                          get();
                          if(!strcmp(token, "bh")){
                            get();
                            if(!strcmp(token, ",")){
                              get(); // get '0'
                              while(*temp_prog != '\n') temp_prog++;
                              temp_prog++;
                              delete(temp_prog, prog - temp_prog);
                              asm_p = temp_prog;
                              emitln("  mov bl, [%s] ; $%s", address, var_name);
                              emit("  mov bh, 0");
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
              else if(!strcmp(token, "al")){
                get();
                if(!strcmp(token, ",")){
                  get();                 
                  if(!strcmp(token, "[")){
                    get();
                    if(!strcmp(token, "d")){
                      get();
                      if(!strcmp(token, "]")){
                        while(*temp_prog != '\n') temp_prog++;
                        temp_prog++;
                        delete(temp_prog, prog - temp_prog);
                        asm_p = temp_prog;
                        emitln("  mov al, [%s] ; $%s", address, var_name);
                      }
                    }
                  }
                }
              }
            }
            else{
              prog = recovery;
            }
          }
        }

      }
    }
  }
}

void declare_argc_argv(){
  // Declare int argc, char argv [] variables
  // if argc and argv variables are in main(), then we create two new local variables inside main
  // such that int argc contains the number of arguments given in 0x00, with a space separator
  // and char argv[], will contain the string argument entries as a vector.
  // char argv[] is an array of pointers so each entry contains a pointer to an argument string.
  // 
  // for calculating argc, we need to write assembly that will count space separated arguments.
}

void declare_heap(){
  strcpy(global_var_table[global_var_tos].name, "heap_top");
  global_var_table[global_var_tos].type.basic_type = DT_CHAR;
  global_var_table[global_var_tos].type.is_constant = false;
  global_var_table[global_var_tos].type.dims[0] = 0;
  global_var_table[global_var_tos].type.ind_level = 1;
  global_var_table[global_var_tos].type.longness = LNESS_NORMAL;
  global_var_table[global_var_tos].type.signedness = SNESS_UNSIGNED;
  global_var_tos++;
}

void emit_data(const char* format, ...){
  char *bufferp = tempbuffer;
  va_list args;
  va_start(args, format);
  vsnprintf(tempbuffer, sizeof(tempbuffer), format, args);
  va_end(args);
  while (*bufferp) *data_block_p++ = *bufferp++;
}

void generate_file(char *filename){
  FILE *fp;
  
  if((fp = fopen(filename, "wb")) == NULL){
    printf("ERROR: Failed to create %s\n", filename);
    exit(1);
  }
  
  fprintf(fp, "%s", asm_out);

  fclose(fp);
}

void emit(const char* format, ...){
  char *bufferp = tempbuffer;
  va_list args;
  va_start(args, format);
  vsnprintf(tempbuffer, sizeof(tempbuffer), format, args);
  va_end(args);
  while (*bufferp) *asm_p++ = *bufferp++;
}

void emitln(const char* format, ...){
  char *bufferp = tempbuffer;
  va_list args;
  va_start(args, format);
  vsnprintf(tempbuffer, sizeof(tempbuffer), format, args);
  va_end(args);
  while (*bufferp) *asm_p++ = *bufferp++;
  *asm_p++ = '\n';
}

void load_program(char *filename){
  FILE *fp;
  char *prog;

  if((fp = fopen(filename, "rb")) == NULL){
    printf("ERROR: Source file '%s' not found.\n", filename);
    exit(1);
  }
  
  prog = c_in;
  for (;;) {
    int c = getc(fp);
    if (c == EOF || feof(fp)) break; // Exit the loop if end of file is reached
    *prog++ = (char)c;
  }
  *prog = '\0';
  fclose(fp);
}

void declare_all_locals(int function_id){
  int total_braces = 0;
  char *temp_prog;
  int total_sp;
  current_function_var_bp_offset = 0; 
  current_func_id = function_id;
  prog = function_table[function_id].code_location;

  total_sp = 0;
  for(;;){
    declare_all_locals_L0:
    temp_prog = prog;
    get();
    if(tok == ASM){
      for(;;){
        get();
        if(tok == CLOSING_BRACE) goto declare_all_locals_L0;
        if(toktype == END) error("Unterminated inline asm block.");
      }
    }
    if(tok == OPENING_PAREN){ // skip expressions inside parenthesis as they can't be variable declarations.
      for(;;){
        get();
        if(tok == CLOSING_PAREN) goto declare_all_locals_L0;
        if(toktype == END) error("Unterminated parenthesized expression.");
      }
    }
    if(tok == OPENING_BRACE) total_braces++;
    if(tok == CLOSING_BRACE) total_braces--;
    if(total_braces == 0) break;
    if(tok == INT || tok == CHAR || tok == VOID || tok == STRUCT){
      get();
      while(tok == STAR) get();
      get(); // get identifier
      get();
      if(tok != OPENING_PAREN){
        prog = temp_prog;
        total_sp += declare_local();
      }
    }
  }
  if(total_sp > 0) emitln("  sub sp, %d", total_sp);
}

void parse_functions(void){
  register int i;
  
  for(i = 0; *function_table[i].name; i++){
    // parse main function first
    if(strcmp(function_table[i].name, "main") == 0){
      // this is used to position local variables correctly relative to BP.
      // whenever a new function is parsed, this is reset to 0.
      // then inside the function it can increase according to how any local vars there are.
      emitln("\n%s:", function_table[i].name);
      emitln("  mov bp, $FFE0 ;");
      emitln("  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)");
      declare_all_locals(i);
      current_function_var_bp_offset = 0; 
      current_func_id = i;
      prog = function_table[i].code_location;
      parse_block(); // starts parsing the function block;

      if(return_is_last_statement == 0){ // generate code for a 'return'
        emitln("  syscall sys_terminate_proc");
      }
      break;
    }
  }

  for(i = 0; *function_table[i].name; i++){
    if(strcmp(function_table[i].name, "main") != 0){ // skip 'main'
      // this is used to position local variables correctly relative to BP.
      // whenever a new function is parsed, this is reset to 0.
      // then inside the function it can increase according to how any local vars there are.
      emitln("\n%s:", function_table[i].name);
      emitln("  enter 0 ; (push bp; mov bp, sp)");
      declare_all_locals(i);
      current_function_var_bp_offset = 0;
      current_func_id = i;
      prog = function_table[i].code_location;
      parse_block(); // starts parsing the function block;
      if(return_is_last_statement == 0){ // generate code for a 'return'
        emitln("  leave");
        emitln("  ret");
      }
    }
  }
}

void declare_define(){
  get(); // get define's name
  strcpy(defines_table[defines_tos].name, token);
  get(); // get definition
  strcpy(defines_table[defines_tos].content, token);
  defines_tos++;
}

void delete(char *start, int len){
  char *p = start;
  while(p < start + len){
    *p = ' ';
    p++;
  }
}

void insert(char *text, char *new_text){
  char *p = text;
  char *p2 = new_text;
  int len = strlen(new_text);
  while(*p) p++; // fast forwards to end of text
  while(p > text){
    *(p + len) = *p;
    *p = ' ';
    p--;
  }
  p++;
  while(*p2){
    *p = *p2;
    p++; p2++;
  }
}

void pre_processor(void){
  FILE *fp;
  int i, define_id;
  char *p, *temp_prog;
  char filename[256];

  prog = c_in; 
  do{
    get(); back(); // So that we discard possible new line chars at end of lines
    temp_prog = prog;
    get();
    if(toktype == END) break;

    if(tok == DIRECTIVE){
      get();
      if(tok == PRAGMA){
        get();
        if(!strcmp(token, "org")){
          get();
          if(toktype == STRING_CONST) strcpy(org, string_const);
          else strcpy(org, token);
          delete(temp_prog, prog - temp_prog);
        }
        else if(!strcmp(token, "noinclude")){
          get();
          if(!strcmp(string_const, "kernel.exp")) include_kernel_exp = 0;
          delete(temp_prog, prog - temp_prog);
        }
      }
      else if(tok == INCLUDE){
        get();
        if(toktype == STRING_CONST) strcpy(filename, string_const);
        else if(tok == LESS_THAN){
          strcpy(filename, libc_directory);
          for(;;){
            get();
            if(tok == GREATER_THAN) break;
            strcat(filename, token);
          }
        }
        else error("Syntax error in include directive.");
        if((fp = fopen(filename, "rb")) == NULL){
          printf("%s: Included source file not found.\n", filename);
          exit(1);
        }
        p = include_file_buffer;
        do{
          *p = getc(fp);
          if(*p == '\n') include_files_total_lines++;
          p++;
        } while(!feof(fp));
        *(p - 1) = '\0'; // overwrite the EOF char with NULL
        fclose(fp);
        delete(temp_prog, prog - temp_prog);
        insert(temp_prog, include_file_buffer);
        prog = c_in;
        continue;
      }
      else if(tok == DEFINE){
        declare_define();
        delete(temp_prog, prog - temp_prog);
        continue;
      }
    }
    else{
      if((define_id = search_define(token)) != -1){
        delete(temp_prog, prog - temp_prog);
        insert(temp_prog, defines_table[define_id].content);
        //prog = temp_prog; 
        continue;
      }
    }
  } while(toktype != END);

  prog = c_in;
}

int search_define(char *name){
  int i;
  for(i = 0; i < defines_tos; i++)
    if(!strcmp(defines_table[i].name, name)) return i;
  return -1;
}

void pre_scan(void){
  char *tp;
  int struct_id;

  prog = c_in;
  do{
    tp = prog;
    get();
    if(toktype == END) return;

    if(tok == TYPEDEF){
      declare_typedef();
      continue;
    }
    else if(tok == ENUM){
      declare_enum();
      continue;
    }
    else if(tok == STRUCT){
      get();
      get();
      if(tok == OPENING_BRACE){
        prog = tp;
        struct_id = declare_struct();
        continue;
      }
      else{
        prog = tp;
        get();
      }
    }

    if(tok == SIGNED || tok == UNSIGNED || tok == LONG || tok == CONST || tok == VOID || tok == CHAR || tok == INT || tok == FLOAT || tok == DOUBLE || tok == STRUCT){
      if(tok == CONST){
        get();
      }
      if(tok == SIGNED || tok == UNSIGNED) get();
      if(tok == LONG) get();
      if(tok == STRUCT){
        get(); // get struct's type name
        if(toktype != IDENTIFIER) error("Struct's type name expected.");
      }
      // if not a strut, then the var type has just been gotten
      get();
      if(tok == STAR){
        while(tok == STAR) get();
      }
      else{
        if(toktype != IDENTIFIER) error("Identifier expected in variable or function declaration.");
      }
      get(); // get semicolon, assignment, comma, or opening braces
      if(tok == OPENING_PAREN){ //it must be a function declaration
        prog = tp;
        declare_func();
        skip_block();
      }
      else{ //it must be a variable declaration
        prog = tp;
        declare_global();
      }
    }
    else error("Unexpected token during pre-scan phase: %s", token);
  } while(toktype != END);
}


void declare_func(void){
  t_user_func *func; // variable to hold a pointer to the user function top of stack
  int bp_offset; // for each parameter, keep the running offset of that parameter.
  char *temp_prog;
  int total_parameter_bytes;
  char param_name[ID_LEN];
  char is_main;
  char add_argc_argv;

  add_argc_argv = false;
  is_main = false;

  if(function_table_tos == MAX_USER_FUNC - 1) error("Maximum number of function declarations exceeded. Max: %d", MAX_USER_FUNC);
  func = &function_table[function_table_tos];

  get();
  func->return_type.signedness = SNESS_SIGNED; // set as signed by default
  func->return_type.longness = LNESS_NORMAL; 
  while(tok == SIGNED || tok == UNSIGNED || tok == LONG || tok == CONST){
         if(tok == SIGNED)   func->return_type.signedness = SNESS_SIGNED;
    else if(tok == UNSIGNED) func->return_type.signedness = SNESS_UNSIGNED;
    else if(tok == LONG)     func->return_type.longness   = LNESS_LONG;
    get();
  }
  func->return_type.basic_type = get_basic_type_from_tok();
  func->return_type.struct_id = -1;
  if(func->return_type.basic_type == DT_STRUCT){ // check if this is a struct
    get();
    func->return_type.struct_id = search_struct(token);
    if(func->return_type.struct_id == -1) error("Undeclared struct: %s", token);
  }

  get();
  while(tok == STAR){
    func->return_type.ind_level++;
    get();
  }
  strcpy(func->name, token);
  if(!strcmp(token, "main")) is_main = true;
  get(); // gets past "("

  func->local_var_tos = 0;
  func->num_arguments = 0;
  get();
  if(tok == CLOSING_PAREN || tok == VOID){
    if(tok == VOID) get();
  }
  else{
    back();
    temp_prog = prog;
    total_parameter_bytes = get_total_func_param_size();
    func->total_parameter_size = total_parameter_bytes;
    bp_offset = 4 + total_parameter_bytes; // +4 to account for pc and bp in the stack
    prog = temp_prog;
    do{
      // set as parameter so that we can tell that if a array is declared, the argument is also a pointer
      // even though it may not be declared with any '*' tokens;
      func->local_vars[func->local_var_tos].is_parameter = true;
      func->local_vars[func->local_var_tos].is_var_args  = false;
      temp_prog = prog;
      get();
      if(tok == VAR_ARGS){
        func->local_vars[func->local_var_tos].is_var_args = true;
        get();
        if(tok != CLOSING_PAREN) error("'...' needs to be the last function parameter if present.");
        back();
        goto complete_parameter_declaration;
      }
      if(tok == CONST){
        func->local_vars[func->local_var_tos].type.is_constant = true;
        get();
      }
      func->local_vars[func->local_var_tos].type.signedness = SNESS_SIGNED; // set as signed by default
      func->local_vars[func->local_var_tos].type.longness = LNESS_NORMAL; 
      while(tok == SIGNED || tok == UNSIGNED || tok == LONG){
             if(tok == SIGNED) func->local_vars[func->local_var_tos].type.signedness = SNESS_SIGNED;
        else if(tok == UNSIGNED) func->local_vars[func->local_var_tos].type.signedness = SNESS_UNSIGNED;
        else if(tok == LONG) func->local_vars[func->local_var_tos].type.longness = LNESS_LONG;
        get();
      }
      if(tok != VOID && tok != CHAR && tok != INT && tok != FLOAT && tok != DOUBLE && tok != STRUCT) error("Var type expected in argument declaration for function: %s", func->name);
      // gets the parameter type
      func->local_vars[func->local_var_tos].type.basic_type = get_basic_type_from_tok();
      func->local_vars[func->local_var_tos].type.struct_id = -1;
      if(func->local_vars[func->local_var_tos].type.basic_type == DT_STRUCT){ // check if this is a struct
        get();
        func->local_vars[func->local_var_tos].type.struct_id = search_struct(token);
        if(func->local_vars[func->local_var_tos].type.struct_id == -1) error("Undeclared struct: %s", token);
      }
      get();
      while(tok == STAR){
        func->local_vars[func->local_var_tos].type.ind_level++;
        get();
      }
      if(toktype != IDENTIFIER) error("Identifier expected");
      strcpy(param_name, token); // copy parameter name
      // Check if this is main, and argc or argv are declared
      // TODO: argc/argv need to be local to main but right now they are global
      if(is_main == true && (!strcmp(token, "argc") || !strcmp(token, "argv"))){
        add_argc_argv = true;
      }
      // checks if this is a array declaration
      get();
      int i = 0;
      func->local_vars[func->local_var_tos].type.dims[0] = 0; // in case its not a array, this signals that fact
      if(tok == OPENING_BRACKET){
        while(tok == OPENING_BRACKET){
          get();
          if(tok == CLOSING_BRACKET){ // dummy dimension in case this dimension is variable
            func->local_vars[func->local_var_tos].type.dims[i] = 1;
            i++;
            get();
            continue;
          }
          else{
            func->local_vars[func->local_var_tos].type.dims[i] = atoi(token);
            get();
            if(tok != CLOSING_BRACKET) error("Closing bracket expected");
            i++;
            get();
          }
        }
        func->local_vars[func->local_var_tos].type.dims[i] = 0; // sets the last variable dimention to 0, to mark the end of the list
      }
      prog = temp_prog;
      bp_offset -= get_param_size();
      // assign the bp offset of this parameter
      func->local_vars[func->local_var_tos].bp_offset = bp_offset + 1;

      // label
      complete_parameter_declaration:
        if(func->local_vars[func->local_var_tos].is_var_args){
          func->local_vars[func->local_var_tos].name[0] = '\0';
        }
        else
          strcpy(func->local_vars[func->local_var_tos].name, param_name);

      get();
      func->num_arguments++;
      func->local_var_tos++;
      if(func->local_vars[func->local_var_tos].is_var_args) break;
    } while(tok == COMMA);
  }
  if(tok != CLOSING_PAREN) error("Closing parenthesis expected");
  func->code_location = prog; // sets the function starting point to  just after the "(" token
  get(); // gets to the "{" token
  if(tok != OPENING_BRACE) error("Opening curly braces expected");
  back(); // puts the "{" back so that it can be found by skip_block()
  function_table_tos++;
}

int get_param_size(){
  int data_size;
  int struct_id;

  get();
  if(tok == CONST) get();
  if(tok == SIGNED || tok == UNSIGNED) get();
  
  switch(tok){
    case VAR_ARGS:
      data_size = 0; // assign zero here as the real size will be computed when the variable arguments are pushed
      break;
    case CHAR:
      data_size = 1;
      break;
    case INT:
      data_size = 2;
      break;
    case FLOAT:
      data_size = 2;
      break;
    case DOUBLE:
      data_size = 4;
      break;
    case STRUCT:
      get(); // get struct name
      struct_id = search_struct(token);
      data_size = get_struct_size(struct_id);
  }

  get(); // check for '*'
  if(tok == STAR){
    data_size = 2;
    while(tok == STAR) get();
  }

  get(); // check for brackets
  if(tok == OPENING_BRACKET){
    data_size = 2; // parameter is a pointer if it is an array
    while(tok == OPENING_BRACKET){
      get();
      if(tok == CLOSING_BRACKET){
        get();
        continue;
      }
      get(); // ']'
      get();
    }
    back();
  }
  else back();
  
  return data_size;
}


int get_total_func_param_size(void){
  int total_bytes;

  total_bytes = 0;
  do{
    total_bytes += get_param_size();
    get();
  } while(tok == COMMA);

  return total_bytes;
}

// > asgn d, shell_path
void parse_asm(void){
  char *temp_prog, *temp_prog2;
  char var_name[ID_LEN];
  char label_name[ID_LEN];
  char *p, *t;
  
  get();
  if(tok != OPENING_BRACE) error("Opening braces expected");
  emitln("\n; --- BEGIN INLINE ASM BLOCK");
  for(;;){
    while(is_space(*prog)) prog++;
    temp_prog = prog;
    get_line();
    if(strchr(string_const, '}')) break;
    else if(strchr(string_const, ':') 
         || strstr(string_const, ".include") 
         || strstr(string_const, ".db") 
         || strstr(string_const, ".dw") 
         || strstr(string_const, ".equ") 
         || strstr(string_const, ".EQU")){
      emitln(string_const);
    } 
    else if(strstr(string_const, "meta mov")){
      prog = temp_prog;
      get(); // get 'meta' operator
      get(); // get 'mov'
      get(); // get 'd' register
      if(strcmp(token, "d") && strcmp(token, "D")) error("'d' register expected in 'meta mov' operation.");
      get(); if(tok != COMMA) error("Comma expected.");
      get(); if(toktype != IDENTIFIER) error("Identifier expected.");
      emit_var_addr_into_d(token);
    }
    else{
      emitln("  %s", string_const);
    }
  }
  emitln("; --- END INLINE ASM BLOCK\n");
}

void parse_break(void){
       if(current_loop_type == FOR_LOOP)         emitln("  jmp _for%d_exit ; for break", current_label_index_for);
  else if(current_loop_type == WHILE_LOOP)       emitln("  jmp _while%d_exit ; while break", current_label_index_while);
  else if(current_loop_type == DO_LOOP)          emitln("  jmp _do%d_exit ; do break", current_label_index_do);
  else if(current_loop_type == SWITCH_CONSTRUCT) emitln("  jmp _switch%d_exit ; case break", current_label_index_switch);
  get();
}

void parse_continue(void){
       if(current_loop_type == FOR_LOOP)   emitln("  jmp _for%d_update ; for continue", current_label_index_for);
  else if(current_loop_type == WHILE_LOOP) emitln("  jmp _while%d_cond ; while continue", current_label_index_while);
  else if(current_loop_type == DO_LOOP)    emitln("  jmp _do%d_cond ; do continue", current_label_index_do);
  get();
}

void parse_for(void){
  char *update_loc;

  override_return_is_last_statement = 1;
  loop_type_stack[loop_type_tos] = current_loop_type;
  loop_type_tos++;
  current_loop_type = FOR_LOOP;
  highest_label_index++;
  label_stack_for[label_tos_for] = current_label_index_for;
  label_tos_for++;
  current_label_index_for = highest_label_index;

  get();
  if(tok != OPENING_PAREN) error("Opening parenthesis expected");
  emitln("_for%d_init:", current_label_index_for);
  get();
  if(tok != SEMICOLON){
    back();
    parse_expr();
  }
  if(tok != SEMICOLON) error("Semicolon expected");

  emitln("_for%d_cond:", current_label_index_for);
  // checks for an empty condition, which means always true
  get();
  if(tok != SEMICOLON){
    back();
    parse_expr();
    if(tok != SEMICOLON) error("Semicolon expected");
    emitln("  cmp b, 0");
    emitln("  je _for%d_exit", current_label_index_for);
  }

  update_loc = prog; // holds the location of incrementation part
  emitln("_for%d_block:", current_label_index_for);
  // gets past the update expression
  int paren = 1;
  do{
         if(*prog == '(') paren++;
    else if(*prog == ')') paren--;
    prog++;
  } while(paren && *prog);
  if(!*prog) error("Closing parenthesis expected");
  parse_block();
  
  emitln("_for%d_update:", current_label_index_for);
  prog = update_loc;
  // checks for an empty update expression
  get();
  if(tok != CLOSING_PAREN){
    back();
    parse_expr();
  }
  emitln("  jmp _for%d_cond", current_label_index_for);
  skip_statements();
  emitln("_for%d_exit:", current_label_index_for);

  label_tos_for--;
  current_label_index_for = label_stack_for[label_tos_for];
  loop_type_tos--;
  current_loop_type = loop_type_stack[loop_type_tos];

  override_return_is_last_statement = 0;
}

void parse_while(void){
  override_return_is_last_statement = 1;
  loop_type_stack[loop_type_tos] = current_loop_type;
  loop_type_tos++;
  current_loop_type = WHILE_LOOP;
  highest_label_index++;
  label_stack_while[label_tos_while] = current_label_index_while;
  label_tos_while++;
  current_label_index_while = highest_label_index;

  emitln("_while%d_cond:", current_label_index_while);
  get();
  if(tok != OPENING_PAREN) error("Opening parenthesis expected");
  parse_expr(); // evaluate condition
  if(tok != CLOSING_PAREN) error("Closing parenthesis expected");
  emitln("  cmp b, 0");
  emitln("  je _while%d_exit", current_label_index_while);
  emitln("_while%d_block:", current_label_index_while);
  parse_block();  // parse while block
  emitln("  jmp _while%d_cond", current_label_index_while);
  emitln("_while%d_exit:", current_label_index_while);

  label_tos_while--;
  current_label_index_while = label_stack_while[label_tos_while];
  loop_type_tos--;
  current_loop_type = loop_type_stack[loop_type_tos];
  override_return_is_last_statement = 0;
}

void parse_do(void){
  override_return_is_last_statement = 1;
  loop_type_stack[loop_type_tos] = current_loop_type;
  loop_type_tos++;
  current_loop_type = DO_LOOP;
  highest_label_index++;
  label_stack_do[label_tos_do] = current_label_index_do;
  label_tos_do++;
  current_label_index_do = highest_label_index;

  emitln("_do%d_block:", current_label_index_do);
  get();
  if(tok != OPENING_BRACE) error("Opening brace expected in 'do' statement.");
  back();
  parse_block();  // parse block

  emit_c_line();
  emitln("_do%d_cond:", current_label_index_do);
  get(); // get 'while'
  get();
  if(tok != OPENING_PAREN) error("Opening parenthesis expected");
  parse_expr(); // evaluate condition
  if(tok != CLOSING_PAREN) error("Closing parenthesis expected");
  emitln("  cmp b, 1");
  emitln("  je _do%d_block", current_label_index_do);

  emitln("_do%d_exit:", current_label_index_do);

  get();
  if(tok != SEMICOLON) error("Semicolon expected");

  label_tos_do--;
  current_label_index_do = label_stack_do[label_tos_do];
  loop_type_tos--;
  current_loop_type = loop_type_stack[loop_type_tos];
  override_return_is_last_statement = 0;
}

void parse_goto(void){
  int i;
  char label[256];

  get();
  if(toktype != IDENTIFIER) error("Identifier expected");
  for(i = 0; i < function_table[current_func_id].goto_labels_table_tos; i++){
    sprintf(label, "%s_%s", function_table[current_func_id].name, token);
    if(!strcmp(function_table[current_func_id].goto_labels_table[i], label)){
      emitln("  jmp %s", label);
      get();
      if(tok != SEMICOLON) error("Semicolon expected");
      return;
    }
  }
  error("Undeclared identifier: %s", token);
}

void parse_if(void){
  char *temp_p;

  override_return_is_last_statement = 1;
  highest_label_index++;
  label_stack_if[label_tos_if] = current_label_index_if;
  label_tos_if++;
  current_label_index_if = highest_label_index;

  emitln("_if%d_cond:", current_label_index_if);
  get();
  if(tok != OPENING_PAREN) error("Opening parenthesis expected");
  parse_expr(); // evaluate condition
  if(tok != CLOSING_PAREN) error("Closing parenthesis expected");
  emitln("  cmp b, 0");
  
  temp_p = prog;
  skip_statements(); // skip main IF block in order to check for ELSE block.
  get();
  if(tok == ELSE) 
    emitln("  je _if%d_else", current_label_index_if);
  else 
    emitln("  je _if%d_exit", current_label_index_if);
  prog = temp_p;
  emitln("_if%d_true:", current_label_index_if);
  parse_block();  // parse the positive condition block
  emitln("  jmp _if%d_exit", current_label_index_if);
  get(); // look for 'else'
  if(tok == ELSE){
    emitln("_if%d_else:", current_label_index_if);
    parse_block();  // parse the positive condition block
  }
  else back();
  emitln("_if%d_exit:", current_label_index_if);

  label_tos_if--;
  current_label_index_if = label_stack_if[label_tos_if];

  override_return_is_last_statement = 0;
}

void parse_return(void){
  get();
  if(tok != SEMICOLON){
    back();
    parse_expr();  // return value in register B
  }
  emitln("  leave");
  // check if this is "main"
  if(!strcmp(function_table[current_func_id].name, "main"))
    emitln("  syscall sys_terminate_proc");
  else 
    emitln("  ret");
}

/*
  switch(expr){
    case const1:

    case const2:

    default:
  }
  parse expr into b
  for each case, mov const into a
  cmp a, b
  if true, execute block
  else jmp to next block
  
*/
int count_cases(void){
  int nbr_cases = 0;

  for(;;){
    get();
    if(tok == OPENING_BRACE){
      back();
      skip_block();
    }
    else if(tok == CASE) nbr_cases++;
    else if(tok == CLOSING_BRACE || tok == DEFAULT) return nbr_cases;
  }
}


void skip_case(void){
  do{
    get();
    if(tok == OPENING_BRACE){
      back();
      skip_block();
      get();
    }
  } while(tok != CASE && tok != DEFAULT && tok != CLOSING_BRACE);

  if(tok == CASE){
    back();
    tok = CASE;
  }
}

void goto_next_case(void){
  int nbr_cases = 0;
  for(;;){
    get();
    if(tok == OPENING_BRACE){
      back();
      skip_block();
    }
    else if(tok == CASE) nbr_cases++;
    else if(tok == CLOSING_BRACE || tok == DEFAULT) return;
  }
}

void parse_switch(void){
  char *temp_p;
  int current_case_nbr;

  override_return_is_last_statement = 1;
  loop_type_stack[loop_type_tos] = current_loop_type;
  loop_type_tos++;
  current_loop_type = SWITCH_CONSTRUCT;
  highest_label_index++;
  label_stack_switch[label_tos_switch] = current_label_index_switch;
  label_tos_switch++;
  current_label_index_switch = highest_label_index;

  emitln("_switch%d_expr:", current_label_index_switch);
  get();
  if(tok != OPENING_PAREN) error("Opening parenthesis expected");
  parse_expr(); // evaluate condition
  if(tok != CLOSING_PAREN) error("Closing parenthesis expected");
  emitln("_switch%d_comparisons:", current_label_index_switch);

  get();
  if(tok != OPENING_BRACE) error("Opening braces expected");

  temp_p = prog;
  current_case_nbr = 0;
  // emit compares and jumps
  do{
    get();
    if(tok != CASE) error("Case expected");
    get();
    if(toktype == INTEGER_CONST){
      emitln("  cmp b, %d", int_const);
      emitln("  je _switch%d_case%d", current_label_index_switch, current_case_nbr);
      get();
      if(tok != COLON) error("Colon expected");
      skip_case();
    }
    else if(toktype == CHAR_CONST){
      emitln("  cmp bl, $%x", *string_const);
      emitln("  je _switch%d_case%d", current_label_index_switch, current_case_nbr);
      get();
      if(tok != COLON) error("Colon expected");
      skip_case();
    }
    else if(toktype == IDENTIFIER){
      if(enum_element_exists(token) != -1){
        emitln("  cmp b, %d", get_enum_val(token));
        emitln("  je _switch%d_case%d", current_label_index_switch, current_case_nbr);
        get();
        if(tok != COLON) error("Colon expected");
        skip_case();
      }
    }
    else error("Constant expected");
    current_case_nbr++;
  } while(tok == CASE);

  // generate default jump if it exists
  if(tok == DEFAULT){
    emitln("  jmp _switch%d_default", current_label_index_switch);
    get(); // get default
    get(); // get ':'
    skip_case();
  }

  emitln("  jmp _switch%d_exit", current_label_index_switch);

  // emit code for each case block
  prog = temp_p;
  current_case_nbr = 0;
  do{
    get(); // get 'case'
    get(); // get constant
    get(); // get ':'
    emitln("_switch%d_case%d:", current_label_index_switch, current_case_nbr);
    parse_case();
    current_case_nbr++;
    if(tok == CASE){
      back();
      tok = CASE;
    }
  } while(tok == CASE);

  if(tok == DEFAULT){
    get(); // get ':'
    emitln("_switch%d_default:", current_label_index_switch);
    parse_case();
    back();
  }
  else back();

  get(); // get the final '}'
  if(tok != CLOSING_BRACE) error("Closing braces expected");
  emitln("_switch%d_exit:", current_label_index_switch);
  
  label_tos_switch--;
  current_label_index_switch = label_stack_switch[label_tos_switch];
  loop_type_tos--;
  current_loop_type = loop_type_stack[loop_type_tos];

  override_return_is_last_statement = 0;
}

void parse_case(void){
  for(;;){
    get();
    switch(tok){
      case CASE:
      case DEFAULT:
      case CLOSING_BRACE:
        return;
      default:
        back();
        parse_block();
    }    
  } 
}

void emit_c_line(){
  char *temp = prog;
  char *s = string_const;
  back();
  while(*prog != 0x0A && *prog){
    *s++ = *prog++;
  }
  *s = '\0';
  emitln(";; %s ", string_const);
  prog = temp;
}

void parse_block(void){
  int braces = 0;
  char *temp_prog, *temp_prog2;
  char *temp;
  
  do{
    temp_prog = prog;
    get();
    if(tok != CLOSING_BRACE) return_is_last_statement = 0;
    switch(tok){
      case STATIC:
      case SIGNED:
      case UNSIGNED:
      case LONG:
      case VOID:
      case INT:
      case CHAR:
      case FLOAT:
      case DOUBLE:
      case STRUCT:
        do{
          get();
        } while(tok != SEMICOLON);
        break;
      case ASM:
        parse_asm();
        break;
      case GOTO:
        parse_goto();
        break;
      case IF:
        emit_c_line();
        parse_if();
        break;
      case SWITCH:
        emit_c_line();
        parse_switch();
        break;
      case FOR:
        emit_c_line();
        parse_for();
        break;
      case WHILE:
        emit_c_line();
        parse_while();
        break;
      case DO:
        emit_c_line();
        parse_do();
        break;
      case BREAK:
        emit_c_line();
        parse_break();
        break;
      case CONTINUE:
        emit_c_line();
        parse_continue();
        break;
      case OPENING_BRACE:
        braces++;
        break;
      case CLOSING_BRACE:
        braces--;
        break;
      case RETURN:
        emit_c_line();
        parse_return();
        if(!override_return_is_last_statement) return_is_last_statement = 1; // only consider this return as a final return if we are not inside an IF statement.
        break;
      default:
        if(toktype == END) error("Closing brace expected");
        emit_c_line();
        get();
        if(toktype == IDENTIFIER){
          get();
          if(tok == COLON){
            prog = temp_prog;
            declare_goto_label();
            continue;
          }
        }
        prog = temp_prog;
        parse_expr();
        if(tok != SEMICOLON) error("Semicolon expected");
    }    
  } while(braces); // exits when it finds the last closing brace
}

void declare_goto_label(void){
  int i, goto_tos;

  goto_tos = function_table[current_func_id].goto_labels_table_tos;
  get();
  for(i = 0; i < goto_tos; i++)
    if(!strcmp(function_table[current_func_id].goto_labels_table[i], token)) error("Duplicate label: %s", token);
  sprintf(function_table[current_func_id].goto_labels_table[goto_tos], "%s_%s", function_table[current_func_id].name, token);
  emitln("%s:", function_table[current_func_id].goto_labels_table[goto_tos]);
  function_table[current_func_id].goto_labels_table_tos++;
  get();
}

void skip_statements(void){
  int paren = 0;

  get();
  switch(tok){
    case ASM:
      skip_statements();
      break;
    case IF:
      // skips the conditional expression between parenthesis
      get();
      if(tok != OPENING_PAREN) error("Opening parenthesis expected");
      paren = 1; // found the first parenthesis
      do{
             if(*prog == '(') paren++;
        else if(*prog == ')') paren--;
        prog++;
      } while(paren && *prog);
      if(!*prog) error("Closing parenthesis expected");
      skip_statements();
      get();
      if(tok == ELSE) skip_statements();
      else back();
      break;
    case OPENING_BRACE: // if it's a block, then the block is skipped
      back();
      skip_block();
      break;
    case FOR:
      get();
      if(tok != OPENING_PAREN) error("Opening parenthesis expected");
      paren = 1;
      do{
             if(*prog == '(') paren++;
        else if(*prog == ')') paren--;
        prog++;
      } while(paren && *prog);
      if(!*prog) error("Closing paren expected");
      get();
      if(tok != SEMICOLON){
        back();
        skip_statements();
      }
      break;
    default: // if it's not a keyword, then it must be an expression
      back(); // puts the last token back, which might be a ";" token
      while(tok != SEMICOLON && toktype != END) get();
      //while(*prog++ != ';' && *prog);
      if(toktype == END) error("Semicolon expected");
  }
}

void skip_block(void){
  int braces = 0;
  
  do{
    get();
         if(tok == OPENING_BRACE) braces++;
    else if(tok == CLOSING_BRACE) braces--;
  } while(braces && toktype != END);
  if(braces && toktype == END) error("Closing braces expected");
}

void skip_array_bracket(void){
  int brackets = 0;
  
  do{
    get();
         if(tok == OPENING_BRACKET) brackets++;
    else if(tok == CLOSING_BRACKET) brackets--;
  } while(brackets && toktype != END);
  if(brackets && toktype == END) error("Closing brackets expected");
}

t_basic_type get_var_type(char *var_name){
  register int i;

  for(i = 0; i < function_table[current_func_id].local_var_tos; i++)
    if(!strcmp(function_table[current_func_id].local_vars[i].name, var_name))
      return function_table[current_func_id].local_vars[i].type.basic_type;

  for(i = 0; i < global_var_tos; i++)
    if(!strcmp(global_var_table[i].name, var_name)) 
      return global_var_table[i].type.basic_type;

  error("Undeclared variable: %s", var_name);
}

void emit_var_assignment__addr_in_d(t_type type){
  int var_id;
  char temp[ID_LEN];

  if(type.ind_level > 0 || type.basic_type == DT_INT)
    emitln("  mov [d], b");
  else if(type.basic_type == DT_CHAR)
    emitln("  mov [d], bl");
  else 
    error("Not able to resolve variable type");
}

t_type parse_expr(){
  t_type type;

  type.dims[0] = 0;
  type.ind_level = 0;
  type.basic_type = DT_INT;
  type.signedness = SNESS_SIGNED;
  type.longness = LNESS_NORMAL;
  get();
  if(tok == SEMICOLON) return type;
  else{
    back();
    return parse_assignment();
  }
}

int is_assignment(){
  char *temp_prog;
  int paren = 0, bracket = 0;
  int found_assignment = 0;

  temp_prog = prog;
  for(;;){
    get();
    if(paren == 0 && bracket == 0 && tok == ASSIGNMENT){
      found_assignment = 1;
      break;
    }
    if(toktype == END) error("Unterminated expression.");
    if(tok == SEMICOLON) break;
    if(tok == OPENING_PAREN) paren++;
    else if(tok == CLOSING_PAREN){
      if(paren == 0) break;
      else paren--;
    }
    else if(tok == OPENING_BRACKET) bracket++;
    else if(tok == CLOSING_BRACKET){
      if(bracket == 0) break; 
      else bracket--;
    }
  }
  prog = temp_prog;
  return found_assignment;
}

t_type parse_assignment(){
  char var_name[ID_LEN];
  char *temp_prog, *temp_asm_p;
  t_type expr_in, expr_out;
  int found_assignment;

  // Look for a '=' sign
  found_assignment = is_assignment();
  if(found_assignment == 0){
    expr_in = parse_ternary_op(); 
    expr_out = expr_in;
    return expr_out;
  }

  // is assignment
  get();
  if(toktype == IDENTIFIER){
    if(is_constant(token)) error("assignment of read-only variable: %s", token);
    strcpy(var_name, token);
    expr_in = emit_var_addr_into_d(var_name);
    get();
    // past '=' here
    emitln("  push d"); // save 'd'. this is the array base address. save because expr below could use 'd' and overwrite it
    parse_expr(); // evaluate expression, result in 'b'
    emitln("  pop d"); 
    if(expr_in.ind_level > 0 || expr_in.basic_type == DT_INT)
      emitln("  mov [d], b");
    else if(expr_in.basic_type == DT_CHAR)
      emitln("  mov [d], bl");
    else if(expr_in.basic_type == DT_STRUCT){
      emitln("  mov si, b");
      emitln("  mov di, d");
      emitln("  mov c, %d", get_total_type_size(expr_in));
      emitln("  rep movsb");
    }
    expr_out = expr_in;
    return expr_out;
  }
  else if(tok == STAR){ // tests if this is a pointer assignment
    expr_in = parse_atomic(); // parse what comes after '*' (considered a pointer)
    emitln("  push b"); // pointer given in 'b'. push 'b' into stack to save it. we will retrieve it below into 'd' for the assignment address
    // after evaluating the address expression, the token will be a "="
    if(tok != ASSIGNMENT) error("Syntax error: Assignment expected");
    parse_expr(); // evaluates the value to be assigned to the address, result in 'b'
    emitln("  pop d"); // now pop 'b' from before into 'd' so that we can recover the address for the assignment
    switch(expr_in.basic_type){
      case DT_CHAR:
        emitln("  mov [d], bl");
        break;
      case DT_INT:
        emitln("  mov [d], b");
        break;
      default: error("Invalid pointer");
    }
    expr_out = expr_in;
    expr_out.ind_level--;
    return expr_out;
  }
}

char is_constant(char *varname){
  int var_id;

  if((var_id = local_var_exists(varname)) != -1){ // is a local variable
    var_id = local_var_exists(varname);
    return function_table[current_func_id].local_vars[var_id].type.is_constant;
  }
  else if((var_id = global_var_exists(varname)) != -1)  // is a global variable
    return global_var_table[var_id].type.is_constant;
  else 
    error("Undeclared variable: %s", varname);
}

// A = cond1 ? true_val : false_val;
t_type parse_ternary_op(void){
  char *temp_prog, *temp_asm_p;
  t_type type1, type2, expr_out;

  temp_prog = prog;
  temp_asm_p = asm_p; // save current assembly output pointer
  emitln("_ternary%d_cond:", highest_label_index + 1); // +1 because we are emitting the label ahead
  parse_logical(); // evaluate condition
  if(tok != TERNARY_OP){
    prog = temp_prog;
    asm_p = temp_asm_p; // recover asm output pointer
    return parse_logical();
  }

  // '?' was found
  highest_label_index++;
  label_stack_ter[label_tos_ter] = current_label_index_ter;
  label_tos_ter++;
  current_label_index_ter = highest_label_index;
  emitln("  cmp b, 0");
  emitln("  je _ternary%d_false", current_label_index_ter);
  emitln("_ternary%d_true:", current_label_index_ter);
  type1 = parse_ternary_op(); // result in 'b'
  if(tok != COLON) error("Colon expected");
  emitln("  jmp _ternary%d_exit", current_label_index_ter);
  emitln("_ternary%d_false:", current_label_index_ter);
  type2 = parse_ternary_op(); // result in 'b'
  emitln("_ternary%d_exit:", current_label_index_ter);

  label_tos_ter--;
  current_label_index_ter = label_stack_ter[label_tos_ter];
  expr_out = cast(type1, type2);
  return expr_out;
}

t_type parse_logical(void){
  return parse_logical_or();
}

t_type parse_logical_or(void){
  t_type type1, expr_out;

  type1 = parse_logical_and();
  if(tok == LOGICAL_OR){
    emitln("  push a");
    while(tok == LOGICAL_OR){
      emitln("  mov a, b");
      parse_logical_and();
      emitln("  sor a, b ; ||");
    }
    emitln("  pop a");
    expr_out.ind_level = 0; // if is a logical operation then result is an integer with ind_level = 0
    expr_out.basic_type = DT_INT;
  }
  else{
    expr_out.basic_type = type1.basic_type;
    expr_out.ind_level = type1.ind_level;
  }
  return expr_out;
}

t_type parse_logical_and(void){
  t_type type1, expr_out;

  type1 = parse_bitwise_or();
  if(tok == LOGICAL_AND){
    emitln("  push a");
    while(tok == LOGICAL_AND){
      emitln("  mov a, b");
      parse_bitwise_or();
      emitln("  sand a, b ; &&");
    }
    emitln("  pop a");
    expr_out.ind_level = 0; // if is a logical operation then result is an integer with ind_level = 0
    expr_out.basic_type = DT_INT;
  }
  else{
    expr_out.basic_type = type1.basic_type;
    expr_out.ind_level = type1.ind_level;
  }
  return expr_out;
}

t_type parse_bitwise_or(void){
  t_type type1, type2, expr_out;

  type1 = parse_bitwise_xor();
  type2.basic_type = DT_CHAR;
  type2.ind_level = 0; // initialize so that cast works even if 'while' below does not trigger
  if(tok == BITWISE_OR){
    emitln("  push a");
    emitln("  mov a, b");
    while(tok == BITWISE_OR){
      type2 = parse_bitwise_xor();
      emitln("  or a, b ; &");
    }
    emitln("  mov b, a");
    emitln("  pop a");
  }
  expr_out = cast(type1, type2);
  return expr_out;
}

t_type parse_bitwise_xor(void){
  t_type type1, type2, expr_out;

  type1 = parse_bitwise_and();
  type2.basic_type = DT_CHAR;
  type2.ind_level = 0; // initialize so that cast works even if 'while' below does not trigger
  if(tok == BITWISE_XOR){
    emitln("  push a");
    emitln("  mov a, b");
    while(tok == BITWISE_XOR){
      type2 = parse_bitwise_and();
      emitln("  xor a, b ; ^");
    }
    emitln("  mov b, a");
    emitln("  pop a");
  }
  expr_out = cast(type1, type2);
  return expr_out;
}

t_type parse_bitwise_and(void){
  t_type type1, type2, expr_out;

  type1 = parse_relational();
  type2.basic_type = DT_CHAR;
  type2.ind_level = 0; // initialize so that cast works even if 'while' below does not trigger
  if(tok == BITWISE_AND){
    emitln("  push a");
    emitln("  mov a, b");
    while(tok == BITWISE_AND){
      type2 = parse_relational();
      emitln("  and a, b ; &");
    }
    emitln("  mov b, a");
    emitln("  pop a");
  }
  expr_out = cast(type1, type2);
  return expr_out;
}

t_type parse_relational(void){
  t_token temp_tok;
  t_type type1, type2, expr_out;

/* x = y > 1 && z<4 && y == 2 */
  temp_tok = TOK_UNDEF;
  type1 = parse_bitwise_shift();
  if(tok == EQUAL              || tok == NOT_EQUAL    || tok == LESS_THAN ||
     tok == LESS_THAN_OR_EQUAL || tok == GREATER_THAN || tok == GREATER_THAN_OR_EQUAL
  ){
    emitln("; START RELATIONAL");
    emitln("  push a");
    while(tok == EQUAL              || tok == NOT_EQUAL    || tok == LESS_THAN || 
          tok == LESS_THAN_OR_EQUAL || tok == GREATER_THAN || tok == GREATER_THAN_OR_EQUAL
    ){
      temp_tok = tok;
      emitln("  mov a, b");
      type2 = parse_bitwise_shift();
      expr_out = cast(type1, type2); // convert to a common type
      emitln("  cmp a, b");
      switch(temp_tok){
        case EQUAL:
          emitln("  seq ; ==");
          break;
        case NOT_EQUAL:
          emitln("  sneq ; !=");
          break;
        case LESS_THAN:
          if(expr_out.ind_level > 0 || expr_out.signedness == SNESS_UNSIGNED)
            emitln("  slu ; < (unsigned)");
          else
            emitln("  slt ; < ");
          break;
        case LESS_THAN_OR_EQUAL:
          if(expr_out.ind_level > 0 || expr_out.signedness == SNESS_UNSIGNED)
            emitln("  sleu ; <= (unsigned)");
          else
            emitln("  sle ; <=");
          break;
        case GREATER_THAN:
          if(expr_out.ind_level > 0 || expr_out.signedness == SNESS_UNSIGNED)
            emitln("  sgu ; > (unsigned)");
          else
            emitln("  sgt ; >");
          break;
        case GREATER_THAN_OR_EQUAL:
          if(expr_out.ind_level > 0 || expr_out.signedness == SNESS_UNSIGNED)
            emitln("  sgeu ; >= (unsigned)");
          else
            emitln("  sge ; >=");
      }
    }
    emitln("  pop a");
    emitln("; END RELATIONAL");
    expr_out.basic_type = DT_INT;
    expr_out.ind_level = 0; // if is a relational operation then result is an integer with ind_level = 0
    expr_out.signedness = SNESS_UNSIGNED;
  }
  else{
    expr_out.basic_type = type1.basic_type;
    expr_out.ind_level = type1.ind_level;
  }
  return expr_out;
}

t_type parse_bitwise_shift(void){
  t_token temp_tok;
  t_type type1, type2, expr_out;

  temp_tok = 0;
  type1 = parse_terms();
  type2.basic_type = DT_CHAR;
  type2.ind_level = 0; // initialize so that cast works even if 'while' below does not trigger
  if(tok == BITWISE_SHL || tok == BITWISE_SHR){
    emitln("; START SHIFT");
    emitln("  push a");
    emitln("  mov a, b");
    while(tok == BITWISE_SHL || tok == BITWISE_SHR){
      temp_tok = tok;
      type2 = parse_terms();
      emitln("  mov c, b"); // using 16bit values even though only cl is needed, because 'mov cl, bl' is not implemented as an opcode
      if(temp_tok == BITWISE_SHL){
        if(type1.signedness == SNESS_SIGNED) 
          emitln("  shl a, cl"); // there is no ashl, since it is equal to shl
        else 
          emitln("  shl a, cl");
      }
      else if(temp_tok == BITWISE_SHR){
        if(type1.signedness == SNESS_SIGNED) 
          emitln("  ashr a, cl");
        else 
          emitln("  shr a, cl");
      }
    }
    emitln("  mov b, a");
    emitln("  pop a");
    emitln("; END SHIFT");
  }
  expr_out = cast(type1, type2);
  return expr_out;
}

t_type parse_terms(void){
  t_token temp_tok;
  t_type type1, type2, expr_out;
  
  temp_tok = TOK_UNDEF;
  type1 = parse_factors();
  type2.basic_type = DT_CHAR;
  type2.ind_level = 0; // initialize so that cast works even if 'while' below does not trigger
  if(tok == PLUS || tok == MINUS){
    emitln("; START TERMS");
    emitln("  push a");
    emitln("  mov a, b");
    while(tok == PLUS || tok == MINUS){
      temp_tok = tok;
      type2 = parse_factors();
      if(temp_tok == PLUS) 
        emitln("  add a, b");
      else if(temp_tok == MINUS)
        emitln("  sub a, b");
    }
    emitln("  mov b, a");
    emitln("  pop a");
    emitln("; END TERMS");
  }
  expr_out = cast(type1, type2);
  return expr_out;
}

t_type parse_factors(void){
  t_token temp_tok;
  t_type type1, type2, expr_out;

// if type1 is an INT and type2 is a char*, then the result should be a char* still
  temp_tok = TOK_UNDEF;
  type1 = parse_atomic();
  type2.basic_type = DT_CHAR;
  type2.ind_level = 0; // initialize so that cast works even if 'while' below does not trigger
  if(tok == STAR || tok == FSLASH || tok == MOD) {
    emitln("; START FACTORS");
    emitln("  push a");
    emitln("  mov a, b");
    while(tok == STAR || tok == FSLASH || tok == MOD){
      temp_tok = tok;
      type2 = parse_atomic();
      if(temp_tok == STAR){
        emitln("  mul a, b ; *");
        emitln("  mov a, b");
      }
      else if(temp_tok == FSLASH){
        emitln("  div a, b");
      }
      else if(temp_tok == MOD){
        emitln("  div a, b ; %");
        emitln("  mov a, b");
      }
    }
    emitln("  mov b, a");
    emitln("  pop a");
    emitln("; END FACTORS");
  }
  expr_out = cast(type1, type2);
  return expr_out;
}

t_type parse_atomic(void){
  int var_id, func_id, string_id;
  char temp_name[ID_LEN], temp[1024];
  t_type expr_in, expr_out;

  get();
  if(toktype == STRING_CONST){
    string_id = search_string(string_const);
    if(string_id == -1) string_id = add_string_data(string_const);
    // now emit the reference to this string into the ASM
    emitln("  mov b, _s%d ; \"%s\"", string_id, string_const);
    expr_out.basic_type = DT_CHAR;
    expr_out.ind_level = 1;
    expr_out.signedness = SNESS_SIGNED;
  }
  else if(tok == SIZEOF){
    get();
    expect(OPENING_PAREN, "Opening parenthesis expected");
    get();
    if(toktype == IDENTIFIER){
      if(local_var_exists(token) != -1){ // is a local variable
        var_id = local_var_exists(token);
        emitln("  mov b, %d", get_total_type_size(function_table[current_func_id].local_vars[var_id].type));
      }
      else if(global_var_exists(token) != -1){  // is a global variable
        var_id = global_var_exists(token);
        emitln("  mov b, %d", get_total_type_size(global_var_table[var_id].type));
      }
      else error("Undeclared identifier: %s", token);
    }
    else switch(tok){
      case CHAR:
        emitln("  mov b, 1");
        break;
      case INT:
        emitln("  mov b, 2");
        break;
    }
    get();
    expr_out.basic_type = DT_INT;
    expr_out.ind_level = 0;
    expr_out.signedness = SNESS_SIGNED;
    expect(CLOSING_PAREN, "Closing paren expected");
  }
  else if(tok == STAR){ // is a pointer operator
    expr_in = parse_atomic(); // parse expression after STAR, which could be inside parenthesis. result in B
    emitln("  mov d, b");// now we have the pointer value. we then get the data at the address.
    if(expr_in.basic_type == DT_INT || expr_in.ind_level > 1)
      emitln("  mov b, [d]"); 
    else if(expr_in.basic_type == DT_CHAR){
      emitln("  mov bl, [d]"); 
      emitln("  mov bh, 0");
    }
    back();
    expr_out.basic_type = expr_in.basic_type;
    expr_out.ind_level = expr_in.ind_level - 1;
    expr_out.signedness = expr_in.signedness;
  }
  else if(tok == AMPERSAND){
    get(); // get variable name
    if(toktype != IDENTIFIER) error("Identifier expected");
    expr_in = emit_var_addr_into_d(token);
    emitln("  mov b, d");
    expr_out.ind_level++;
  }
  else if(toktype == INTEGER_CONST){
    int i;
    emitln("  mov b, $%x", int_const);
    i = int_const;
    expr_out.basic_type = DT_INT;
    expr_out.ind_level = 0;
    expr_out.signedness = i > 32767 || i < -32768 ? SNESS_UNSIGNED : SNESS_SIGNED;
  }
  else if(toktype == CHAR_CONST){
    emitln("  mov b, $%x", string_const[0]);
    expr_out.basic_type = DT_INT; // considering it an INT as an experiment for now
    expr_out.ind_level = 0;
    expr_out.signedness = SNESS_UNSIGNED;
  }
  // -127, -128, -255, -32768, -32767, -65535
  else if(tok == MINUS){
    expr_in = parse_atomic(); // TODO: add error if type is pointer since cant neg a pointer
    if(expr_in.ind_level > 0 || expr_in.basic_type == DT_INT) 
      emitln("  neg b");
    else 
      emitln("  neg b"); // treating as int as experiment
    back();
    expr_out.basic_type = DT_INT; // convert to int
    expr_out.ind_level = 0;
    expr_out.signedness = expr_in.signedness;
  }
  else if(tok == BITWISE_NOT){
    expr_in = parse_atomic(); // in 'b'
    if(expr_in.ind_level > 0 || expr_in.basic_type == DT_INT) 
      emitln("  not b");
    else 
      emitln("  not b"); // treating as int as an experiment
    expr_out.basic_type = DT_INT;
    expr_out.ind_level = 0;
    expr_out.signedness = expr_in.signedness;
    back();
  }
  else if(tok == LOGICAL_NOT){
    expr_in = parse_atomic(); // in 'b'
    emitln("  cmp b, 0");
    emitln("  seq ; !");
    back();
    expr_out.basic_type = DT_INT;
    expr_out.ind_level = 0;
    expr_out.signedness = SNESS_UNSIGNED;
  }
  else if(tok == OPENING_PAREN){
    int ind_level = 0;
    char _signed = 1, _unsigned = 0;
    get();
    if(tok != SIGNED && tok != UNSIGNED && tok != INT && tok != CHAR){
      back();
      expr_in = parse_expr();  // parses expression between parenthesis and result will be in B
      expr_out = expr_in;
      if(tok != CLOSING_PAREN) error("Closing paren expected");
    }
    else{
      if(tok == SIGNED){
        _signed = 1;
        get();
      }
      else if(tok == UNSIGNED){
        _unsigned = 1;
        _signed = 0;
        get();
      }
      if(tok == VOID){
        get();
        while(tok == STAR){
          ind_level++;
          get();
        }
        expect(CLOSING_PAREN, "Closing paren expected");
        if(ind_level == 0) error("Invalid data type 'void'.");
        expr_in = parse_atomic();
        expr_out = expr_in;
        expr_out.basic_type = DT_VOID;
        expr_out.ind_level = ind_level;
        back();
      }
      else if(tok == INT){
        get();
        while(tok == STAR){
          ind_level++;
          get();
        }
        expect(CLOSING_PAREN, "Closing paren expected");
        if(_signed == 1 && ind_level == 0) emitln("  snex b"); // sign extend b
        else if(_unsigned == 1 && ind_level == 0) emitln("  mov bh, 0"); // zero extend b
        expr_in = parse_atomic();
        expr_out = expr_in;
        expr_out.basic_type = DT_INT;
        expr_out.ind_level = ind_level;
        back();
      }
      else if(tok == CHAR){
        get();
        while(tok == STAR){
          ind_level++;
          get();
        }
        expect(CLOSING_PAREN, "Closing paren expected");
        expr_in = parse_atomic();
        if(ind_level == 0) emitln("  mov bh, 0"); // zero out bh to make it a char
        expr_out = expr_in;
        expr_out.basic_type = DT_CHAR;
        expr_out.ind_level = ind_level;
        back();
      }
    }
  }
  else if(tok == INCREMENT){  // pre increment. do increment first
    get();
    if(toktype != IDENTIFIER) error("Identifier expected");
    strcpy(temp_name, token);
    expr_in = emit_var_addr_into_d(temp_name);
    emitln("  mov b, [d]");
    if(get_pointer_unit(expr_in) > 1) {
      emitln("  inc b");
      emitln("  inc b");
    }
    else 
      emitln("  inc b");
    emit_var_addr_into_d(temp_name);
    emit_var_assignment__addr_in_d(expr_in);
    expr_out = expr_in;
  }    
  else if(tok == DECREMENT){ // pre decrement. do decrement first
    get();
    if(toktype != IDENTIFIER) error("Identifier expected");
    strcpy(temp_name, token);
    expr_in = emit_var_addr_into_d(temp_name);
    emitln("  mov b, [d]");
    if(get_pointer_unit(expr_in) > 1) {
      emitln("  dec b");
      emitln("  dec b");
    }
    else 
      emitln("  dec b");
    emit_var_addr_into_d(temp_name);
    emit_var_assignment__addr_in_d(expr_in);
    expr_out = expr_in;
  }    
  else if(toktype == IDENTIFIER){
    strcpy(temp_name, token);
    get();
    if(tok == OPENING_PAREN){ // function call      
      func_id = search_function(temp_name);
      if(func_id != -1){
        expr_out = function_table[func_id].return_type; // get function's return type
        parse_function_call(func_id);
        /*
        expr_out = function_table[func_id].return_type; // get function's return type
        parse_function_arguments(func_id);
        emit("  call ");
        emitln(temp_name);
        if(tok != CLOSING_PAREN) error("Closing paren expected");
        // the function's return value is in register B
        if(function_table[func_id].total_parameter_size > 0)
          // clean stack of the arguments added to it
          emitln("  add sp, %d", function_table[func_id].total_parameter_size);
          */
      }
      else error("Undeclared function: %s", temp_name);
    }
    else if(enum_element_exists(temp_name) != -1){
      back();
      emitln("  mov b, %d; %s", get_enum_val(temp_name), temp_name);
      expr_out.basic_type = DT_INT;
      expr_out.ind_level = 0;
      expr_out.signedness = SNESS_SIGNED; // TODO: check enums can always be signed...
    }
    else{
      back();
      expr_in = emit_var_addr_into_d(temp_name); // into 'b'
      // emit base address for variable, whether struct or not
      back();
      if(is_array(expr_in))
        emitln("  mov b, d");
      else if(expr_in.ind_level > 0 || expr_in.basic_type == DT_INT)
        emitln("  mov b, [d]"); 
      else if(expr_in.basic_type == DT_CHAR){
        emitln("  mov bl, [d]");
        emitln("  mov bh, 0"); 
      }
      else if(expr_in.basic_type == DT_STRUCT)
        emitln("  mov b, d");
      expr_out = expr_in;
    }
  }
  else error("Invalid expression");

// Check for post ++/--
  get();
  if(tok == INCREMENT){  // post increment. get value first, then do assignment
    emitln("  mov g, b"); 
    if(get_pointer_unit(expr_in) > 1) {
      emitln("  inc b");
      emitln("  inc b");
    }
    else 
      emitln("  inc b");
    emit_var_addr_into_d(temp_name);
    emitln("  mov [d], b");
    emitln("  mov b, g");
    expr_out = expr_in;
    get(); // gets the next token (it must be a delimiter)
  }    
  else if(tok == DECREMENT){ // post decrement. get value first, then do assignment
    emitln("  mov g, b");
    if(get_pointer_unit(expr_in) > 1){
      emitln("  dec b");
      emitln("  dec b");
    }
    else
      emitln("  dec b");
    emit_var_addr_into_d(temp_name);
    emitln("  mov [d], b");
    emitln("  mov b, g");
    expr_out = expr_in;
    get(); // gets the next token (it must be a delimiter)
  } 

  return expr_out;
}

int parse_variable_args(int func_id){
  int param_index = 0;
  t_type expr_in;
  int current_func_call_total_args;

  param_index = 0;
  current_func_call_total_args = 0;
  do{
    expr_in = parse_expr();
    current_func_call_total_args += get_type_size_for_func_arg_parsing(expr_in);
    if(expr_in.ind_level > 0 || 
      is_array(expr_in)
    ){
      emitln("  swp b");
      emitln("  push b");
    }
    else if(expr_in.basic_type == DT_STRUCT){
      emitln("  sub sp, %d", get_type_size_for_func_arg_parsing(expr_in));
      emitln("  mov si, b"); 
      emitln("  lea d, [sp + 1]");
      emitln("  mov di, d");
      emitln("  mov c, %d", get_type_size_for_func_arg_parsing(expr_in));
      emitln("  rep movsb");
    }
    else{
      switch(expr_in.basic_type){
        case DT_CHAR:
          emitln("  push bl");
          break;
        case DT_INT:
          if(expr_in.basic_type == DT_CHAR && expr_in.ind_level == 0){
            emitln("  snex b");
          }
          emitln("  swp b");
          emitln("  push b");
          break;
      }
    }
    param_index++;
  } while(tok == COMMA);
  if(tok != CLOSING_PAREN) error("Closing paren expected");
  return current_func_call_total_args;
}

void parse_function_call(int func_id){
  int param_index = 0;
  t_type expr_in;
  char num_arguments;
  int current_func_call_total_args;

  //current_func_call_total_args = function_table[func_id].total_parameter_size; // Necessary because it so happens that when we backtrack compilation, we need to reset the total number of found parameters to the original number found when the funtion is defined, so that we can then add the variable arguments on top of that number. Otherwise we'd keep adding and adding each time we backtrack and re-execute this function.
  get();
  if(tok == CLOSING_PAREN){
    if(function_table[func_id].num_arguments != 0 && !has_var_args(func_id))
      error("Incorrect number of arguments for function: %s. Expecting %d, detected: 0", function_table[func_id].name, function_table[func_id].num_arguments);
    else{
      emitln("  call %s", function_table[func_id].name);
      return;
    }
  }
  back();
  param_index = 0;
  current_func_call_total_args = 0;
  do{
    if(function_table[func_id].local_vars[param_index].is_var_args){
      current_func_call_total_args += parse_variable_args(func_id);
      break;
    }
    else{
      expr_in = parse_expr();
      current_func_call_total_args += get_type_size_for_func_arg_parsing(function_table[func_id].local_vars[param_index].type);
      if(function_table[func_id].local_vars[param_index].type.ind_level > 0 || 
        is_array(function_table[func_id].local_vars[param_index].type)
      ){
        emitln("  swp b");
        emitln("  push b");
      }
      else if(function_table[func_id].local_vars[param_index].type.basic_type == DT_STRUCT){
        emitln("  sub sp, %d", get_type_size_for_func_arg_parsing(function_table[func_id].local_vars[param_index].type));
        emitln("  mov si, b"); 
        emitln("  lea d, [sp + 1]");
        emitln("  mov di, d");
        emitln("  mov c, %d", get_type_size_for_func_arg_parsing(function_table[func_id].local_vars[param_index].type));
        emitln("  rep movsb");
      }
      else{
        switch(function_table[func_id].local_vars[param_index].type.basic_type){
          case DT_CHAR:
            emitln("  push bl");
            break;
          case DT_INT:
            if(expr_in.basic_type == DT_CHAR && expr_in.ind_level == 0){
              emitln("  snex b");
            }
            emitln("  swp b");
            emitln("  push b");
            break;
        }
      }
    }
    param_index++;
  } while(tok == COMMA);

  // Check if the number of arguments matches the number of function parameters
  // but only if the function does not have variable arguments
  if(function_table[func_id].num_arguments != param_index && !has_var_args(func_id))  
    error("Incorrect number of arguments for function: %s. Expecting %d, detected: %d", function_table[func_id].name, function_table[func_id].num_arguments, param_index);

  emitln("  call %s", function_table[func_id].name);
  if(tok != CLOSING_PAREN) error("Closing paren expected");
  // the function's return value is in register B
  if(function_table[func_id].total_parameter_size > 0)
    emitln("  add sp, %d", current_func_call_total_args); // clean stack of the arguments added to it
}
void dbg_print_var_info(t_var *var){
  int i;
  int local = 0;
  if(local_var_exists(var->name) != -1) local = 1;
  printf("*******************************************\n");
  printf("Name: %s\n", var->name);
  printf("Scope: %s\n", local ? "Local" : "Global");
  printf("Func Name: %s\n", function_table[var->function_id].name);
  printf("Is Parameter: %d\n", var->is_parameter);
  printf("Is Static: %d\n", var->is_static);
  printf("Basic Type: %s\n", basic_type_to_str_table[var->type.basic_type]);
  for(i = 0; var->type.dims[i]; i++)
    printf("Dims[%d]: %d\n", i, var->type.dims[i]);
  printf("Ind Level: %d\n", var->type.ind_level);
  printf("Longness: %d\n", var->type.longness);
  printf("Signedness: %d\n", var->type.signedness);
  printf("Struct ID: %d\n", var->type.struct_id);
  printf("*******************************************\n");
}

void dbg_print_type_info(t_type *type){
  int i;

  printf("*******************************************\n");
  printf("Basic Type: %s\n", basic_type_to_str_table[type->basic_type]);
  for(i = 0; type->dims[i]; i++)
    printf("Dims[%d]: %d\n", i, type->dims[i]);
  printf("Ind Level: %d\n", type->ind_level);
  printf("Longness: %d\n", type->longness);
  printf("Signedness: %d\n", type->signedness);
  printf("Struct ID: %d\n", type->struct_id);
  printf("*******************************************\n");
}

int get_struct_element_offset(int struct_id, char *name){
  int offset = 0;

  for(int i = 0; *struct_table[struct_id].elements[i].name; i++)
    if(!strcmp(struct_table[struct_id].elements[i].name, name))
      return offset;
    else
      offset += get_total_type_size(struct_table[struct_id].elements[i].type);
}

t_type get_struct_element_type(int struct_id, char *name){
  for(int i = 0; *struct_table[struct_id].elements[i].name; i++)
    if(!strcmp(struct_table[struct_id].elements[i].name, name))
      return struct_table[struct_id].elements[i].type;
  error("Undeclared struct element: %s", name);
}

/* function used for dealihg with pointer arithmetic.
since for example:
char *p;
p++ increases p by one
whereas:
char **p;
p++ increases p by 2 since it is a pointer to pointer.
*/
int get_pointer_unit(t_type type){
  switch(type.basic_type){
    case DT_VOID:
      return 1;
      break;
    case DT_CHAR:
      if(type.ind_level > 1) 
        return 2;
      else 
        return 1;
      break;
    case DT_INT:
      if(type.ind_level == 0) 
        return 1;
      else 
        return 2;
      break;
  }
}

t_type emit_array_arithmetic(t_type type){
  t_type expr_out;
  int i, dims; // array data size

  expr_out = type;
  dims = array_dim_count(type); // gets the number of dimensions for this array
  emitln("  push a"); // needed because for loop below will modify 'a'. But 'a' is used by functions such as parse_terms, so keep previous results. so we cannot overwrite 'a' here.
  for(i = 0; i < dims; i++){
    expr_out.dims[dims - i - 1] = 0; // decrease array dimensions as they get parsed so that the final data type makes sense
    emitln("  push d"); // save 'd' in case the expressions inside brackets use 'd' for addressing (likely)
    parse_expr(); // result in 'b'
    emitln("  pop d");
    if(get_array_offset(i, type) > 1){ // optimize it so there's no multiplication if not needed
      emitln("  mma %u ; mov a, %u; mul a, b; add d, b", get_array_offset(i, type), get_array_offset(i, type)); // mov a, u16; mul a, b; add d, b
    }
    else 
      emitln("  add d, b");
    if(tok != CLOSING_BRACKET) error("Closing brackets expected");
    get();
    if(tok != OPENING_BRACKET){
      back();
      break;
    }
  }
  emitln("  pop a");
  
  return expr_out;
}

/*
+---------------+---------------+---------------+
| Operand 1     | Operand 2     | Result        |
+---------------+---------------+---------------+
| signed char   | signed char   | signed int    |
| signed char   | unsigned char | signed int    |
| signed char   | signed int    | signed int    |
| signed char   | unsigned int  | unsigned int  |
| unsigned char | signed char   | signed int    |
| unsigned char | unsigned char | unsigned int  |
| unsigned char | signed int    | signed int    |
| unsigned char | unsigned int  | unsigned int  |
| signed int    | signed char   | signed int    |
| signed int    | unsigned char | signed int    |
| signed int    | signed int    | signed int    |
| signed int    | unsigned int  | unsigned int  |
| unsigned int  | signed char   | unsigned int  |
| unsigned int  | unsigned char | unsigned int  |
| unsigned int  | signed int    | unsigned int  |
| unsigned int  | unsigned int  | unsigned int  |
+---------------+---------------+---------------+
*/
t_type cast(t_type t1, t_type t2){
  t_type type;

  switch(t1.basic_type){
    case DT_CHAR:
      switch(t2.basic_type){
        case DT_CHAR:
          if(t1.ind_level > 0){
            type.basic_type = DT_CHAR;
            type.ind_level  = t1.ind_level;
            type.signedness = t1.signedness;
          }
          else if(t2.ind_level > 0){
            type.basic_type = DT_CHAR;
            type.ind_level  = t2.ind_level;
            type.signedness = t2.signedness;
          }
          else{
            type.basic_type = DT_INT;
            type.ind_level  = 0;
            type.signedness = SNESS_SIGNED;
          }
          break;
        case DT_INT:
          if(t1.ind_level > 0){
            type.basic_type = DT_CHAR;
            type.ind_level  = t1.ind_level;
            type.signedness = t1.signedness;
          }
          else if(t2.ind_level > 0){
            type.basic_type = DT_INT;
            type.ind_level  = t2.ind_level;
            type.signedness = t2.signedness;
          }
          else{
            type.basic_type = DT_INT;
            type.ind_level  = 0;
            type.signedness = t2.signedness; // assign whatever the int's signedness is
          }
      }
      break;
    case DT_INT:
      switch(t2.basic_type){
        case DT_CHAR:
          if(t1.ind_level > 0){
            type.basic_type = DT_INT;
            type.ind_level  = t1.ind_level;
            type.signedness = t1.signedness; // assign whatever the int's signednss is
          }
          else if(t2.ind_level > 0){
            type.basic_type = DT_CHAR;
            type.ind_level  = t2.ind_level;
            type.signedness = t2.signedness; // assign whatever the char* signedness is
          }
          else{
            type.basic_type = DT_INT;
            type.ind_level  = 0;
            type.signedness = t1.signedness; // assign whatever the int's signedness is
          }
          break;
        case DT_INT:
          if(t1.ind_level > 0){
            type.basic_type = DT_INT;
            type.ind_level  = t1.ind_level;
            type.signedness = t1.signedness;
          }
          else if(t2.ind_level > 0){
            type.basic_type = DT_INT;
            type.ind_level  = t2.ind_level;
            type.signedness = t2.signedness;
          }
          else{
            type.basic_type = DT_INT;
            type.ind_level  = 0;
            if(t1.signedness == SNESS_UNSIGNED || t2.signedness == SNESS_UNSIGNED)
              type.signedness = SNESS_UNSIGNED;
            else
              type.signedness = SNESS_SIGNED;
          }
      }
  }
  return type;
}

unsigned int add_string_data(char *str){
  int i;

  // Check if string already exists
  for(i = 0; i < STRING_TABLE_SIZE; i++)
    if(!strcmp(string_table[i], str))
      return i;

  // Declare new string
  for(i = 0; i < STRING_TABLE_SIZE; i++)
    if(!string_table[i][0]){
      strcpy(string_table[i], str);
      return i;
    }

  error("Maximum number of string literals reached.");
}

void emit_string_table_data(void){
  int i;
  char temp[256];

  for(i = 0; string_table[i][0]; i++){
    // emit the declaration of this string, into the data block
    emit_data("_s%d", i);
    emit_data(": .db \"");
    emit_data(string_table[i]);
    emit_data("\", 0\n");
    }
}

int search_string(char *str){
  int i;

  for(i = 0; i < STRING_TABLE_SIZE; i++) if(!strcmp(string_table[i], str)) 
    return i;

  return -1;
}

char *get_var_base_addr(char *dest, char *var_name){
  int var_id;

  if(local_var_exists(var_name) != -1){ // is a local variable
    var_id = local_var_exists(var_name);
    sprintf(dest, "bp + %d", function_table[current_func_id].local_vars[var_id].bp_offset);
  }
  else if(global_var_exists(var_name) != -1)  // is a global variable
    strcpy(dest, var_name);
  else 
    error("Undeclared identifier: %s", var_name);

  return dest;
}

t_type emit_var_addr_into_d(char *var_name){
  int var_id, dims;
  char temp[64], element_name[ID_LEN], temp_name[ID_LEN];
  t_type type;
  t_var var;

  if((var_id = local_var_exists(var_name)) != -1){ // is a local variable
    type = function_table[current_func_id].local_vars[var_id].type;
    if(function_table[current_func_id].local_vars[var_id].is_static){
      if(is_array(function_table[current_func_id].local_vars[var_id].type) || (function_table[current_func_id].local_vars[var_id].type.basic_type == DT_STRUCT && function_table[current_func_id].local_vars[var_id].type.ind_level == 0))
        emitln("  mov d, _static_%s_%s_data ; static %s", function_table[current_func_id].name, function_table[current_func_id].local_vars[var_id].name, function_table[current_func_id].local_vars[var_id].name);
      else
        emitln("  mov d, _static_%s_%s ; static %s", function_table[current_func_id].name, function_table[current_func_id].local_vars[var_id].name, function_table[current_func_id].local_vars[var_id].name);
    }
    else{
      get_var_base_addr(temp, var_name);
      // both array and parameter means this is a parameter local variable to a function
      // that is really a pointer variable and not really a array.
      if(is_array(function_table[current_func_id].local_vars[var_id].type) && function_table[current_func_id].local_vars[var_id].is_parameter){
        emitln("  mov b, [%s] ; $%s", temp, var_name);
        emitln("  mov d, b");
      }
      else 
        emitln("  lea d, [%s] ; $%s", temp, var_name);
    }
  }
  else if((var_id = global_var_exists(var_name)) != -1){  // is a global variable
    type = global_var_table[var_id].type;
    if(is_array(global_var_table[var_id].type) || (global_var_table[var_id].type.basic_type == DT_STRUCT && global_var_table[var_id].type.ind_level == 0)) 
      emitln("  mov d, _%s_data ; $%s", global_var_table[var_id].name, global_var_table[var_id].name);
    else
      emitln("  mov d, _%s ; $%s", global_var_table[var_id].name, global_var_table[var_id].name);
  }
  else error("Undeclared identifier: %s", var_name);

  var = get_internal_var_ptr(var_name);
  get();
  // emit base address for variable, whether struct or not
  // then look for '.' or '[]' in each cycle, if found, add offsets
  if(tok == OPENING_BRACKET || tok == STRUCT_DOT || tok == STRUCT_ARROW){ // array operations
    if(tok == OPENING_BRACKET && !is_array(type) && type.ind_level > 0 /*&& var.is_parameter*/){
      emitln("  mov d, [d]");
    }
    do{
      if(tok == OPENING_BRACKET){
        if(is_array(type)){
          dims = array_dim_count(type); // gets the number of dimensions for this type
          type = emit_array_arithmetic(type); // emit type final address in 'd'
        }
        // pointer indexing
        else if(type.ind_level > 0){
          emitln("  push a");
          emitln("  push d"); // save 'd' in case the expressions inside brackets use 'd' for addressing (likely)
          parse_expr(); // parse index expression, result in B
          emitln("  pop d");
          if(tok != CLOSING_BRACKET) error("Closing brackets expected");
          emitln("  mma %u ; mov a, %u; mul a b; add d, b", get_data_size_for_indexing(type), get_data_size_for_indexing(type)); // mov a, u16; mul a b; add d, b
          emitln("  pop a");
          type.ind_level--; // indexing reduces ind_level by 1
        }
        else error("Invalid indexing");
      }
      else if(tok == STRUCT_DOT){
        int offset; int var_id; int struct_id;
        get(); // get element name
        strcpy(element_name, token);
        offset = get_struct_element_offset(type.struct_id, element_name);
        type = get_struct_element_type(type.struct_id, element_name);
        emitln("  add d, %d", offset);
        emitln("  clb"); // clear b
      }
      else if(tok == STRUCT_ARROW){
        int offset; int var_id; int struct_id;
        get(); // get element name
        strcpy(element_name, token);
        offset = get_struct_element_offset(type.struct_id, element_name);
        type = get_struct_element_type(type.struct_id, element_name);
        get_var_base_addr(temp, var_name);
        emitln("  mov d, [d]");
        emitln("  add d, %d", offset);
        emitln("  clb"); // clear b
      }
      get();
    } while (tok == OPENING_BRACKET || tok == STRUCT_DOT || tok == STRUCT_ARROW);
    back();
  }
  else back();
  return type;
}

int get_num_array_elements(t_type type){
  int i;
  int size = 1;
  for(i = 0; type.dims[i]; i++){
    size *= type.dims[i];
  }
  return size;
}

int get_array_offset(char dim, t_type type){
  int i, offset = 1;
  
  if(dim < array_dim_count(type) - 1){
    for(i = dim + 1; i < array_dim_count(type); i++)
      offset = offset * type.dims[i];
    return offset * get_basic_type_size(type);
  }
  else
    return 1 * get_basic_type_size(type);
}

int is_struct(t_type type){
  return type.basic_type == DT_STRUCT;
}

int is_array(t_type type){
  return type.dims[0] ? 1 : 0;
}

int array_dim_count(t_type type){
  int i;
  
  for(i = 0; type.dims[i]; i++);
  return i;
}

int get_total_type_size(t_type type){
  int i;
  int size = 1;

  // if it is a array, return its number of dimensions * type size
  for(i = 0; i < array_dim_count(type); i++)
    size = size * type.dims[i];
  
  // if it is not a array, it will return 1 * the data size
  return size * get_basic_type_size(type);
}

int get_basic_type_size(t_type type){
  if(type.ind_level > 0) 
    return 2;
  else switch(type.basic_type){
    case DT_CHAR:
      return 1;
    case DT_INT:
      return 2;
    case DT_STRUCT:
      return get_struct_size(type.struct_id);
  }
}
int get_type_size_for_func_arg_parsing(t_type type){
  if(type.ind_level > 0) 
    return 2;
  else if(is_array(type)){
    return 2;
  }
  else switch(type.basic_type){
    case DT_CHAR:
      return 1;
    case DT_INT:
      return 2;
    case DT_STRUCT:
      return get_struct_size(type.struct_id);
  }
}

int get_struct_size(int id){
  int i, j;
  int size = 0;
  int array_size;
  
  for(i = 0; *struct_table[id].elements[i].name; i++){
    array_size = 1;
    for(j = 0; struct_table[id].elements[i].type.dims[j]; j++)
      array_size *= struct_table[id].elements[i].type.dims[j];
    if(struct_table[id].elements[i].type.ind_level > 0) size += array_size * 2;
    else switch(struct_table[id].elements[i].type.basic_type){
      case DT_CHAR:
        size += array_size * 1;
        break;
      case DT_INT:
        size += array_size * 2;
        break;
      case DT_STRUCT:
        size += array_size * get_struct_size(struct_table[id].elements[i].type.struct_id);
    }
  }

  return size;
}

int get_data_size_for_indexing(t_type type){
  if(type.ind_level >= 2) 
    return 2;
  else switch(type.basic_type){
    case DT_CHAR:
      return 1;
    case DT_INT:
      return 2;
    case DT_STRUCT:
      return get_struct_size(type.struct_id);
  }
}

int has_var_args(int func_id){
  return function_table[func_id].local_vars[1].is_var_args &&
         function_table[func_id].local_vars[1].is_parameter;
}


int search_global_var(char *var_name){
  register int i;
  
  for(i = 0; i < global_var_tos; i++)
    if(!strcmp(global_var_table[i].name, var_name)) return i;
  
  return -1;
}
/*
struct t_shell_var{
  char varname[16];
  char var_type;
  char *as_string;
  int as_int;
} variables[MAX_SHELL_VARIABLES];
int vars_tos;
*/
int declare_struct(){
  int element_tos;
  int curr_struct_id;
  int struct_id;
  t_struct new_struct;
  char *temp_prog;
  int struct_is_embedded = 0;

  if(struct_table_tos == MAX_STRUCT_DECLARATIONS) error("Max number of struct declarations reached");
  
  get(); // 'struct'
  get(); // try getting struct name
  if(toktype == IDENTIFIER){
    strcpy(new_struct.name, token);
    get(); // '{'
    if(tok != OPENING_BRACE) error("Opening braces expected");
    // Add the new struct to the struct table prematurely so that any elements in this struct that are pointers of this struct type can be recognized by a search
    strcpy(struct_table[struct_table_tos].name, token);
    curr_struct_id = struct_table_tos;
    struct_table_tos++;
  }
  else if(tok == OPENING_BRACE){ // implicit struct declaration inside a struct itself
    struct_is_embedded = 1;
  // assign a null string to the struct name then
    *new_struct.name = '\0'; // okay to do since we dont use struct names as the end point of search loops. we use 'struct_table_tos'
    curr_struct_id = struct_table_tos;
    struct_table_tos++;
  }

  element_tos = 0;
  do{
    if(element_tos == MAX_STRUCT_ELEMENTS) error("Max number of struct elements reached");
    get();
    new_struct.elements[element_tos].type.signedness = SNESS_SIGNED; // set as signed by default
    new_struct.elements[element_tos].type.longness = LNESS_NORMAL; // set as signed by default
    while(tok == SIGNED || tok == UNSIGNED || tok == LONG){
           if(tok == SIGNED)   new_struct.elements[element_tos].type.signedness = SNESS_SIGNED;
      else if(tok == UNSIGNED) new_struct.elements[element_tos].type.signedness = SNESS_UNSIGNED;
      else if(tok == LONG)     new_struct.elements[element_tos].type.longness   = LNESS_LONG;
      get();
    }
    new_struct.elements[element_tos].type.basic_type = get_basic_type_from_tok();
    new_struct.elements[element_tos].type.struct_id = -1;
    if(new_struct.elements[element_tos].type.basic_type == DT_STRUCT){
      get();
      if(tok == OPENING_BRACE){ // internal struct declaration!
        back();
        struct_id = declare_struct();
        get(); // get element name
      }
      else{
        if((struct_id = search_struct(token)) == -1) error("Undeclared struct");
        get();
      }
      new_struct.elements[element_tos].type.struct_id = struct_id;
    }
    else get();
// **************** checks whether this is a pointer declaration *******************************
    new_struct.elements[element_tos].type.ind_level = 0;
    while(tok == STAR){
      new_struct.elements[element_tos].type.ind_level++;
      get();
    }
// *********************************************************************************************
    if(new_struct.elements[element_tos].type.basic_type == DT_VOID && new_struct.elements[element_tos].type.ind_level == 0) error("Invalid type in variable");

    strcpy(new_struct.elements[element_tos].name, token);
    new_struct.elements[element_tos].type.dims[0] = 0;
    get();
    // checks if this is a array declaration
    int dim = 0;
    if(tok == OPENING_BRACKET){
      while(tok == OPENING_BRACKET){
        get();
        if(toktype != INTEGER_CONST) error("Constant expected");
        new_struct.elements[element_tos].type.dims[dim] = atoi(token);
        get();
        if(tok != CLOSING_BRACKET) error("Closing brackets expected");
        get();
        dim++;
      }
      new_struct.elements[element_tos].type.dims[dim] = 0; // sets the last dimention to 0, to mark the end of the list
    }
    element_tos++;
    get();
    if(tok != CLOSING_BRACE) back();
  } while(tok != CLOSING_BRACE);
  
  new_struct.elements[element_tos].name[0] = '\0'; // end elements list
  struct_table[curr_struct_id] = new_struct; 

  get();

  if(toktype == IDENTIFIER && struct_is_embedded){
    back();
  }
  else if (toktype == IDENTIFIER){ // declare variables if present
    back();
    declare_struct_global_vars(curr_struct_id);
  }

  return curr_struct_id; // return struct_id
}

// declare struct variables right after struct declaration
void declare_struct_global_vars(int struct_id){
  t_type type;
  int ind_level;
  char is_constant = false;
  char temp[512 + 8];
  char *temp_prog;

  do{
    if(global_var_tos == MAX_GLOBAL_VARS) error("Global variable declaration limit exceeded");
    global_var_table[global_var_tos].type.is_constant = is_constant;
    get();
// **************** checks whether this is a pointer declaration *******************************
    ind_level = 0;
    while(tok == STAR){
      ind_level++;
      get();
    }
// *********************************************************************************************
    if(toktype != IDENTIFIER) error("Identifier expected");

    // checks if there is another global variable with the same name
    if(search_global_var(token) != -1) error("Duplicate global variable");
    
    global_var_table[global_var_tos].type.basic_type = DT_STRUCT;
    global_var_table[global_var_tos].type.ind_level = ind_level;
    global_var_table[global_var_tos].type.struct_id = struct_id;
    global_var_table[global_var_tos].type.dims[0] = 0;
    strcpy(global_var_table[global_var_tos].name, token);
    get();
    // checks if this is a array declaration
    int dim = 0;
    if(tok == OPENING_BRACKET){
      while(tok == OPENING_BRACKET){
        get();
        if(tok == CLOSING_BRACKET){ // variable length array
          int fixed_part_size = 1, initialization_size;
          temp_prog = prog;
          get();
          if(tok == OPENING_BRACKET){
            do{
              get();
              fixed_part_size = fixed_part_size * int_const;
              get();
              expect(CLOSING_BRACKET, "Closing brackets expected");
              get();
            } while(tok == OPENING_BRACKET);
          }
          back();
          initialization_size = find_array_initialization_size();
          global_var_table[global_var_tos].type.dims[dim] = (int)ceil((float)initialization_size / (float)fixed_part_size);
          get();
          if(tok != SEMICOLON) error("Semicolon expected.");
          break;
        }
        else{
          global_var_table[global_var_tos].type.dims[dim] = atoi(token);
          get();
          if(tok != CLOSING_BRACKET) error("Closing brackets expected");
        }
        get();
        dim++;
      }
      global_var_table[global_var_tos].type.dims[dim] = 0; // sets the last variable dimention to 0, to mark the end of the list

    }

    if(tok == ASSIGNMENT){
      int array_size = 1;
      array_size = get_num_array_elements(global_var_table[global_var_tos].type);
      get();
      expect(OPENING_BRACE, "Opening braces expected in struct initialization.");
      emit_data("_%s_data:\n", global_var_table[global_var_tos].name);
      parse_struct_initialization_data(struct_id, array_size);
      get();
    }
    else{
      if(dim > 0 || global_var_table[global_var_tos].type.basic_type == DT_STRUCT && global_var_table[global_var_tos].type.ind_level == 0){
        emit_data("_%s_data: .fill %u, 0\n", global_var_table[global_var_tos].name, get_total_type_size(global_var_table[global_var_tos].type));
      }
      else
        emit_data("_%s: .fill %u, 0\n", global_var_table[global_var_tos].name, get_total_type_size(global_var_table[global_var_tos].type));
    }

    global_var_tos++;  

    get();
  } while(tok == COMMA);
  back();
}

void parse_struct_initialization_data(int struct_id, int array_size){
  int i, j, k, q;
  int element_array_size, total_elements;

  total_elements = get_struct_elements_count(struct_id);
  
  for(j = 0; j < array_size; j++){
    for(i = 0; *struct_table[struct_id].elements[i].name; i++){
      // Array but not struct
      if(is_array(struct_table[struct_id].elements[i].type)){
        get(); expect(OPENING_BRACE, "Opening braces expected for array or struct element initialization.");
        element_array_size = get_num_array_elements(struct_table[struct_id].elements[i].type);
      }
      else{
        element_array_size = 1;
      }
      // Read array elements
      for(k = 0; k < element_array_size; k++){
        get();
        if(toktype == IDENTIFIER && enum_element_exists(token) != -1){ // obtain enum values if token is an enum element
          int_const = get_enum_val(token);
          toktype = INTEGER_CONST;
        }
        switch(struct_table[struct_id].elements[i].type.basic_type){
          case DT_STRUCT:
            expect(OPENING_BRACE, "Opening braces expected for array or struct element initialization.");
            parse_struct_initialization_data(struct_table[struct_id].elements[i].type.struct_id, 1);
            break;
          case DT_VOID:
            emit_data(".dw $%04x\n", int_const);
            break;
          case DT_CHAR:
            if(struct_table[struct_id].elements[i].type.ind_level > 0){
              switch(toktype){
                case CHAR_CONST:
                  emit_data(".dw %s\n", token);
                  break;
                case INTEGER_CONST:
                  emit_data(".dw $%04x\n", int_const);
                  break;
                case STRING_CONST:
                  int string_id = add_string_data(string_const);
                  emit_data(".dw _s%u\n", string_id);
              }
            }
            else{
              switch(toktype){
                case CHAR_CONST:
                  emit_data(".db %s\n", token);
                  break;
                case INTEGER_CONST:
                  emit_data(".db %d\n", (char)int_const);
                  break;
                case STRING_CONST:
                  error("Incompatible data type for struct element in initialization.");
              }
            }
            break;
          case DT_INT:
            switch(toktype){
              case CHAR_CONST:
                emit_data(".dw %s\n", token);
                break;
              case INTEGER_CONST:
                emit_data(".dw %d\n", int_const);
                break;
              case STRING_CONST:
                int string_id = add_string_data(string_const);
                emit_data(".dw _s%u\n", string_id);
                break;
            }
            break;
        }
        if(is_array(struct_table[struct_id].elements[i].type)){
          get();
          if(tok == CLOSING_BRACE) break;
          else if(tok != COMMA) error("Comma expected in struct initialization.");
        }
      }
      get();
      if(tok == CLOSING_BRACE) break;
      else if(tok != COMMA) error("Comma expected in struct initialization.");
    }
    if(tok == CLOSING_BRACE) break;
  }
}

int get_struct_elements_count(int struct_id){
  int total;
  for(total = 0; *struct_table[struct_id].elements[total].name; total++);
  return total;
}

void declare_typedef(void){
  if(typedef_table_tos == MAX_TYPEDEFS) error("Maximum number of typedefs exceeded.");

  get(); 
  
  

  if(tok != SEMICOLON) error("Semicolon expected");
}

// enum my_enum {item1, item2, item3};
void declare_enum(void){
  int element_tos;
  int value;

  if(enum_table_tos == MAX_ENUM_DECLARATIONS) error("Maximum number of enumeration declarations exceeded");

  get(); // get enum name
  strcpy(enum_table[enum_table_tos].name, token);
  get(); // '{'
  if(tok != OPENING_BRACE) error("Opening braces expected");
  element_tos = 0;
  value = 0;

  do{
    get();
    if(toktype != IDENTIFIER) error("Identifier expected");
    strcpy(enum_table[enum_table_tos].elements[element_tos].name, token);
    enum_table[enum_table_tos].elements[element_tos].value = value;
    value++;
    element_tos++;  
    get();
  } while(tok == COMMA);
  
  enum_table_tos++;

  if(tok != CLOSING_BRACE) error("Closing braces expected");
  get();
  if(tok != SEMICOLON) error("Semicolon expected");
}

int enum_element_exists(char *name){
  int i, j;
  
  for(i = 0; i < enum_table_tos; i++)
    for(j = 0; *enum_table[i].elements[j].name; j++)
      if(!strcmp(enum_table[i].elements[j].name, name))
        return 1;
  return -1;
}

int get_enum_val(char *name){
  int i, j;
  
  for(i = 0; i < enum_table_tos; i++)
    for(j = 0; *enum_table[i].elements[j].name; j++)
      if(!strcmp(enum_table[i].elements[j].name, name))
        return enum_table[i].elements[j].value;

  return -1;
}

int find_array_initialization_size(void){
  char *temp_prog = prog; // save starting prog position
  int len = 0;
  int braces;
  get();
  expect(ASSIGNMENT, "Assignment expected");
  get();
  expect(OPENING_BRACE, "Opening braces expected");
  braces = 1;
  do{
    get();
    if(tok == OPENING_BRACE) braces++;
    else if(tok == CLOSING_BRACE) braces--;
    else if(tok == COMMA) continue;
    else{
      switch(toktype){
        case CHAR_CONST:
          len += 1;
          break;
        case INTEGER_CONST:
          len += 2;
          break;
        case STRING_CONST:
          len += 2;
          break;
        default:
          len += 1;
      }
    }
  } while(braces);
  expect(CLOSING_BRACE, "Closing braces expected");
  return len;
}

int search_struct(char *name){
  int i;
  
  for(i = 0; i < struct_table_tos; i++)
    if(!strcmp(struct_table[i].name, name)) return i;
  return -1;
}

void declare_global(void){
  char temp[512 + 8];
  char *temp_prog;
  int struct_id;
  t_type type;

  get(); 
  type.signedness = SNESS_SIGNED; // set as signed by default
  type.longness = LNESS_NORMAL; 
  type.is_constant = false; 
  while(tok == SIGNED || tok == UNSIGNED || tok == LONG || tok == CONST){
    if(tok == CONST) type.is_constant = true;
    else if(tok == SIGNED) type.signedness = SNESS_SIGNED;
    else if(tok == UNSIGNED) type.signedness = SNESS_UNSIGNED;
    else if(tok == LONG) type.longness = LNESS_LONG;
    get();
  }
  type.basic_type = get_basic_type_from_tok();
  type.struct_id = -1;
  if(type.basic_type == DT_STRUCT){ // check if this is a struct
    get();
    struct_id = search_struct(token);
    if(struct_id == -1) error("Undeclared struct: %s", token);
  }

  do{
    if(global_var_tos == MAX_GLOBAL_VARS) error("Max number of global variable declarations exceeded");
    global_var_table[global_var_tos].type = type;
    get();
// **************** checks whether this is a pointer declaration *******************************
    global_var_table[global_var_tos].type.ind_level = 0;
    while(tok == STAR){
      global_var_table[global_var_tos].type.ind_level++;
      get();
    }
// *********************************************************************************************
    if(toktype != IDENTIFIER) error("Identifier expected");
    if(global_var_table[global_var_tos].type.basic_type == DT_VOID && global_var_table[global_var_tos].type.ind_level == 0) error("Invalid type in variable: %s", token);

    // checks if there is another global variable with the same name
    if(search_global_var(token) != -1) error("Duplicate global variable: %s", token);
    
    global_var_table[global_var_tos].type.struct_id = struct_id;
    global_var_table[global_var_tos].type.dims[0] = 0;
    strcpy(global_var_table[global_var_tos].name, token);
    get();
    // checks if this is a array declaration
    int dim = 0;
    if(tok == OPENING_BRACKET){
      while(tok == OPENING_BRACKET){
        get();
        if(tok == CLOSING_BRACKET){ // variable length array
          int fixed_part_size = 1;
          int initialization_size;
          temp_prog = prog;
          get();
          if(tok == OPENING_BRACKET){
            do{
              get();
              fixed_part_size = fixed_part_size * int_const;
              get();
              expect(CLOSING_BRACKET, "Closing brackets expected");
              get();
            } while(tok == OPENING_BRACKET);
          }
          back();
          initialization_size = find_array_initialization_size();
          global_var_table[global_var_tos].type.dims[dim] = (int)ceil((float)initialization_size / (float)fixed_part_size);
          prog = temp_prog;
        }
        else{
          global_var_table[global_var_tos].type.dims[dim] = atoi(token);
          get();
          if(tok != CLOSING_BRACKET) error("Closing brackets expected");
        }
        get();
        dim++;
      }
      global_var_table[global_var_tos].type.dims[dim] = 0; // sets the last variable dimention to 0, to mark the end of the list
    }

    // _data section for var is emmitted if:
    // ind_level == 1 && data.basic_type_char
    // var is a array (dims > 0)
    // checks for variable initialization
    if(tok == ASSIGNMENT)
      emit_global_var_initialization(&global_var_table[global_var_tos]);
    else{ // no assignment!
      if(dim > 0 || (global_var_table[global_var_tos].type.basic_type == DT_STRUCT && global_var_table[global_var_tos].type.ind_level == 0)){
        emit_data("_%s_data: .fill %u, 0\n", global_var_table[global_var_tos].name, get_total_type_size(global_var_table[global_var_tos].type));
        //emit_data("_%s: .dw _%s_data\n", global_var_table[global_var_tos].name, global_var_table[global_var_tos].name);
      }
      else
        emit_data("_%s: .fill %u, 0\n", global_var_table[global_var_tos].name, get_total_type_size(global_var_table[global_var_tos].type));
    }
    global_var_tos++;  
  } while(tok == COMMA);

  if(tok != SEMICOLON) error("Semicolon expected");
}

void emit_global_var_initialization(t_var *var){
  char temp[512 + 8];
  int j, braces;

  if(is_array(var->type)){
    get();
    expect(OPENING_BRACE, "Opening braces expected");
    emit_data("_%s_data: \n", var->name);
    emit_data_dbdw(var->type);
    j = 0;
    braces = 1;
    for(;;){
      get();
           if(tok == OPENING_BRACE) braces++;
      else if(tok == CLOSING_BRACE) braces--;
      else if(toktype == CHAR_CONST)
        emit_data("$%x,", string_const[0]);
      else if(toktype == INTEGER_CONST)
        emit_data("%u,", (uint16_t)atoi(token));
      else if(toktype == STRING_CONST){
        int string_id;
        string_id = add_string_data(string_const);
        emit_data("_s%u, ", string_id);
      }
      else error("Unknown data type");
      if(toktype == CHAR_CONST || toktype == INTEGER_CONST || toktype == STRING_CONST) j++;
      if(braces == 0) break;
      get();
      if(tok != COMMA) back();
      if(j % 30 == 0){ // split into multiple lines due to TASM limitation of how many items per .dw directive
        emit_data("\n");
        emit_data_dbdw(var->type);
      }
    }
    expect(CLOSING_BRACE, "Closing braces expected");
    // fill in the remaining unitialized array values with 0's 
    emit_data("\n");
    if(get_total_type_size(var->type) - j * get_basic_type_size(var->type) > 0){
      emit_data(".fill %u, 0\n", get_total_type_size(var->type) - j * get_basic_type_size(var->type));
    }
  }
  else{
    get();
    switch(var->type.basic_type){
      case DT_VOID:
        emit_data("_%s: ", var->name);
        emit_data_dbdw(var->type);
        emit_data("%u, ", atoi(token));
        break;
      case DT_CHAR:
        if(var->type.ind_level > 0){ // if is a string
          if(toktype == IDENTIFIER){
            get_var_base_addr(temp, token);
            emit_data("_%s: .dw _%s_data\n", var->name, temp);
          }
          else{
            if(toktype != STRING_CONST) error("String constant expected");
            emit_data("_%s_data: ", var->name);
            emit_data_dbdw(var->type);
            emit_data("%s, 0\n", token);
            emit_data("_%s: .dw _%s_data\n", var->name, var->name);
          }
        }
        else{
          emit_data("_%s: ", var->name);
          emit_data_dbdw(var->type);
          if(toktype == CHAR_CONST)
            emit_data("$%x\n", string_const[0]);
          else if(toktype == INTEGER_CONST)
            emit_data("%u\n", (char)atoi(token));
        }
        break;
      case DT_INT:
        emit_data("_%s: ", var->name);
        emit_data_dbdw(var->type);
        if(var->type.ind_level > 0)
            emit_data("%u\n", atoi(token));
        else
          emit_data("%u\n", atoi(token));
        break;
      case DT_STRUCT:
        if(toktype == IDENTIFIER){
          get_var_base_addr(temp, token);
          emit_data("_%s: .dw _%s_data\n", var->name, temp);
        }

    }
  }
  get();
}

void emit_static_var_initialization(t_var *var){
  char temp[1024];
  int j;

  if(is_array(var->type)){
    get();
    expect(OPENING_BRACE, "Opening braces expected");
    emit_data("_static_%s_%s_data: \n", function_table[current_func_id].name, var->name);
    emit_data_dbdw(var->type);
    j = 0;
    do{
      get();
      if(toktype == CHAR_CONST)
        emit_data("$%x,", string_const[0]);
      else if(toktype == INTEGER_CONST)
        emit_data("%u,", (char)atoi(token));
      else if(toktype == STRING_CONST){
        int string_id;
        string_id = add_string_data(string_const);
        emit_data("_s%u, ", string_id);
      }
      else 
        error("Unknown data type");
      if(toktype == CHAR_CONST || toktype == INTEGER_CONST || toktype == STRING_CONST) j++;
      get();
      if(j % 30 == 0){ // split into multiple lines due to TASM limitation of how many items per .dw directive
        emit_data("\n");
        emit_data_dbdw(var->type);
      }
    } while(tok == COMMA);
    // fill in the remaining unitialized array values with 0's 
    if(get_total_type_size(var->type) - j * get_basic_type_size(var->type) > 0){
      emit_data(".fill %u, 0\n", get_total_type_size(var->type) - j * get_basic_type_size(var->type));
    }
    emit_data("_static_%s: .dw _static_%s_%s_data\n", function_table[current_func_id].name, var->name, var->name);
    expect(CLOSING_BRACE, "Closing braces expected");
  }
  else{
    get();
    switch(var->type.basic_type){
      case DT_VOID:
        emit_data("_static_%s_%s: ", function_table[current_func_id].name, var->name);
        emit_data_dbdw(var->type);
        emit_data("%u, ", atoi(token));
        break;
      case DT_CHAR:
        if(var->type.ind_level > 0){ // if is a string
          if(toktype != STRING_CONST) error("String constant expected");
          emit_data("_static_%s_%s_data: ", function_table[current_func_id].name, var->name);
          emit_data_dbdw(var->type);
          emit_data("%s, 0\n", token); // TODO: do not require char pointer initialization to be a string only!
          emit_data("_static_%s_%s: .dw _static_%s_%s_data\n", function_table[current_func_id].name, var->name, function_table[current_func_id].name, var->name);
        }
        else{
          emit_data("_static_%s_%s: ", function_table[current_func_id].name, var->name);
          emit_data_dbdw(var->type);
          if(toktype == CHAR_CONST)
            emit_data("$%x\n", string_const[0]);
          else if(toktype == INTEGER_CONST)
            emit_data("%u\n", (char)atoi(token));
        }
        break;
      case DT_INT:
        emit_data("_static_%s_%s: ", function_table[current_func_id].name, var->name);
        emit_data_dbdw(var->type);
        if(var->type.ind_level > 0)
            emit_data("%u\n", atoi(token));
        else
          emit_data("%u\n", atoi(token));
        break;
    }
  }
  get();
}

void emit_data_dbdw(t_type type){
  if((type.ind_level >  0 && type.basic_type == DT_CHAR && type.dims[0] == 0)
  || (type.ind_level == 0 && type.basic_type == DT_CHAR)
  ) 
    emit_data(".db ");
  else
    emit_data(".dw ");
}

int search_function_parameter(int function_id, char *param_name){
  int i;
  for(i = 0; i < function_table[function_id].local_var_tos; i++){
    if(!strcmp(function_table[function_id].local_vars[i].name, param_name)){
      return i;
    }
  }
  return -1;
}

int search_function(char *name){
  register int i;
  
  for(i = 0; *function_table[i].name; i++)
    if(!strcmp(function_table[i].name, name))
      return i;
  
  return -1;
}

int global_var_exists(char *var_name){
  register int i;

  for(i = 0; i < global_var_tos; i++)
    if(!strcmp(global_var_table[i].name, var_name)) return i;
  
  return -1;
}

int local_var_exists(char *var_name){
  register int i;

  //check local variables whose function id is the id of current function being parsed
  for(i = 0; i < function_table[current_func_id].local_var_tos; i++)
    if(!strcmp(function_table[current_func_id].local_vars[i].name, var_name)) return i;
  
  return -1;
}

t_basic_type get_basic_type_from_tok(){
  switch(tok){
    case VOID:
      return DT_VOID;
    case CHAR:
      return DT_CHAR;
    case INT:
      return DT_INT;
    case FLOAT:
      return DT_FLOAT;
    case DOUBLE:
      return DT_DOUBLE;
    case STRUCT:
      return DT_STRUCT;
    default:
      error("Unknown data type.");
  }
}

int declare_local(void){                        
  t_var new_var;
  char *temp_prog;
  int struct_id;
  char temp[1024];
  int total_sp = 0;
  
  get();
  new_var.type.is_constant = false;
  new_var.is_static = false;
  new_var.type.signedness = SNESS_SIGNED; // set as signed by default
  new_var.type.longness = LNESS_NORMAL;
  while(tok == SIGNED || tok == UNSIGNED || tok == LONG || tok == STATIC || tok == CONST){
    if(tok == CONST) new_var.type.is_constant = true;
    else if(tok == SIGNED) new_var.type.signedness = SNESS_SIGNED;
    else if(tok == UNSIGNED) new_var.type.signedness = SNESS_UNSIGNED;
    else if(tok == LONG) new_var.type.longness = LNESS_LONG;
    else if(tok == STATIC) new_var.is_static = true;
    get();
  }
  new_var.type.basic_type = get_basic_type_from_tok();
  new_var.type.struct_id = -1;
  if(new_var.type.basic_type == DT_STRUCT){ // check if this is a struct
    get();
    struct_id = search_struct(token);
    if(struct_id == -1) error("Undeclared struct: %s", token);
  }

  do{
    if(function_table[current_func_id].local_var_tos == MAX_LOCAL_VARS) error("Local var declaration limit reached");
    new_var.is_parameter = false;
    new_var.function_id = current_func_id; // set variable owner function
    new_var.type.struct_id = struct_id;
// **************** checks whether this is a pointer declaration *******************************
    new_var.type.ind_level = 0;
    get();
    while(tok == STAR){
      new_var.type.ind_level++;
      get();
    }    
// *********************************************************************************************
    if(toktype != IDENTIFIER) error("Identifier expected");
    if(local_var_exists(token) != -1) error("Duplicate local variable: %s", token);
    sprintf(new_var.name, "%s", token);
    get();

    // checks if this is a array declaration
    int dim = 0;
    new_var.type.dims[0] = 0; // in case its not a array, this signals that fact
    if(tok == OPENING_BRACKET){
      while(tok == OPENING_BRACKET){
        get();
        if(tok == CLOSING_BRACKET){ // variable length array
          int fixed_part_size = 1, initialization_size;
          temp_prog = prog;
          get();
          if(tok == OPENING_BRACKET){
            do{
              get();
              fixed_part_size = fixed_part_size * int_const;
              get();
              expect(CLOSING_BRACKET, "Closing brackets expected");
              get();
            } while(tok == OPENING_BRACKET);
          }
          back();
          initialization_size = find_array_initialization_size();
          new_var.type.dims[dim] = (int)ceil((float)initialization_size / (float)fixed_part_size);
          prog = temp_prog;
        }
        else{
          new_var.type.dims[dim] = atoi(token);
          get();
          if(tok != CLOSING_BRACKET) error("Closing brackets expected");
        }
        get();
        dim++;
      }
      new_var.type.dims[dim] = 0; // sets the last variable dimention to 0, to mark the end of the list
    }

    if(new_var.is_static){
      if(tok == ASSIGNMENT)
        emit_static_var_initialization(&new_var);
      else{
        if(new_var.type.dims[0] > 0 || new_var.type.basic_type == DT_STRUCT){
          emit_data("_static_%s_%s_data: .fill %u, 0\n", function_table[current_func_id].name, new_var.name, get_total_type_size(new_var.type));
          //emit_data("_static_%s_%s_: .dw _static_%s_%s_data\n", function_table[current_func_id].name, new_var.name, function_table[current_func_id].name, new_var.name);
        }
        else
          emit_data("_static_%s_%s: .fill %u, 0\n", function_table[current_func_id].name, new_var.name, get_total_type_size(new_var.type));
      }
    }
    else{
      // this is used to position local variables correctly relative to BP.
      // whenever a new function is parsed, this is reset to 0.
      // then inside the function it can increase according to how many local vars there are.
      current_function_var_bp_offset -= get_total_type_size(new_var.type);
      new_var.bp_offset = current_function_var_bp_offset + 1;

      total_sp += get_total_type_size(new_var.type);
      emitln("; $%s ", new_var.name);
      //emitln("  sub sp, %d ; $%s", get_total_type_size(new_var.type), new_var.name);
      if(tok == ASSIGNMENT){
        char isneg = 0;
        if(new_var.type.dims[0] > 0){
          print_info("Warning: Skipping initialization of local variable '%s' (not yet implemented).", new_var.name);
          do{
            get();
          } while(tok != SEMICOLON);
        }
        else{
          get();
          if(tok == MINUS){
            isneg = 1;
            get();
          }
          if(toktype != CHAR_CONST && toktype != INTEGER_CONST) error("Local variable initialization is non constant");
          //emitln("  lea d, [sp + %d]", current_function_var_bp_offset + 1);
          if(new_var.type.basic_type == DT_CHAR){
            if(toktype == CHAR_CONST){
              emitln("  mov al, $%x", string_const[0]);
              emitln("  mov [bp + %d], al", new_var.bp_offset);
              //emitln("  mov [d], al");
            }
            else{
              emitln("  mov al, $%x", (unsigned char)(isneg ? -atoi(token) : atoi(token)));
              emitln("  mov [bp + %d], al", new_var.bp_offset);
              //emitln("  mov [d], al");
            }
          }
          else if(new_var.type.basic_type == DT_INT || new_var.type.ind_level > 0){
            if(toktype == CHAR_CONST){
              emitln("  mov a, $%x", string_const[0]);
              emitln("  mov [bp + %d], a", new_var.bp_offset);
              //emitln("  mov [d], a");
            }
            else{
              emitln("  mov a, $%x", (isneg ? -atoi(token) : atoi(token)));
              emitln("  mov [bp + %d], a", new_var.bp_offset);
              //emitln("  mov [d], a");
            }
          }
          get(); // get ';'
        }
      }
    }
    // assigns the new variable to the local stack
    function_table[current_func_id].local_vars[function_table[current_func_id].local_var_tos] = new_var;    
    function_table[current_func_id].local_var_tos++;
  } while(tok == COMMA);

  if(tok != SEMICOLON) error("Semicolon expected");

  return total_sp;
} // declare_local

t_var get_internal_var_ptr(char *var_name){
  register int i;

  //check local variables whose function id is the id of current function being parsed
  for(i = 0; i < function_table[current_func_id].local_var_tos; i++)
    if(!strcmp(function_table[current_func_id].local_vars[i].name, var_name))
      return function_table[current_func_id].local_vars[i];

  for(i = 0; (i < global_var_tos) && (*global_var_table[i].name); i++)
    if(!strcmp(global_var_table[i].name, var_name)) return global_var_table[i];
  
  error("Undeclared variable: %s", var_name);
}

void expect(t_token _tok, char *message){
  if(tok != _tok) error(message);
}

void print_info(const char* format, ...){
  char tempbuffer[1024];
  va_list args;
  va_start(args, format);
  vsnprintf(tempbuffer, sizeof(tempbuffer), format, args);
  va_end(args);

  puts(tempbuffer);
}

void error(const char* format, ...){
  int line = 1;
  char tempbuffer[1024];
  char error_token[256];
  va_list args;
  va_start(args, format);
  vsnprintf(tempbuffer, sizeof(tempbuffer), format, args);
  va_end(args);

  strcpy(error_token, token);

  prog = c_in;
  while(prog != prog_before_error){
    if(*prog == '\n') line++;
    prog++;
  }

  printf("\nError     : %s\n", tempbuffer);
  printf("At line %d : ", line - include_files_total_lines);
  while(*prog != '\n' && prog != c_in) prog--;
  prog++;
  while(*prog != '\n') putchar(*prog++);
  printf("\n");
  printf("Token     : %s\n", error_token);
  printf("Tok       : %s (%d)\n", token_to_str[tok].as_str, tok);
  printf("Toktype   : %s\n\n", toktype_to_str[toktype].as_str);

  errors_in_a_row++;
  exit(1);
  //if(errors_in_a_row == MAX_ERRORS) exit(0);
}

// converts a literal string or char constant into constants with true escape sequences
void convert_constant(){
  char *s = string_const;
  char *t = token;
  
  if(toktype == CHAR_CONST){
    t++;
    if(*t == '\\'){
      t++;
      switch(*t){
        case '0':
          *s++ = '\0';
          break;
        case 'a':
          *s++ = '\a';
          break;
        case 'b':
          *s++ = '\b';
          break;  
        case 'f':
          *s++ = '\f';
          break;
        case 'n':
          *s++ = '\n';
          break;
        case 'r':
          *s++ = '\r';
          break;
        case 't':
          *s++ = '\t';
          break;
        case 'v':
          *s++ = '\v';
          break;
        case '\\':
          *s++ = '\\';
          break;
        case '\'':
          *s++ = '\'';
          break;
        case '\"':
          *s++ = '\"';
      }
    }
    else{
      *s++ = *t;
    }
  }
  else if(toktype == STRING_CONST){
    t++;
    while(*t != '\"' && *t){
      if(*t == '\\' && *(t + 1) == '\"'){
        *s++ = '\\';
        *s++ = '\"';
        t += 2;
      }
      else{
        *s++ = *t++;
      }
    }
  }
  
  *s = '\0';
}

void get(void){
  char *t;
  // skip blank spaces

  *token = '\0';
  tok = 0;
  toktype = 0;
  t = token;
  
  // Save the position of prog before getting a token. If an 'unexpected token' error occurs,
  // the position of prog before lines were skipped, will be known.  
  prog_before_error = prog;

/* Skip comments and whitespaces */
  do{
    while(is_space(*prog)) prog++;
    if(*prog == '/' && *(prog+1) == '*'){
      prog = prog + 2;
      while(!(*prog == '*' && *(prog+1) == '/')) prog++;
      prog = prog + 2;
    }
    else if(*prog == '/' && *(prog+1) == '/'){
      while(*prog != '\n'){
        prog++;
      }
      if(*prog == '\n'){
        prog++;
      }
    }
  } while(is_space(*prog) || (*prog == '/' && *(prog+1) == '/') || (*prog == '/' && *(prog+1) == '*'));

  if(*prog == '\0'){
    toktype = END;
    return;
  }
  
  if(*prog == '\''){
    *t++ = '\'';
    prog++;
    if(*prog == '\\'){
      *t++ = '\\';
      prog++;
      *t++ = *prog++;
    }
    else{
      *t++ = *prog++;
    }
    if(*prog != '\''){
      error("Single quotes expected");
    }
    *t++ = '\'';
    prog++;
    toktype = CHAR_CONST;
    *t = '\0';
    convert_constant(); // converts this string token with quotation marks to a non quotation marks string, and also converts escape sequences to their real bytes
  }
  else if(*prog == '\"'){
    *t++ = *prog++;
    while(*prog != '\"' && *prog){
      if(*prog == '\\' && *(prog + 1) == '\"'){
        *t++ = '\\';
        *t++ = '\"';
        prog += 2;
      }
      else{
        *t++ = *prog++;
      }
    }
    if(*prog != '\"') error("Double quotes expected");
    *t++ = *prog++;
    *t = '\0';
    toktype = STRING_CONST;
    convert_constant(); // converts this string token qith quotation marks to a non quotation marks string, and also converts escape sequences to their real bytes
  }
  else if(is_digit(*prog)){
    char temp_hex[64];
    char *p = temp_hex;
    if(*prog == '0' && *(prog+1) == 'x'){
      *p++ = *prog++;
      *p++ = *prog++;
      while(is_hex_digit(*prog)) *p++ = *prog++;
      *p = '\0';
      strcpy(token, temp_hex);
      sscanf(temp_hex, "%x", &int_const);
    }
    else{
      while(is_digit(*prog)){
        *t++ = *prog++;
      }
      *t = '\0';
      sscanf(token, "%d", &int_const);
    }
    toktype = INTEGER_CONST;
    return; // return to avoid *t = '\0' line at the end of function
  }
  else if(is_identifier_char(*prog)){
    while(is_identifier_char(*prog) || is_digit(*prog)){
      *t++ = *prog++;
    }
    *t = '\0';
    if((tok = search_keyword(token)) != -1) 
      toktype = RESERVED;
    else 
      toktype = IDENTIFIER;
  }
  else if(is_delimiter(*prog)){
    toktype = DELIMITER;  
    
    if(*prog == '#'){
      *t++ = *prog++;
      tok = DIRECTIVE;
    }
    else if(*prog == '{'){
      *t++ = *prog++;
      tok = OPENING_BRACE;
    }
    else if(*prog == '}'){
      *t++ = *prog++;
      tok = CLOSING_BRACE;
    }
    else if(*prog == '['){
      *t++ = *prog++;
      tok = OPENING_BRACKET;
    }
    else if(*prog == ']'){
      *t++ = *prog++;
      tok = CLOSING_BRACKET;
    }
    else if(*prog == '='){
      *t++ = *prog++;
      if (*prog == '='){
        *t++ = *prog++;
        tok = EQUAL;
      }
      else 
        tok = ASSIGNMENT;
    }
    else if(*prog == '&'){
      *t++ = *prog++;
      if(*prog == '&'){
        *t++ = *prog++;
        tok = LOGICAL_AND;
      }
      else
        tok = AMPERSAND;
    }
    else if(*prog == '|'){
      *t++ = *prog++;
      if (*prog == '|'){
        *t++ = *prog++;
        tok = LOGICAL_OR;
      }
      else 
        tok = BITWISE_OR;
    }
    else if(*prog == '~'){
      *t++ = *prog++;
      tok = BITWISE_NOT;
    }
    else if(*prog == '<'){
      *t++ = *prog++;
      if (*prog == '='){
        *t++ = *prog++;
        tok = LESS_THAN_OR_EQUAL;
      }
      else if (*prog == '<'){
        *t++ = *prog++;
        tok = BITWISE_SHL;
      }
      else
        tok = LESS_THAN;
    }
    else if(*prog == '>'){
      *t++ = *prog++;
      if (*prog == '='){
        *t++ = *prog++;
        tok = GREATER_THAN_OR_EQUAL;
      }
      else if (*prog == '>'){
        *t++ = *prog++;
        tok = BITWISE_SHR;
      }
      else 
        tok = GREATER_THAN;
    }
    else if(*prog == '!'){
      *t++ = *prog++;
      if(*prog == '='){
        *t++ = *prog++;
        tok = NOT_EQUAL;
      }
      else 
        tok = LOGICAL_NOT;
    }
    else if(*prog == '?'){
      *t++ = *prog++;
      tok = TERNARY_OP;
    }
    else if(*prog == '+'){
      *t++ = *prog++;
      if(*prog == '+'){
        *t++ = *prog++;
        tok = INCREMENT;
      }
      else 
        tok = PLUS;
    }
    else if(*prog == '-'){
      *t++ = *prog++;
      if(*prog == '-'){
        *t++ = *prog++;
        tok = DECREMENT;
      }
      else if(*prog == '>'){
        *t++ = *prog++;
        tok = STRUCT_ARROW;
      }
      else 
        tok = MINUS;
    }
    else if(*prog == '$'){
      *t++ = *prog++;
      tok = DOLLAR;
    }
    else if(*prog == '^'){
      *t++ = *prog++;
      tok = BITWISE_XOR;
    }
    else if(*prog == '@'){
      *t++ = *prog++;
      tok = AT;
    }
    else if(*prog == '*'){
      *t++ = *prog++;
      tok = STAR;
    }
    else if(*prog == '/'){
      *t++ = *prog++;
      tok = FSLASH;
    }
    else if(*prog == '%'){
      *t++ = *prog++;
      tok = MOD;
    }
    else if(*prog == '('){
      *t++ = *prog++;
      tok = OPENING_PAREN;
    }
    else if(*prog == ')'){
      *t++ = *prog++;
      tok = CLOSING_PAREN;
    }
    else if(*prog == ';'){
      *t++ = *prog++;
      tok = SEMICOLON;
    }
    else if(*prog == ':'){
      *t++ = *prog++;
      tok = COLON;
    }
    else if(*prog == ','){
      *t++ = *prog++;
      tok = COMMA;
    }
    else if(*prog == '.'){
      *t++ = *prog++;
      if(*prog == '.' && *(prog+1) == '.'){
        *t++ = *prog++;
        *t++ = *prog++;
        tok = VAR_ARGS;
      }
      else tok = STRUCT_DOT;
    }
  }

  *t = '\0';
}

void back(void){
  char *t = token;

  while(*t){
    prog--;
    t++;
  }
  tok = TOK_UNDEF;
  toktype = TYPE_UNDEF;
  token[0] = '\0';
}

void push_prog(){
  if(prog_tos == 10) error("Cannot push prog. Stack overflow.");
  prog_stack[prog_tos] = prog;
  prog_tos++;
}

void pop_prog(){
  if(prog_tos == 0) error("Cannot pop prog. Stack overflow.");
  prog_tos--;
  prog = prog_stack[prog_tos];
}

void get_line(void){
  char *t;

  t = string_const;
  *t = '\0';
  
  while(*prog != 0x0A && *prog && *prog != ';'){
    *t++ = *prog++;
  }
  if(*prog == ';') while(*prog != 0x0A && *prog) prog++;

  if(*prog == '\0' && string_const[0] == '\0') error("Unexpected EOF");

  while(is_space(*prog)) prog++;
  *t = '\0';
}


int search_keyword(char *keyword){
  register int i;
  
  for(i = 0; keyword_table[i].key; i++)
    if (!strcmp(keyword_table[i].keyword, keyword)) return keyword_table[i].key;
  
  return -1;
}

char is_delimiter(char c){
  return c == '$'
      || c == '#'
      || c == '+'
      || c == '-'
      || c == '*'
      || c == '/'
      || c == '%'
      || c == '['
      || c == ']'
      || c == '{'
      || c == '}'
      || c == '('
      || c == ')'
      || c == ':'
      || c == ';'
      || c == ','
      || c == '.'
      || c == '<'
      || c == '>'
      || c == '='
      || c == '!'
      || c == '^'
      || c == '&'
      || c == '|'
      || c == '~'
      || c == '?'
      || c == '@';
}

char is_hex_digit(char c){
  return c >= '0' && c <= '9' || c >= 'a' && c <= 'f' || c >= 'A' && c <= 'F';
}

char is_digit(char c){
  return c >= '0' && c <= '9';
}

char is_identifier_char(char c){
  return isalpha(c) || c == '_';
}

char is_space(char c){
  return c == ' ' || c == '\t' || c == '\n' || c == '\r';
}

void dbg(char *s){
  puts(s);
  exit(0);
}