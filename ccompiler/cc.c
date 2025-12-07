/*
  A C compiler for the Sol-1 Homebrew Minicomputer

  TODO:
  ** pointer arithmetic is imcomplete. operations dont take into account the pointer type, such as int, char, struct, etc types.
     meaning int *p; p+1;, for example adds 1 instead of 2 as offsets.
  ** fix goto: at present we cannot jump to a label that is declared after the goto.
  ** look at cast() function for improvements.
  ** implement 'register' keyworded type local variables  
  ** change unary logical not operator to use cmp32 cb, i32 instead of cmp32 ga, i32, when the new instruction is burned in rom 
  ** implement mov32 b, [d] to move a 32bit integer address by 'd'
  ** implement add32 ga, cb and sub32 cb, ga
  ** implement mov d, [addr16]   (for UART IRQ to finish faster )

  low priority:
  ** write a syntax parser/checker so that EITHER:
    * at beginning of program entire syntax is checked for errors 
    * after syntax is cleared OK, simply parse semantics which will be a simple matter of issuing a bunch of get()'s as the semantic parses parses.
  OR:
    * run syntax checker on a construct basis such that when executing a construct, say IF, check entire syntax for that construct and clear syntax
    * and thenparse semantics for that construct
*/

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>

#include "definitions.h"
#include "char.h"
#include "debug.h"
#include "search.h"
#include "cc.h"

char *libc_directory = "./lib/";

defines_table_t defines_table[MAX_DEFINES];
t_typedef typedef_table[MAX_TYPEDEFS];
t_function function_table[MAX_USER_FUNC];
t_function included_functions[MAX_USER_FUNC];
t_enum enum_table[MAX_ENUM_DECLARATIONS];
t_struct struct_table[MAX_STRUCT_DECLARATIONS];
t_union union_table[MAX_UNION_DECLARATIONS];
t_var global_var_table[MAX_GLOBAL_VARS];
char string_table[STRING_TABLE_SIZE][TOKEN_LEN];

uint8_t return_is_last_statement;
uint8_t override_return_is_last_statement; // used to indicate a return statement was found while executing an IF.
                                       // i.e if a return is found but is inside an IF, then it is not a TRUE final
                                       // return statement inside a function.

int current_function_var_bp_offset;    // this is used to position local variables correctly relative to BP.
int current_func_id;
int function_table_tos;
int global_var_tos;
int enum_table_tos;
int struct_table_tos;
int union_table_tos;
int defines_tos;
int typedef_table_tos;
int string_table_tos;
int included_function_list_tos;

char *prog;                           // pointer to the current program position
char *prog_stack[2048];
int prog_tos;

t_included_function_list_item included_function_list[1024];
char include_kernel_exp = 1;
char org[64] = "text_org";
char included_functions_table[512][ID_LEN];

t_token curr_token;

char c_in[PROG_SIZE];               // C program-in buffer
char include_files_buffer[PROG_SIZE];     // buffer for reading in include files
char asm_out[ASM_SIZE];             // ASM output
char data_block_asm[ASM_SIZE];
char tempbuffer[TEMP_BUFFER_SIZE];

char *asm_p;
char *data_p;
char *data_block_p;
char *prog_before_error;

t_loop_type current_loop_type;      // is it a for, while, do, or switch?
t_loop_type loop_type_stack[256];
int loop_type_tos;

int highest_label_index; // keeps the highest label index and always increases
int current_label_index_if; 
int current_label_index_ter; 
int current_label_index_for; 
int current_label_index_do; 
int current_label_index_while; 
int current_label_index_switch; 
int cmp_label_index;
int label_stack_if[64];
int label_stack_ter[64];
int label_stack_for[64];
int label_stack_do[64];
int label_stack_while[64];
int label_stack_switch[64];
int cmp_label_stack[64];
int label_tos_if;
int label_tos_ter;
int label_tos_for;
int label_tos_do;
int label_tos_while;
int label_tos_switch;
int label_tos_cmp;


// --- MAIN
int main(int argc, char *argv[]){
  int main_index;
  char filename_no_ext[256];
  char filename_out[ID_LEN];
  char switch_display_function_table;
  char switch_display_typedef_table;
  int total_c_lines;
  int total_asm_lines;
  float apc_ratio; // asm lines per c lines ratio
  char date_str[64];
  time_t now = time(NULL);
  struct tm *t = localtime(&now);

  // Format date as "DD-MM-YYYY"
  strftime(date_str, sizeof(date_str), "%d-%m-%Y at %H:%M:%S", t);

  switch_display_function_table = 0;
  switch_display_typedef_table  = 0;

  if(argc > 1){
    if(find_cmdline_switch(argc, argv, "--display-tables")){
      switch_display_function_table = 1;
      switch_display_typedef_table = 1;
    }
    load_program(argv[1]);  
  }
  else{
    printf("usage: cc [filename]\n");
    return 0;
  }

  strcpy(filename_no_ext, basename(argv[1]));
  for(size_t i = 0; i < strlen(filename_no_ext); i++){
    if(filename_no_ext[i] == '.'){
      filename_no_ext[i] = '\0';
      break;
    }
  }

  printf("starting compilation of '%s'\n", argv[1]);

  asm_p = asm_out;  // set ASM out pointer to the ASM array beginning
  data_block_p = data_block_asm; // data block pointer

  emitln("", "; --- FILENAME: %s", argv[1]);
  emitln("", "; --- DATE:     %s", date_str);
  if(include_kernel_exp) emitln("", ".include \"lib/asm/kernel.exp\"");
  emitln("", ".include \"lib/asm/bios.exp\"");

  declare_heap_global_var();
  pre_processor();
  
  pre_scan();
  
  // count total number of c lines
  total_c_lines = count_total_lines(c_in);

  if((main_index = search_function("main")) != -1){
    if(search_function_parameter(main_index, "argc") != -1 && search_function_parameter(main_index, "argv") != -1){
      insert_runtime();
    }
  }

  emit("\n; --- BEGIN TEXT SEGMENT");
  parse_functions();
  emitln("", "; --- END TEXT SEGMENT");

  // count total number of asm lines
  total_asm_lines = count_total_lines(asm_out);

  asm_p = asm_out;
  while(*asm_p) asm_p++; 
  
  emitln("", "\n; --- BEGIN DATA SEGMENT");

  emit_string_table_data();

  // emit heap
  emit_data("\n_heap_top: .dw _heap\n");
  emit_data("_heap: .db 0\n");
  
  emit_datablock_asm();

  emitln("", "; --- END DATA SEGMENT");

  emitln("", "\n.end");
  *asm_p = '\0';

  /*
  printf("\n**************************************************");

  printf("\nGLOBAL VARIABLE TABLE:\n");
  for(int i = 0; i < global_var_tos; i++){
    dbg_print_var_info(global_var_table[i]);
  }
  printf("\nFUNCTION TABLE:\n");
  for(int i = 0; i < function_table_tos; i++){
    dbg_print_function_info(function_table[i]);
  }
  printf("\n");
*/
  //optimize_asm();
  apc_ratio = (float)total_asm_lines / (float)total_c_lines;
  printf("\n*** c compiler statistics ***"
         "\ntotal c lines   : %d"
         "\ntotal asm lines : %d"
         "\nline ratio      : %3.3f assembly lines per c line (average)\n", 
         total_c_lines, 
         total_asm_lines, 
         apc_ratio
  );

  strcpy(filename_out, "out/");
  strcat(filename_out, filename_no_ext);
  strcat(filename_out, ".asm");
  generate_file(filename_out); // generate named assembly file
  generate_file("out.asm"); // generate a.s assembly file

  if(switch_display_function_table) print_function_table();
  if(switch_display_typedef_table) print_typedef_table();

  return 0;
}

int count_total_lines(char *text){
  char *p = text;
  int lines = 0;
  while(*p){
    if(*p == '\n') lines++;
    p++;
  }
  return lines;
}

void add_library_type_declarations(){
  char *temp_prog, *temp_prog2;
  char *prog_at_identifier;
  int paren, braces;

  printf("adding library type definitions...");

  strcat(c_in, "\n");
  prog = include_files_buffer;
  for(;;){
    temp_prog = prog;
    get();
    temp_prog2 = prog;
    if(curr_token.tok_type == END) break;
    if(curr_token.tok == TYPEDEF){
      prog = temp_prog;
      get_line();
      strcat(c_in, "\n");
      strcat(c_in, curr_token.string_const);
    }
    else if(
      curr_token.tok == SIGNED   || curr_token.tok == UNSIGNED || 
      curr_token.tok == LONG     || curr_token.tok == CONST    || 
      curr_token.tok == VOID     || curr_token.tok == CHAR     ||
      curr_token.tok == INT      || curr_token.tok == FLOAT    || 
      curr_token.tok == DOUBLE   || curr_token.tok == STRUCT   ||
      curr_token.tok == SHORT    || curr_token.tok == STATIC   ||
      curr_token.tok == ENUM     || curr_token.tok == UNION    ||
      curr_token.tok == REGISTER || curr_token.tok == VOLATILE || 
      curr_token.tok_type == IDENTIFIER
    ){
      while(
        curr_token.tok == CONST    || curr_token.tok == STATIC   || 
        curr_token.tok == SIGNED   || curr_token.tok == UNSIGNED ||
        curr_token.tok == LONG     || curr_token.tok == SHORT    ||
        curr_token.tok == REGISTER || curr_token.tok == VOLATILE
      ) get();
      if(curr_token.tok == STRUCT || curr_token.tok == ENUM || curr_token.tok == UNION){
        get(); // get struct/enum/union name
      }
      get(); // get '{', '*', or name
      if(curr_token.tok == OPENING_BRACE){ // struct declaration
        strcat(c_in, "\n");
        prog = temp_prog;
        for(;;){ // copy everything before the '{'
          get();
          if(curr_token.tok == OPENING_BRACE) break;
          strcat(c_in, curr_token.token_str);
          strcat(c_in, " ");
        }
        strcat(c_in, curr_token.token_str); // concat '{' which was got before the loop broke
        braces = 1;
        for(;;){ // now copy whats inside the braces
          get();
          strcat(c_in, curr_token.token_str);
          strcat(c_in, " ");
          if(curr_token.tok == OPENING_BRACE) braces++;
          else if(curr_token.tok == CLOSING_BRACE) braces--;
          if(braces == 0) break;
        }
        get(); 
        if(curr_token.tok != SEMICOLON) error(ERR_FATAL, "semicolon expected in struct declaration");
        strcat(c_in, curr_token.token_str);
      }
      else{
        if(curr_token.tok == STAR){
          while(curr_token.tok == STAR){
            get();
          }
        }
        get(); // get semicolon, assignment, comma
        if(curr_token.tok != OPENING_PAREN){ 
          prog = temp_prog;
          get_line();
          strcat(c_in, "\n");
          strcat(c_in, curr_token.string_const);
        }
        else{ // is a function, skip it
          paren = 1;
          for(;;){
            get();
            if(curr_token.tok == OPENING_PAREN) paren++;
            else if(curr_token.tok == CLOSING_PAREN) paren--;
            if(paren == 0) break;
          }
          get(); // get '{'
          skip_block(1);
        }
      }
    }
  }
  printf(" OK\n");
}

void add_included_function_to_list(char *name){
  if(included_function_list_tos == 1024) error(ERR_FATAL, "maximum number of included functions in list is reached");
  strcpy(included_function_list[included_function_list_tos].name, name);
  included_function_list_tos++;
}

t_included_function_list_item find_included_function(char *name){
  register int i;
  t_included_function_list_item item = {0};

  for(i = 0; i < included_function_list_tos; i++){
    if(!strcmp(included_function_list[i].name, name)){
      return included_function_list[i];
    }
  }
  return item;
}

void search_and_add_func(){
  char *temp_prog;
  char func_name[ID_LEN];
  char *main_loc = NULL;
  int braces = 1;
  t_function_endpoints endpoints = {NULL};
  char function[FUNCTION_SIZE_MAX_LEN];
  char *origin, *dest;

  puts("adding library functions...");
  prog = c_in;
  // search for main()
  for(;;){
    temp_prog = prog;
    get();
    if(curr_token.tok_type == END) error(ERR_FATAL, "main function not declared.");
    if(curr_token.tok == INT || curr_token.tok == VOID){
      get();
      if(curr_token.tok_type == IDENTIFIER){
        if(!strcmp(curr_token.token_str, "main")){
          get(); // get '('
          while(curr_token.tok != CLOSING_PAREN) get();
          get(); // get '{'
          main_loc = prog;
          break;
        }
      }
    }
  }

  if(main_loc == NULL) error(ERR_FATAL, "main function not declared.");
  // here, the main function has been found, start parsing it for function references

  fetch_included_functions(main_loc);

  prog = c_in;
}

void fetch_included_functions(char *func_loc){
  char *temp_prog, *c_in_p;
  char func_name[ID_LEN];
  int braces = 1;
  t_function_endpoints endpoints = {NULL};
  char function[FUNCTION_SIZE_MAX_LEN];
  char *origin, *dest;
  t_included_function_list_item included_function;

  prog = func_loc;
  for(;;){
    temp_prog = prog;
    get();
    if(curr_token.tok == OPENING_BRACE) braces++;
    else if(curr_token.tok == CLOSING_BRACE) braces--;
    if(braces == 0){ // end of function
      break;
    }
    if(curr_token.tok_type == IDENTIFIER){
      strcpy(func_name, curr_token.token_str);
      get();
      if(curr_token.tok == OPENING_PAREN){
        endpoints = locate_function(c_in, func_name);
        included_function = find_included_function(func_name);
        if(included_function.name[0] != '\0') continue; // if the function is in the list, it was already added previously
        if(endpoints.start == NULL){
          endpoints = locate_function(include_files_buffer, func_name);
          if(endpoints.start != NULL){ // include function if it exists
            add_included_function_to_list(func_name); // add new function to the list
            origin = endpoints.start;
            dest = function;
            while(origin != endpoints.end){
              *dest++ = *origin++;
            }
            *dest = '\0';
            push_prog(); // save current prog location
            c_in_p = c_in + strlen(c_in); // pointer to the end of c_in, before the concatenation happens
            strcat(c_in, "\n\n");
            strcat(c_in, function);
            prog = c_in_p; // set prog to beginning of the new function so it can be parsed
            while(*prog != '{') prog++;
            prog++; // skip '{'
            // now we are about to start parsing the new function, searching for function references inside of it recursively
            fetch_included_functions(prog);
            pop_prog(); // and now resume where we were before we found the function reference and added its code
          }
        }
        else{
          add_included_function_to_list(func_name); // add new function to the list
          push_prog(); // save current prog location
          prog = endpoints.start; // set prog to beginning of the new function so it can be parsed
          while(*prog != '{') prog++;
          prog++; // skip '{'
          // now we are about to start parsing the new function, searching for function references inside of it recursively
          fetch_included_functions(prog);
          pop_prog(); // and now resume where we were before we found the function reference and added its code
        }
      }
      else{
        back();
        continue;
      }
    }
  }
}

// unsigned long int my_func(int a, char b){}
t_function_endpoints locate_function(char *location, char *name){
  char *orig_prog;
  char *temp_prog;
  t_function_endpoints endpoints = {NULL};

  orig_prog = prog;
  prog = location;
  for(;;){
    temp_prog = prog;
    get();
    if(curr_token.tok_type == END){
      prog = orig_prog;
      endpoints.start = NULL;
      endpoints.end = NULL;
      return endpoints;
    }
    if(is_function_declaration()){ // if is a function declaration. prog will be pointing to identifier
      get();
      if(!strcmp(curr_token.token_str, name)){
        endpoints.start = temp_prog;
        while(*prog != '{') prog++;
        prog++;
        skip_block(1); // find final '}' of function block
        endpoints.end = prog;
        prog = orig_prog;
        return endpoints;
      }
    }
  }
  error(ERR_FATAL, "unterminated file while trying to locate function");
}

void build_referenced_func_list(void){
  uint16_t braces;
}

void declare_all_defines(){
  char *p;

  printf("declaring all defines...");
  prog = c_in;
  for(;;){
    p = prog;
    get(); 
    if(curr_token.tok_type == END) {
      break;
    }
    if(curr_token.tok == DIRECTIVE){
      get();
      if(curr_token.tok == DEFINE){
        prog = p;
        declare_define();
        prog = c_in;
      }
    }
  } 
  
  prog = include_files_buffer;
  for(;;){
    p = prog;
    get(); 
    if(curr_token.tok_type == END){
      break;
    }
    if(curr_token.tok == DIRECTIVE){
      get();
      if(curr_token.tok == DEFINE){
        prog = p;
        declare_define();
        prog = include_files_buffer;
      }
    }
  } 

  prog = c_in;
  printf(" OK\n");
}

void expand_all_included_files(void){
  FILE *fp;
  int i, define_id;
  char *p, *temp_prog, *temp_prog2;
  char *pi;
  char filename[256];
  uint8_t found_include;

  prog = c_in;
  pi = include_files_buffer;

  for(;;){
    get(); 
    back(); // So that we discard possible new line chars at end of lines
    temp_prog2 = prog;
    get();
    if(curr_token.tok_type == END) break;
    if(curr_token.tok == DIRECTIVE){
      get();
      if(curr_token.tok == INCLUDE){
        get();
        if(curr_token.tok_type == STRING_CONST) strcpy(filename, curr_token.string_const);
        else if(curr_token.tok == LESS_THAN){
          strcpy(filename, libc_directory);
          for(;;){
            get();
            if(curr_token.tok_type == END) error(ERR_FATAL, "syntax error in include directive: ('>' expected)");
            if(curr_token.tok == GREATER_THAN) break;
            strcat(filename, curr_token.token_str);
          }
        }
        else error(ERR_FATAL, "syntax error in include directive");
        if((fp = fopen(filename, "rb")) == NULL) error(ERR_FATAL, "%s: included source file not found\n", filename);
        overwrite_with_spaces(temp_prog2, prog - temp_prog2);
        pi = include_files_buffer;
        while(*pi) pi++;
        do{
          *pi = getc(fp);
          pi++;
        } while(!feof(fp));
        *(pi-1) = '\n';
        *pi++ = '\n';
        *(pi) = '\0'; // overwrite the EOF char with NULL
        fclose(fp);
      }
    }
  }


  prog = include_files_buffer;
  for(;;){
    get(); 
    back(); // So that we discard possible new line chars at end of lines
    temp_prog2 = prog;
    get();
    if(curr_token.tok_type == END) break;
    if(curr_token.tok == DIRECTIVE){
      get();
      if(curr_token.tok == INCLUDE){
        get();
        if(curr_token.tok_type == STRING_CONST) strcpy(filename, curr_token.string_const);
        else if(curr_token.tok == LESS_THAN){
          strcpy(filename, libc_directory);
          for(;;){
            get();
            if(curr_token.tok_type == END) error(ERR_FATAL, "syntax error in include directive: ('>' expected)");
            if(curr_token.tok == GREATER_THAN) break;
            strcat(filename, curr_token.token_str);
          }
        }
        else error(ERR_FATAL, "syntax error in include directive");
        if((fp = fopen(filename, "rb")) == NULL) error(ERR_FATAL, "%s: included source file not found\n", filename);
        overwrite_with_spaces(temp_prog2, prog - temp_prog2);
        pi = include_files_buffer;
        while(*pi) pi++;
        do{
          *pi = getc(fp);
          pi++;
        } while(!feof(fp));
        *(pi-1) = '\n';
        *pi++ = '\n';
        *(pi) = '\0'; // overwrite the EOF char with NULL
        fclose(fp);
      }
    }
  }
  prog = c_in;
}

char *find_next(char *first, char *second){
  char *prog_orig;
  char *result;

  get_asm(); back();
  prog_orig = prog;
  for(;;){
    get_asm(); back(); // skip comments
    result = prog;
    get_asm();
    if(curr_token.tok_type == END){
      prog = prog_orig;
      return NULL;
    }
    if(!strcmp(curr_token.token_str, first)){
      if(second[0] != '\0'){
        for(;;){
          get_asm(); back(); // skip comments
          get_asm();
          if(curr_token.tok_type == END){
            prog = prog_orig;
            return NULL;
          }
          if(!strcmp(curr_token.token_str, second)){
            return result;           
          }
        }
      }
      else{
        return result;
      }
    }
  }
}

char *find_between(char *first, char *second, char *begin, char *end){
  char *prog_orig;
  char *result;

  get_asm(); back();
  prog_orig = prog;
  prog = begin;  
  for(;;){
    get_asm(); back(); // skip comments
    if(prog > end){
      prog = prog_orig;
      return NULL;
    }
    result = prog;
    get_asm();
    if(curr_token.tok_type == END){
      prog = prog_orig;
      return NULL;
    }
    if(!strcmp(curr_token.token_str, first)){
      if(second[0] != '\0'){
        for(;;){
          get_asm(); back(); // skip comments
          if(prog > end){
            prog = prog_orig;
            return NULL;
          }
          get_asm();
          if(curr_token.tok_type == END){ 
            prog = prog_orig;
            return NULL;
          }
          if(!strcmp(curr_token.token_str, second)){
            return result;           
          }
        }
      }
      else{
        return result;
      }
    }
  }
}

int optimize_asm(){
  char *start, *end;
  char *addr1;

  prog = asm_out;
  for(;;){
    find_next("main", ":");
    start = find_next("push", "d");
    if(start != NULL){
      prog = start;
      for(;;){
        end = find_next("pop", "d");
        if(end != NULL){
          for(;;){
            addr1 = find_between("call", "", start, end);
            if(addr1 != NULL){
              prog = addr1;
              get_asm();
              dbg(tkn);
            }
            else dbg("not found");
          }
        }
      }
    }
  }
}

void emit_datablock_asm(){
  char *dp = data_block_asm;

  printf("emitting data block...");
  while(*dp){
    *asm_p++ = *dp++;
  }
  printf(" OK\n");
}

char find_cmdline_switch(int argc, char **argv, char *_switch){
  for(int i = 0; i < argc; i++){
    if(!strcmp(argv[i], _switch)) return 1;
  }
  return 0;
}

// Declare int argc, char argv [] variables
// if argc and argv variables are in main(), then we create two new local variables inside main
// such that int argc contains the number of arguments given in 0x00, with a space separator
// and char argv[], will contain the string argument entries as a vector.
// char argv[] is an array of pointers so each entry contains a pointer to an argument string.
// 
// for calculating argc, we need to write assembly that will count space separated arguments.
void insert_runtime() {
  /*
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
  */
}

int is_register(char *name){
  if(!strcmp(name, "a")  ||
     !strcmp(name, "ah") ||
     !strcmp(name, "al") ||
     !strcmp(name, "b")  ||
     !strcmp(name, "bh") ||
     !strcmp(name, "bl") ||
     !strcmp(name, "c")  ||
     !strcmp(name, "ch") ||
     !strcmp(name, "cl") ||
     !strcmp(name, "d")  ||
     !strcmp(name, "dh") ||
     !strcmp(name, "dl") ||
     !strcmp(name, "gh") ||
     !strcmp(name, "gl") ||
     !strcmp(name, "g")  ||
     !strcmp(name, "si") ||
     !strcmp(name, "di") ||
     !strcmp(name, "sp") ||
     !strcmp(name, "bp")
  )
    return 1;
  else 
    return 0;
}

void declare_heap_global_var(){
  printf("declaring the heap memory...");
  strcpy(global_var_table[global_var_tos].name, "heap_top");
  global_var_table[global_var_tos].type.primitive_type = DT_CHAR;
  global_var_table[global_var_tos].type.is_constant    = FALSE;
  global_var_table[global_var_tos].type.dims[0]        = 0;
  global_var_table[global_var_tos].type.ind_level      = 1;
  global_var_table[global_var_tos].type.size_modifier  = SIZEMOD_NORMAL;
  global_var_table[global_var_tos].type.sign_modifier  = SIGNMOD_UNSIGNED;
  global_var_table[global_var_tos].type.is_func_ptr    = FALSE;
  global_var_table[global_var_tos].is_parameter        = FALSE;
  global_var_table[global_var_tos].is_volatile         = FALSE;
  global_var_table[global_var_tos].is_static           = FALSE;
  global_var_table[global_var_tos].is_register         = FALSE;
  global_var_tos++;

  strcpy(global_var_table[global_var_tos].name, "heap");
  global_var_table[global_var_tos].type.primitive_type = DT_CHAR;
  global_var_table[global_var_tos].type.is_constant    = FALSE;
  global_var_table[global_var_tos].type.dims[0]        = 0;
  global_var_table[global_var_tos].type.ind_level      = 1;
  global_var_table[global_var_tos].type.size_modifier  = SIZEMOD_NORMAL;
  global_var_table[global_var_tos].type.sign_modifier  = SIGNMOD_UNSIGNED;
  global_var_table[global_var_tos].type.is_func_ptr    = FALSE;
  global_var_table[global_var_tos].is_parameter        = FALSE;
  global_var_table[global_var_tos].is_volatile         = FALSE;
  global_var_table[global_var_tos].is_static           = FALSE;
  global_var_table[global_var_tos].is_register         = FALSE;
  global_var_tos++;
  printf(" OK\n");
}

void emit_data(const char* format, ...){
  char *bufferp = tempbuffer;
  va_list args;
  va_start(args, format);
  vsnprintf(tempbuffer, TEMP_BUFFER_SIZE, format, args);
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
  vsnprintf(tempbuffer, TEMP_BUFFER_SIZE, format, args);
  va_end(args);
  while (*bufferp){
    *asm_p++ = *bufferp++;
  }
}

void emitln(char * comment, const char* format, ...){
  char *bufferp = tempbuffer;
  va_list args;
  va_start(args, format);
  vsnprintf(tempbuffer, TEMP_BUFFER_SIZE, format, args);
  va_end(args);
  while (*bufferp){
    *asm_p++ = *bufferp++;
  }
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


void parse_functions(void){
  register int i;
  
  printf("parsing main function...");
  for(i = 0; *function_table[i].name; i++){
    // parse main function first
    if(strcmp(function_table[i].name, "main") == 0){
      // this is used to position local variables correctly relative to BP.
      // whenever a new function is parsed, this is reset to 0.
      // then inside the function it can increase according to how any local vars there are.
      emit("\n.org %s", org);
      emitln("", "\n%s:", function_table[i].name);
      emitln("", "  mov bp, $FFE0 ;");
      emitln("", "  mov sp, $FFE0 ; Make space for argc(2 bytes) and for 10 pointers in argv (local variables)");
      current_function_var_bp_offset = 0; 
      current_func_id = i;
      prog = function_table[i].code_location;
      parse_block(); // starts parsing the function block;
      if(return_is_last_statement == FALSE){ // generate code for a 'return'
        emitln("", "  syscall sys_terminate_proc");
      }
      break;
    }
  }
  printf(" OK\n");

  printf("parsing all functions...");
  for(i = 0; *function_table[i].name; i++){
    if(strcmp(function_table[i].name, "main") != 0){ // skip 'main'
      // this is used to position local variables correctly relative to BP.
      // whenever a new function is parsed, this is reset to 0.
      // then inside the function it can increase according to how any local vars there are.
      emitln("", "\n%s:", function_table[i].name);
      emitln("", "  enter 0 ; (push bp; mov bp, sp)");
      current_function_var_bp_offset = 0;
      current_func_id = i;
      prog = function_table[i].code_location;
      parse_block(); // starts parsing the function block;
      if(return_is_last_statement == FALSE){ // generate code for a 'return'
        emitln("", "  leave");
        emitln("", "  ret");
      }
    }
  }
  printf(" OK\n");
}

void declare_define(){
  char *p;
  char *d;

  d = prog;
  p = defines_table[defines_tos].content;
  get(); // '#'
  get(); // define
  get(); // get define's name
  strcpy(defines_table[defines_tos].name, curr_token.token_str);
  // get value
  while(*prog != '\n' && *prog != '\0'    && 
      !(*prog == '/' && *(prog+1) == '/') &&
      !(*prog == '/' && *(prog+1) == '*') 
  ){
    *p++ = *prog++;
  }
  *p = '\0';

  if(*prog == '/' && *(prog+1) == '/'){
    while(*prog != '\n') prog++;
  }
  else if(*prog == '/' && *(prog+1) == '*'){
    while(!(*prog == '*' && *(prog+1) == '/') && *prog) prog++;
    if(!*prog) error(ERR_FATAL, "unterminated comment");
    prog += 2;
  }

  defines_tos++;

  overwrite_with_spaces(d, prog - d);
}

void overwrite_with_spaces(char *start, int len){
  char *p = start;
  while(p < start + len){
    *p = ' ';
    p++;
  }
}

void insert(char *destination, char *new_text){
  char *p = destination;
  char *p2 = new_text;
  int len = strlen(new_text);

  while(*p) p++; // fast forwards to end of text 
  while(p >= destination){
    *(p + len) = *p;
    p--;
  }
  p++;
  while(*p2){
    *p++ = *p2++;
  }
}

void delete(char *start, int len){
  char *p;
  int length;

  length = strlen(start);
  if(len > length){
    printf("\nerror: trying to delete a sub-string that is larger than the original string\n");
    exit(1);
  }
  p = start + len;
  while(*p){
    *(p-len) = *p;
    p++;
  }
  *(p-len) = '\0';
}

void pre_processor(void){
  FILE *fp;
  int define_id;
  char *p, *temp_prog;
  char filename[256];

  puts("starting pre-processor...");
  expand_all_included_files();
  declare_all_defines();
  search_and_add_func();
  add_library_type_declarations();
  
  printf("replacing defines with their declared values...");
  prog = c_in; 
  for(;;){
    get(); 
    back(); // So that we discard possible new line chars at end of lines
    temp_prog = prog;
    get();
    if(curr_token.tok_type == END) break;

    if((define_id = search_define(curr_token.token_str)) != -1){
      overwrite_with_spaces(temp_prog, prog - temp_prog);
      insert(temp_prog, defines_table[define_id].content);
      prog = c_in;
    }
  }
  prog = c_in;
  printf(" OK\n");
}

uint8_t is_function_declaration(void){
  char *prog_at_identifier;
  int paren;

  if(
    curr_token.tok      == SIGNED   || curr_token.tok == UNSIGNED || 
    curr_token.tok      == LONG     || curr_token.tok == CONST    || 
    curr_token.tok      == VOID     || curr_token.tok == CHAR     ||
    curr_token.tok      == INT      || curr_token.tok == FLOAT    || 
    curr_token.tok      == DOUBLE   || curr_token.tok == STRUCT   ||
    curr_token.tok      == SHORT    || 
    curr_token.tok      == ENUM     || curr_token.tok == UNION    ||
    curr_token.tok_type == IDENTIFIER
  ){
    while(
      curr_token.tok == CONST    || 
      curr_token.tok == SIGNED   || curr_token.tok == UNSIGNED ||
      curr_token.tok == LONG     || curr_token.tok == SHORT   
    ){
      get();
    }
    if(curr_token.tok == STRUCT || curr_token.tok == ENUM || curr_token.tok == UNION){
      get();
    }
    prog_at_identifier = prog;
    get();
    if(curr_token.tok_type != IDENTIFIER && curr_token.tok != STAR) return 0;
    if(curr_token.tok == STAR){
      while(curr_token.tok == STAR){
        prog_at_identifier = prog;
        get();
      }
    }
    if(curr_token.tok_type != IDENTIFIER) return 0;
    get(); 
    if(curr_token.tok == OPENING_PAREN){ 
      paren = 1;
      for(;;){
        get();
        if(curr_token.tok == OPENING_PAREN) paren++;
        else if(curr_token.tok == CLOSING_PAREN) paren--;
        if(paren == 0) break;
      }
      get();
      prog = prog_at_identifier;
      if(curr_token.tok == OPENING_BRACE) return 1;
      else return 0;
    }
    else{
      prog = prog_at_identifier;
      return 0;
    }
  }

  return 0;
}

// -1 : not a type
//  0 : variable
//  1 : function
// int (*fp)(int, char, int);
int8_t type_detected(void){
  char *prog_at_identifier;

  if(
    curr_token.tok == SIGNED   || curr_token.tok == UNSIGNED || 
    curr_token.tok == LONG     || curr_token.tok == CONST    || 
    curr_token.tok == VOID     || curr_token.tok == CHAR     ||
    curr_token.tok == INT      || curr_token.tok == FLOAT    || 
    curr_token.tok == DOUBLE   || curr_token.tok == STRUCT   ||
    curr_token.tok == SHORT    || curr_token.tok == STATIC   ||
    curr_token.tok == ENUM     || curr_token.tok == UNION    ||
    curr_token.tok == REGISTER || curr_token.tok == VOLATILE || 
    curr_token.tok == STATIC   || search_typedef(curr_token.token_str) != -1 
  ){
    while(
      curr_token.tok == CONST    || curr_token.tok == STATIC   || 
      curr_token.tok == SIGNED   || curr_token.tok == UNSIGNED ||
      curr_token.tok == LONG     || curr_token.tok == SHORT    ||
      curr_token.tok == REGISTER || curr_token.tok == VOLATILE ||
      curr_token.tok == STATIC
    ){
      get();
    }
    if(curr_token.tok == STRUCT || curr_token.tok == ENUM || curr_token.tok == UNION){
      get();
    }
    prog_at_identifier = prog;
    get();
    // if not a struct, union, or enum, then the var type has just been gotten
    if(curr_token.tok == STAR){
      while(curr_token.tok == STAR){
        prog_at_identifier = prog;
        get();
      }
    }
    get(); // get semicolon, assignment, comma, or opening braces
    if(curr_token.tok == OPENING_PAREN){ //it must be a function declaration
      prog = prog_at_identifier;
      return 1;
    }
    else{ // it must be a variable declaration
      prog = prog_at_identifier;
      return 0;
    }
  }
  return -1;
}

void pre_scan(void){
  char *tp;
  int8_t declaration_kind;

  puts("starting pre-scan...");
  prog = c_in;
  for(;;){
    tp = prog;
    get();
    if(curr_token.tok_type == END) break;

    if(curr_token.tok == TYPEDEF){
      declare_typedef();
      continue;
    }
    else if(curr_token.tok == SYSTEM){
      parse_system();  
      continue;
    }
    else if(curr_token.tok == ENUM){
      get();
      get();
      if(curr_token.tok == OPENING_BRACE){
        prog = tp;
        get(); // get 'enum'
        declare_enum();
        continue;
      }
      else{
        prog = tp;
        get();
      }
    }
    else if(curr_token.tok == STRUCT){
      get();
      get();
      if(curr_token.tok == OPENING_BRACE){
        prog = tp;
        declare_struct();
        continue;
      }
      else{
        prog = tp;
        get();
      }
    }
    else if(curr_token.tok == UNION){
      get();
      get();
      if(curr_token.tok == OPENING_BRACE){
        prog = tp;
        declare_union();
        continue;
      }
      else{
        prog = tp;
        get();
      }
    }
    declaration_kind = type_detected();
    if(declaration_kind == 0){
      prog = tp;
      declare_global();
      continue;
    }
    else if(declaration_kind == 1){
      prog = tp;
      declare_func();
      skip_block(0);
      continue;
    }
    else if(declaration_kind == -1){
      error(ERR_FATAL, "unexpected token during pre-scan phase: %s", curr_token.token_str);
    }
  }

  printf("pre-scan finished.\n");
}

//int (*fp)(int);
t_type get_type(){
  t_type type = {0};
  int typedef_id;
  int struct_enum_union_id;
  
  get();                                                                       
  if((typedef_id = search_typedef(curr_token.token_str)) != -1){                              
    type = typedef_table[typedef_id].type;                                     
  }                                                                            
  else{                                                                        
    type.sign_modifier = SIGNMOD_SIGNED; // set as signed by default             
    type.size_modifier = SIZEMOD_NORMAL; // set as signed by default               
    type.is_constant = FALSE;
    while(curr_token.tok == SIGNED || curr_token.tok == UNSIGNED || curr_token.tok == LONG || curr_token.tok == SHORT){    
           if(curr_token.tok == SIGNED)   type.sign_modifier = SIGNMOD_SIGNED;         
      else if(curr_token.tok == UNSIGNED) type.sign_modifier = SIGNMOD_UNSIGNED;            
      else if(curr_token.tok == SHORT)    type.size_modifier = SIZEMOD_SHORT;                 
      else if(curr_token.tok == LONG)     type.size_modifier = SIZEMOD_LONG;                  
      get();                                                                   
    }                                                                          
    type.primitive_type = get_primitive_type_from_tok();                       
    type.struct_enum_union_id = -1;                                                       

    if(type.primitive_type == DT_STRUCT){                                      
      get();                                                                   
      if((struct_enum_union_id = search_struct(curr_token.token_str)) == -1) 
        error(ERR_FATAL, "Undeclared struct: %s", curr_token.token_str);
      type.struct_enum_union_id = struct_enum_union_id;
    }
    else if(type.primitive_type == DT_ENUM){                                      
      get();                                                                   
      if((struct_enum_union_id = search_enum(curr_token.token_str)) == -1) 
        error(ERR_FATAL, "Undeclared enum: %s", curr_token.token_str);
      type.struct_enum_union_id = struct_enum_union_id;
    }
    if(type.primitive_type == DT_UNION){                                      
      get();                                                                   
      if((struct_enum_union_id = search_union(curr_token.token_str)) == -1) 
        error(ERR_FATAL, "Undeclared union: %s", curr_token.token_str);
      type.struct_enum_union_id = struct_enum_union_id;
    }
  }

  return type;
}

/*
union my_union_t{
  char c;
  int i;
  char ca[10];
  struct struct_t my_struct[5];
} i1[5];
*/
int declare_union(){
  int element_tos;
  int curr_struct_enum_union_id;
  int struct_enum_union_id;
  t_union new_union;
  int union_is_embedded = 0;
  int typedef_id;

  if(union_table_tos == MAX_UNION_DECLARATIONS) error(ERR_FATAL, "Max number of union declarations reached");
  
  curr_struct_enum_union_id = union_table_tos;
  get(); // 'union'
  if(curr_token.tok != OPENING_BRACE) get(); // try getting union name, but only if the current curr_token.token_str is not a brace, which means we are inside a union declaration already and one of the members was an implicit union that had no name, but is an elememnt of a previou sunion  
  if(curr_token.tok_type == IDENTIFIER){
    strcpy(new_union.name, curr_token.token_str);
    strcpy(union_table[union_table_tos].name, curr_token.token_str);
    get(); // '{'
    if(curr_token.tok != OPENING_BRACE) error(ERR_FATAL, "Opening braces expected");
    // Add the new union to the union table prematurely so that any elements in this union that are pointers of this union type can be recognized by a search
    union_table_tos++;
  }
  else if(curr_token.tok == OPENING_BRACE){ // implicit union declaration inside a union itself
    union_is_embedded = 1;
  // assign a null string to the union name then
    *new_union.name = '\0'; // okay to do since we dont use union names as the end point of search loops. we use 'union_table_tos'
    union_table_tos++;
  }

  element_tos = 0;
  do{
    if(element_tos == MAX_UNION_ELEMENTS) error(ERR_FATAL, "Max number of union elements reached");
    get();
    if((typedef_id = search_typedef(curr_token.token_str)) != -1){
      new_union.elements[element_tos].type = typedef_table[typedef_id].type;
      get();
    }
    else{
      new_union.elements[element_tos].type.sign_modifier = SIGNMOD_SIGNED; // set as signed by default
      new_union.elements[element_tos].type.size_modifier = SIZEMOD_NORMAL; // set as signed by default
      while(curr_token.tok == SIGNED || curr_token.tok == UNSIGNED || 
            curr_token.tok == LONG   || curr_token.tok == SHORT){
             if(curr_token.tok == SIGNED)   new_union.elements[element_tos].type.sign_modifier = SIGNMOD_SIGNED;
        else if(curr_token.tok == UNSIGNED) new_union.elements[element_tos].type.sign_modifier = SIGNMOD_UNSIGNED;
        else if(curr_token.tok == SHORT)    new_union.elements[element_tos].type.size_modifier = SIZEMOD_SHORT;
        else if(curr_token.tok == LONG)     new_union.elements[element_tos].type.size_modifier = SIZEMOD_LONG;
        get();
      }
      new_union.elements[element_tos].type.primitive_type = get_primitive_type_from_tok();
      new_union.elements[element_tos].type.struct_enum_union_id = -1;
      if(new_union.elements[element_tos].type.primitive_type == DT_STRUCT){
        get();
        if(curr_token.tok == OPENING_BRACE){ // internal union declaration!
          back();
          struct_enum_union_id = declare_struct();
          get(); // get element name
        }
        else{
          if((struct_enum_union_id = search_struct(curr_token.token_str)) == -1) error(ERR_FATAL, "undeclared struct");
          get();
        }
        new_union.elements[element_tos].type.struct_enum_union_id = struct_enum_union_id;
      }
      else if(new_union.elements[element_tos].type.primitive_type == DT_UNION){
        get();
        if(curr_token.tok == OPENING_BRACE){ // internal union declaration!
          back();
          struct_enum_union_id = declare_union();
          get(); // get element name
        }
        else{
          if((struct_enum_union_id = search_union(curr_token.token_str)) == -1) error(ERR_FATAL, "undeclared union");
          get();
        }
        new_union.elements[element_tos].type.struct_enum_union_id = struct_enum_union_id;
      }
      else get();

      new_union.elements[element_tos].type.ind_level = 0;
      while(curr_token.tok == STAR){
        new_union.elements[element_tos].type.ind_level++;
        get();
      }
    }

    if(new_union.elements[element_tos].type.primitive_type == DT_VOID && new_union.elements[element_tos].type.ind_level == 0) 
      error(ERR_FATAL, "Invalid type in variable");

    strcpy(new_union.elements[element_tos].name, curr_token.token_str);
    new_union.elements[element_tos].type.dims[0] = 0;
    get();
    // checks if this is a array declaration
    int dim = 0;
    if(curr_token.tok == OPENING_BRACKET){
      while(curr_token.tok == OPENING_BRACKET){
        get();
        if(curr_token.tok_type != INTEGER_CONST) error(ERR_FATAL, "Constant expected");
        new_union.elements[element_tos].type.dims[dim] = atoi(curr_token.token_str);
        get();
        if(curr_token.tok != CLOSING_BRACKET) error(ERR_FATAL, "Closing brackets expected");
        get();
        dim++;
      }
      new_union.elements[element_tos].type.dims[dim] = 0; // sets the last dimention to 0, to mark the end of the list
    }
    element_tos++;
    get();
    if(curr_token.tok != CLOSING_BRACE) back();
  } while(curr_token.tok != CLOSING_BRACE);
  
  new_union.elements[element_tos].name[0] = '\0'; // end elements list
  union_table[curr_struct_enum_union_id] = new_union; 

  get();

  if(curr_token.tok_type == IDENTIFIER && union_is_embedded){
    back();
  }
  else if (curr_token.tok_type == IDENTIFIER){ // declare variables if present
    back();
    declare_union_global_vars(curr_struct_enum_union_id);
  }
  else if(curr_token.tok != SEMICOLON) error(ERR_FATAL, "Semicolon expected after union declaration.");

  return curr_struct_enum_union_id; // return struct_enum_union_id
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
  int curr_struct_enum_union_id;
  int struct_enum_union_id;
  t_struct new_struct;
  int struct_is_embedded = 0;
  int typedef_id;

  if(struct_table_tos == MAX_STRUCT_DECLARATIONS) error(ERR_FATAL, "Max number of struct declarations reached");
  
  curr_struct_enum_union_id = struct_table_tos;
  get(); // 'struct'
  if(curr_token.tok != OPENING_BRACE) get(); // try getting struct name, but only if the current curr_token.token_str is not a brace, which means we are inside a struct declaration already and one of the members was an implicit struct that had no name, but is an elememnt of a previous struct
  if(curr_token.tok_type == IDENTIFIER){
    strcpy(new_struct.name, curr_token.token_str);
    strcpy(struct_table[struct_table_tos].name, curr_token.token_str);
    get(); // '{'
    if(curr_token.tok != OPENING_BRACE) error(ERR_FATAL, "Opening braces expected");
    // Add the new struct to the struct table prematurely so that any elements in this struct that are pointers of this struct type can be recognized by a search
    struct_table_tos++;
  }
  else if(curr_token.tok == OPENING_BRACE){ // implicit struct declaration inside a struct itself
    struct_is_embedded = 1;
  // assign a null string to the struct name then
    *new_struct.name = '\0'; // okay to do since we dont use struct names as the end point of search loops. we use 'struct_table_tos'
    struct_table_tos++;
  }

  element_tos = 0;
  do{
    if(element_tos == MAX_STRUCT_ELEMENTS) error(ERR_FATAL, "Max number of struct elements reached");
    get();
    if((typedef_id = search_typedef(curr_token.token_str)) != -1){
      new_struct.elements[element_tos].type = typedef_table[typedef_id].type;
      get();
    }
    else{
      new_struct.elements[element_tos].type.sign_modifier = SIGNMOD_SIGNED; // set as signed by default
      new_struct.elements[element_tos].type.size_modifier = SIZEMOD_NORMAL; // set as signed by default
      while(curr_token.tok == SIGNED || curr_token.tok == UNSIGNED || curr_token.tok == LONG || curr_token.tok == SHORT){
            if(curr_token.tok == SIGNED)   new_struct.elements[element_tos].type.sign_modifier = SIGNMOD_SIGNED;
        else if(curr_token.tok == UNSIGNED) new_struct.elements[element_tos].type.sign_modifier = SIGNMOD_UNSIGNED;
        else if(curr_token.tok == SHORT)    new_struct.elements[element_tos].type.size_modifier   = SIZEMOD_SHORT;
        else if(curr_token.tok == LONG)     new_struct.elements[element_tos].type.size_modifier   = SIZEMOD_LONG;
        get();
      }
      new_struct.elements[element_tos].type.primitive_type = get_primitive_type_from_tok();
      new_struct.elements[element_tos].type.struct_enum_union_id = -1;
      if(new_struct.elements[element_tos].type.primitive_type == DT_STRUCT){
        get();
        if(curr_token.tok == OPENING_BRACE){ // internal struct declaration!
          back();
          struct_enum_union_id = declare_struct();
          get(); // get element name
        }
        else{
          if((struct_enum_union_id = search_struct(curr_token.token_str)) == -1) error(ERR_FATAL, "undeclared struct");
          get();
        }
        new_struct.elements[element_tos].type.struct_enum_union_id = struct_enum_union_id;
      }
      else if(new_struct.elements[element_tos].type.primitive_type == DT_UNION){
        get();
        if(curr_token.tok == OPENING_BRACE){ // internal union declaration!
          back();
          struct_enum_union_id = declare_union();
          get(); // get element name
        }
        else{
          if((struct_enum_union_id = search_union(curr_token.token_str)) == -1) error(ERR_FATAL, "undeclared union");
          get();
        }
        new_struct.elements[element_tos].type.struct_enum_union_id = struct_enum_union_id;
      }
      else if(new_struct.elements[element_tos].type.primitive_type == DT_ENUM){
        get();
        if(curr_token.tok == OPENING_BRACE){ // internal enum declaration!
          back();
          struct_enum_union_id = declare_enum();
          get(); // get element name
        }
        else{
          if((struct_enum_union_id = search_enum(curr_token.token_str)) == -1) error(ERR_FATAL, "undeclared enum");
          get();
        }
        new_struct.elements[element_tos].type.struct_enum_union_id = struct_enum_union_id;
      }
      else get();

      new_struct.elements[element_tos].type.ind_level = 0;
      while(curr_token.tok == STAR){
        new_struct.elements[element_tos].type.ind_level++;
        get();
      }
    }

    if(new_struct.elements[element_tos].type.primitive_type == DT_VOID && new_struct.elements[element_tos].type.ind_level == 0) 
      error(ERR_FATAL, "Invalid type in variable");

    strcpy(new_struct.elements[element_tos].name, curr_token.token_str);
    new_struct.elements[element_tos].type.dims[0] = 0;
    get();
    // checks if this is a array declaration
    int dim = 0;
    if(curr_token.tok == OPENING_BRACKET){
      while(curr_token.tok == OPENING_BRACKET){
        get();
        if(curr_token.tok_type != INTEGER_CONST) error(ERR_FATAL, "Constant expected");
        new_struct.elements[element_tos].type.dims[dim] = atoi(curr_token.token_str);
        get();
        if(curr_token.tok != CLOSING_BRACKET) error(ERR_FATAL, "Closing brackets expected");
        get();
        dim++;
      }
      new_struct.elements[element_tos].type.dims[dim] = 0; // sets the last dimention to 0, to mark the end of the list
    }
    element_tos++;
    get();
    if(curr_token.tok != CLOSING_BRACE) back();
  } while(curr_token.tok != CLOSING_BRACE);
  
  new_struct.elements[element_tos].name[0] = '\0'; // end elements list
  struct_table[curr_struct_enum_union_id] = new_struct; 

  get();

  if(curr_token.tok_type == IDENTIFIER && struct_is_embedded){
    back();
  }
  else if (curr_token.tok_type == IDENTIFIER){ // declare variables if present
    back();
    declare_struct_global_vars(curr_struct_enum_union_id);
  }
  else if(curr_token.tok != SEMICOLON) error(ERR_FATAL, "Semicolon expected after struct declaration.");

  return curr_struct_enum_union_id; // return struct_enum_union_id
}

int insert_var_name(char *name, char array[32][ID_LEN]){
  int i;
  for(i = 0; i < 32; i++){
    if(array[i][0] == '\0'){
      strcpy(array[i], name);
      return i;
    }
  }
  error(ERR_FATAL, "array that contains names of local variables is too small to hold the next variable name.");
}

int undeclare_local(char *name){
  int i;
  for(i = 0; i < function_table[current_func_id].local_var_tos; i++){
    if(!strcmp(function_table[current_func_id].local_vars[i].name, name)){
      function_table[current_func_id].local_vars[i].name[0] = '\0';
      return i; // return var index
    }
  }
  return -1; // var not actually found
}

int declare_local(void){                        
  t_var new_var = {0};
  char *temp_prog;
  int total_sp = 0;
  uint8_t is_static, is_const, is_register, is_volatile;
  char var_names[32][ID_LEN] = {0};
  int dim = 0;

  is_register = 0;
  is_static   = 0;
  is_volatile = 0;
  is_const    = 0;
  get();
  if(curr_token.tok == STATIC   || curr_token.tok == CONST || 
     curr_token.tok == REGISTER || curr_token.tok == VOLATILE
  ){
    while(curr_token.tok == STATIC   || curr_token.tok == CONST || 
          curr_token.tok == REGISTER || curr_token.tok == VOLATILE
    ){
      if(curr_token.tok == REGISTER)      is_register = TRUE;
      else if(curr_token.tok == VOLATILE) is_volatile = TRUE;
      else if(curr_token.tok == STATIC)   is_static = TRUE;
      else if(curr_token.tok == CONST)    is_const = TRUE;
      get();
    }
    back();
  }
  else back();
  new_var.type = get_type();
  do{
    if(function_table[current_func_id].local_var_tos == MAX_LOCAL_VARS) error(ERR_FATAL, "Local var declaration limit reached");
    new_var.is_parameter     = FALSE;
    new_var.is_static        = is_static;
    new_var.is_volatile      = is_volatile;
    new_var.is_register      = is_register;
    new_var.type.is_constant = is_const;
    new_var.function_id      = current_func_id; // set variable owner function
// **************** checks whether this is a pointer declaration *******************************
    new_var.type.ind_level = 0;
    get();
    while(curr_token.tok == STAR){
      new_var.type.ind_level++;
      get();
    }    
// *********************************************************************************************
    if(curr_token.tok_type != IDENTIFIER) error(ERR_FATAL, "Identifier expected");
    if(local_var_exists(curr_token.token_str) != -1) 
      error(ERR_FATAL, "Duplicate local variable: %s", curr_token.token_str);
    snprintf(new_var.name, sizeof(new_var.name), "%.125s", curr_token.token_str);
    insert_var_name(curr_token.token_str, var_names);
    get();

    // checks if this is a array declaration
    dim = 0;
    new_var.type.dims[0] = 0; // in case its not a array, this signals that fact
    if(curr_token.tok == OPENING_BRACKET){
      while(curr_token.tok == OPENING_BRACKET){
        get();
        if(curr_token.tok == CLOSING_BRACKET){ // variable length array
          int fixed_part_size = 1, initialization_size;
          temp_prog = prog;
          get();
          if(curr_token.tok == OPENING_BRACKET){
            do{
              get();
              fixed_part_size = fixed_part_size * curr_token.int_const;
              get();
              expect(CLOSING_BRACKET, "Closing brackets expected");
              get();
            } while(curr_token.tok == OPENING_BRACKET);
          }
          back();
          initialization_size = find_array_initialization_size(new_var.type.size_modifier);
          new_var.type.dims[dim] = (int)ceil((float)initialization_size / (float)fixed_part_size);
          prog = temp_prog;
        }
        else{
          new_var.type.dims[dim] = atoi(curr_token.token_str);
          get();
          if(curr_token.tok != CLOSING_BRACKET) error(ERR_FATAL, "Closing brackets expected");
        }
        get();
        dim++;
      }
      new_var.type.dims[dim] = 0; // sets the last variable dimention to 0, to mark the end of the list
    }

    if(!new_var.is_static){
      // this is used to position local variables correctly relative to BP.
      // whenever a new function is parsed, this is reset to 0.
      // then inside the function it can increase according to how many local vars there are.
      new_var.bp_offset = current_function_var_bp_offset - get_total_type_size(new_var.type) + 1;
      current_function_var_bp_offset -= get_total_type_size(new_var.type);
      total_sp += get_total_type_size(new_var.type);
    }

    emitln("", "  sub sp, %d", get_total_type_size(new_var.type));

    // assigns the new variable to the local stack
    function_table[current_func_id].local_vars[function_table[current_func_id].local_var_tos] = new_var;    
    function_table[current_func_id].local_var_tos++;

    if(new_var.is_static){
      if(curr_token.tok == ASSIGNMENT)
        emit_static_var_initialization(&new_var);
      else{
        if(new_var.type.dims[0] > 0 || new_var.type.primitive_type == DT_STRUCT || new_var.type.primitive_type == DT_UNION){
          emit_data("st_%s_%s_dt: .fill %u, 0\n", function_table[current_func_id].name, new_var.name, get_total_type_size(new_var.type));
          //emit_data("st_%s_%s_: .dw st_%s_%s_dt\n", function_table[current_func_id].name, new_var.name, function_table[current_func_id].name, new_var.name);
        }
        else
          emit_data("st_%s_%s: .fill %u, 0\n", function_table[current_func_id].name, new_var.name, get_total_type_size(new_var.type));
      }
    }
    else{
      if(curr_token.tok == ASSIGNMENT){
        if(is_array(new_var.type)){
          error(ERR_WARNING, "Warning: Skipping initialization of local variable array '%s' (not yet implemented).", new_var.name);
          do{
            get();
          } while(curr_token.tok != SEMICOLON);
        }
        else{
          emitln("", "; --- START LOCAL VAR INITIALIZATION");
          t_type init_expr;
          emit_var_addr_into_d(new_var.name);
          emitln("", "  push d");
          init_expr = parse_expr();

          emitln("", "  pop d");
          switch(new_var.type.primitive_type){
            case DT_CHAR:
              if(new_var.type.ind_level > 0){
                emitln("", "  mov [d], b");
              }
              else{
                  emitln("", "  mov [d], bl");
              }
              break;
            case DT_INT:
              if(new_var.type.ind_level == 0 && new_var.type.size_modifier == SIZEMOD_LONG){
                if(init_expr.primitive_type == DT_INT && init_expr.ind_level == 0 && init_expr.size_modifier == SIZEMOD_LONG){
                  emitln("", "  mov [d], b");
                  emitln("", "  mov b, c");
                  emitln("", "  mov [d + 2], b");
                }
                else{
                  if(init_expr.primitive_type == DT_CHAR && init_expr.ind_level == 0){
                    emitln("", "  snex b");
                    emitln("", "  mov [d], b");
                    emitln("", "  mov b, 0");
                    emitln("", "  mov [d + 2], b");
                  }
                  else{
                    emitln("", "  mov [d], b");
                    emitln("", "  mov b, 0");
                    emitln("", "  mov [d + 2], b");
                  }
                } 
              }
              else{
                emitln("", "  mov [d], b");
              }
              break;
            case DT_STRUCT:
            case DT_UNION:
              emitln("", "  mov si, b");
              emitln("", "  mov di, d");
              emitln("", "  mov c, %d", get_total_type_size(init_expr));
              emitln("", "  rep movsb");
              break;
            default:
              emitln("", "  mov [d], b");
          }
          emitln("", "; --- END LOCAL VAR INITIALIZATION");
        }
      }
    }
  } while(curr_token.tok == COMMA);
  if(curr_token.tok != SEMICOLON) error(ERR_FATAL, "Semicolon expected");
/*
  for creating local variables created with commas such as int a, b, c
  by decreasing SP with the total offset.
  commented out in favour of the oither way of doing it by subtrckng SP indivisually for each instance. 

  emit("  sub sp, %d ; ", total_sp, new_var.name);
  for(int i = 0; var_names[i][0]; i++){
    if(var_names[i][0]){
      emit("%s", var_names[i]);
      if(var_names[i + 1][0]) emit(", ");
    }
  }
  emitln("", "");
  */
  return total_sp;
} 

// void (*fp)();
// void (*fp)(void);
// void (*fp)(int, char);
void declare_global(void){
  char *temp_prog;
  int dim;
  t_type type;
  uint8_t is_static, is_const, is_volatile;
  int fixed_part_size;
  int initialization_size;

  is_volatile = FALSE;
  is_static   = FALSE;
  is_const    = FALSE;
  get();
  if(curr_token.tok == STATIC || curr_token.tok == CONST ||
     curr_token.tok == VOLATILE
  ){
    while(curr_token.tok == STATIC || curr_token.tok == CONST ||
          curr_token.tok == VOLATILE
    ){
      if(curr_token.tok == STATIC) is_static          = TRUE;
      else if(curr_token.tok == VOLATILE) is_volatile = TRUE;
      else if(curr_token.tok == CONST) is_const       = TRUE;
      get();
    }
    back();
  }
  else back();
  type = get_type();
  do{
    if(global_var_tos == MAX_GLOBAL_VARS) error(ERR_FATAL, "Max number of global variable declarations exceeded");
    global_var_table[global_var_tos].type             = type;
    global_var_table[global_var_tos].is_register      = FALSE;
    global_var_table[global_var_tos].is_volatile      = is_volatile;
    global_var_table[global_var_tos].is_static        = is_static;
    global_var_table[global_var_tos].type.is_constant = is_const;
    get();
// **************** checks whether this is a pointer declaration *******************************
    global_var_table[global_var_tos].type.ind_level = 0;
    while(curr_token.tok == STAR){
      global_var_table[global_var_tos].type.ind_level++;
      get();
    }
// *********************************************************************************************
    if(curr_token.tok_type != IDENTIFIER) error(ERR_FATAL, "Identifier expected in global variable declaration,");
    if(global_var_table[global_var_tos].type.primitive_type == DT_VOID && global_var_table[global_var_tos].type.ind_level == 0) 
      error(ERR_FATAL, "Invalid type in variable: %s", curr_token.token_str);

    // checks if there is another global variable with the same name
    if(search_global_var(curr_token.token_str) != -1) 
      error(ERR_FATAL, "Duplicate global variable: %s", curr_token.token_str);
    
    global_var_table[global_var_tos].type.dims[0] = 0;
    strcpy(global_var_table[global_var_tos].name, curr_token.token_str);
    get();
    // checks if this is a array declaration
    dim = 0;
    if(curr_token.tok == OPENING_BRACKET){
      while(curr_token.tok == OPENING_BRACKET){
        get();
        if(curr_token.tok == CLOSING_BRACKET){ // variable length array
          fixed_part_size = 1;
          temp_prog = prog;
          get();
          if(curr_token.tok == OPENING_BRACKET){
            do{
              get();
              fixed_part_size = fixed_part_size * curr_token.int_const;
              get();
              expect(CLOSING_BRACKET, "Closing brackets expected in global variable declaration.");
              get();
            } while(curr_token.tok == OPENING_BRACKET);
          }
          back();
          initialization_size = find_array_initialization_size(global_var_table[global_var_tos].type.size_modifier);
          global_var_table[global_var_tos].type.dims[dim] = (int)ceil((float)initialization_size / (float)fixed_part_size);
          prog = temp_prog;
        }
        else{
          global_var_table[global_var_tos].type.dims[dim] = atoi(curr_token.token_str);
          get();
          if(curr_token.tok != CLOSING_BRACKET) error(ERR_FATAL, "Closing brackets expected in global variable declaration.");
        }
        get();
        dim++;
      }
      global_var_table[global_var_tos].type.dims[dim] = 0; // sets the last variable dimention to 0, to mark the end of the list
    }

    // _data section for var is emmitted if:
    // ind_level == 1 && data.primitive_type_char
    // var is a array (dims > 0)
    // checks for variable initialization
    if(curr_token.tok == ASSIGNMENT){
      emit_global_var_initialization(&global_var_table[global_var_tos]);
    }
    else{ // no assignment!
      if(dim > 0 || 
         global_var_table[global_var_tos].type.ind_level == 0 && 
        (global_var_table[global_var_tos].type.primitive_type == DT_STRUCT || global_var_table[global_var_tos].type.primitive_type == DT_UNION)
      ){
        emit_data("_%s_data: .fill %u, 0\n", global_var_table[global_var_tos].name, get_total_type_size(global_var_table[global_var_tos].type));
      }
      else{
        emit_data("_%s: .fill %u, 0\n", global_var_table[global_var_tos].name, get_total_type_size(global_var_table[global_var_tos].type));
      }
    }
    global_var_tos++;  
  } while(curr_token.tok == COMMA);

  if(curr_token.tok != SEMICOLON) error(ERR_FATAL, "Semicolon expected in global variable declaration.");
}

// enum my_enum {item1, item2, item3};
int declare_enum(void){
  int element_tos;
  int value;

  if(enum_table_tos == MAX_ENUM_DECLARATIONS) error(ERR_FATAL, "Maximum number of enumeration declarations exceeded");

  get(); // get enum name
  strcpy(enum_table[enum_table_tos].name, curr_token.token_str);
  get(); // '{'
  if(curr_token.tok != OPENING_BRACE) error(ERR_FATAL, "Opening braces expected");
  element_tos = 0;
  value = 0;

  do{
    get();
    if(curr_token.tok_type != IDENTIFIER) error(ERR_FATAL, "Identifier expected");
    strcpy(enum_table[enum_table_tos].elements[element_tos].name, curr_token.token_str);
    get();
    if(curr_token.tok == ASSIGNMENT){
      get();
      value = curr_token.int_const;
    }
    enum_table[enum_table_tos].elements[element_tos].value = value;
    value++;
    element_tos++;  
  } while(curr_token.tok == COMMA);
  
  enum_table_tos++;

  if(curr_token.tok != CLOSING_BRACE) error(ERR_FATAL, "Closing braces expected");
  get();
  if(curr_token.tok != SEMICOLON) error(ERR_FATAL, "Semicolon expected");

  return enum_table_tos - 1;
}

void declare_typedef(void){
  char *temp_prog;
  t_type type;

  if(typedef_table_tos == MAX_TYPEDEFS) error(ERR_FATAL, "Maximum number of typedefs exceeded.");

  for(int i = 0; i < MAX_MATRIX_DIMS; i++){
    type.dims[i] = 0; // clear all matrix dimensions because type is a local var and the dimensions will have garbage values
  }

  get(); 
  type.sign_modifier = SIGNMOD_SIGNED; // set as signed by default
  type.size_modifier = SIZEMOD_NORMAL; 
  while(curr_token.tok == SIGNED || curr_token.tok == UNSIGNED || curr_token.tok == SHORT || curr_token.tok == LONG || curr_token.tok == CONST){
    if(curr_token.tok == CONST) type.is_constant = TRUE;
    else if(curr_token.tok == SIGNED)   type.sign_modifier = SIGNMOD_SIGNED;
    else if(curr_token.tok == UNSIGNED) type.sign_modifier = SIGNMOD_UNSIGNED;
    else if(curr_token.tok == SHORT)    type.size_modifier = SIZEMOD_SHORT;
    else if(curr_token.tok == LONG)     type.size_modifier = SIZEMOD_LONG;
    get();
  }
  type.primitive_type = get_primitive_type_from_tok();
  type.struct_enum_union_id = -1;
  if(type.primitive_type == DT_STRUCT){ // check if this is a struct
    get();
    type.struct_enum_union_id = search_struct(curr_token.token_str);
    if(type.struct_enum_union_id == -1) error(ERR_FATAL, "Undeclared struct in typedef declaration: %s", curr_token.token_str);
  }
  else if(type.primitive_type == DT_ENUM){ // check if this is an enum 
    get();
    type.struct_enum_union_id = search_enum(curr_token.token_str);
    if(type.struct_enum_union_id == -1) error(ERR_FATAL, "Undeclared enum in typedef declaration: %s", curr_token.token_str);
  }

  get();
// **************** checks whether this is a pointer declaration *******************************
  type.ind_level = 0;
  while(curr_token.tok == STAR){
    type.ind_level++;
    get();
  }
// *********************************************************************************************
  if(curr_token.tok_type != IDENTIFIER) error(ERR_FATAL, "Identifier expected");
  if(type.primitive_type == DT_VOID && type.ind_level == 0) error(ERR_FATAL, "Invalid type in variable: %s", curr_token.token_str);

  type.dims[0] = 0;
  strcpy(typedef_table[typedef_table_tos].name, curr_token.token_str);
  get();
  // checks if this is a array declaration
  int dim = 0;
  if(curr_token.tok == OPENING_BRACKET){
    while(curr_token.tok == OPENING_BRACKET){
      get();
      if(curr_token.tok == CLOSING_BRACKET){ // variable length array
        int fixed_part_size = 1;
        int initialization_size;
        temp_prog = prog;
        get();
        if(curr_token.tok == OPENING_BRACKET){
          do{
            get();
            fixed_part_size = fixed_part_size * curr_token.int_const;
            get();
            expect(CLOSING_BRACKET, "Closing brackets expected");
            get();
          } while(curr_token.tok == OPENING_BRACKET);
        }
        back();
        initialization_size = find_array_initialization_size(type.size_modifier);
        type.dims[dim] = (int)ceil((float)initialization_size / (float)fixed_part_size);
        prog = temp_prog;
      }
      else{
        type.dims[dim] = atoi(curr_token.token_str);
        get();
        if(curr_token.tok != CLOSING_BRACKET) error(ERR_FATAL, "Closing brackets expected");
      }
      get();
      dim++;
    }
  }
  typedef_table[typedef_table_tos].type = type;
  typedef_table_tos++;
  expect(SEMICOLON, "Semicolon expected.");
}

void declare_union_global_vars(int union_id){
  int ind_level;
  char is_constant = FALSE;

  do{
    if(global_var_tos == MAX_GLOBAL_VARS) error(ERR_FATAL, "Global variable declaration limit exceeded");
    global_var_table[global_var_tos].type.is_constant = is_constant;
    get();
// **************** checks whether this is a pointer declaration *******************************
    ind_level = 0;
    while(curr_token.tok == STAR){
      ind_level++;
      get();
    }
// *********************************************************************************************
    if(curr_token.tok_type != IDENTIFIER) error(ERR_FATAL, "Identifier expected");

    // checks if there is another global variable with the same name
    if(search_global_var(curr_token.token_str) != -1) error(ERR_FATAL, "Duplicate global variable");
    
    global_var_table[global_var_tos].type.primitive_type = DT_STRUCT;
    global_var_table[global_var_tos].type.ind_level = ind_level;
    global_var_table[global_var_tos].type.struct_enum_union_id = union_id;
    global_var_table[global_var_tos].type.dims[0] = 0;
    strcpy(global_var_table[global_var_tos].name, curr_token.token_str);
    get();
    // checks if this is a array declaration
    int dim = 0;
    if(curr_token.tok == OPENING_BRACKET){
      while(curr_token.tok == OPENING_BRACKET){
        get();
        if(curr_token.tok == CLOSING_BRACKET){ // variable length array
          int fixed_part_size = 1, initialization_size;
          get();
          if(curr_token.tok == OPENING_BRACKET){
            do{
              get();
              fixed_part_size = fixed_part_size * curr_token.int_const;
              get();
              expect(CLOSING_BRACKET, "Closing brackets expected");
              get();
            } while(curr_token.tok == OPENING_BRACKET);
          }
          back();
          initialization_size = find_array_initialization_size(global_var_table[global_var_tos].type.size_modifier);
          global_var_table[global_var_tos].type.dims[dim] = (int)ceil((float)initialization_size / (float)fixed_part_size);
          get();
          if(curr_token.tok != SEMICOLON) error(ERR_FATAL, "Semicolon expected");
          break;
        }
        else{
          global_var_table[global_var_tos].type.dims[dim] = atoi(curr_token.token_str);
          get();
          if(curr_token.tok != CLOSING_BRACKET) error(ERR_FATAL, "Closing brackets expected");
        }
        get();
        dim++;
      }
      global_var_table[global_var_tos].type.dims[dim] = 0; // sets the last variable dimention to 0, to mark the end of the list
    }

    if(curr_token.tok == ASSIGNMENT){
      int array_size = 1;
      array_size = get_num_array_elements(global_var_table[global_var_tos].type);
      get();
      expect(OPENING_BRACE, "Opening braces expected in union initialization.");
      emit_data("_%s_data:\n", global_var_table[global_var_tos].name);
      parse_union_initialization_data(union_id, array_size);
      get();
    }
    else{
      if(dim > 0 || (global_var_table[global_var_tos].type.primitive_type == DT_STRUCT && global_var_table[global_var_tos].type.ind_level == 0)){
        emit_data("_%s_data: .fill %u, 0\n", global_var_table[global_var_tos].name, get_total_type_size(global_var_table[global_var_tos].type));
      }
      else
        emit_data("_%s: .fill %u, 0\n", global_var_table[global_var_tos].name, get_total_type_size(global_var_table[global_var_tos].type));
    }

    global_var_tos++;  

    get();
  } while(curr_token.tok == COMMA);
  back();
}

// declare struct variables right after struct declaration
void declare_struct_global_vars(int struct_id){
  int ind_level;
  char is_constant = FALSE;

  do{
    if(global_var_tos == MAX_GLOBAL_VARS) error(ERR_FATAL, "Global variable declaration limit exceeded");
    global_var_table[global_var_tos].type.is_constant = is_constant;
    get();
// **************** checks whether this is a pointer declaration *******************************
    ind_level = 0;
    while(curr_token.tok == STAR){
      ind_level++;
      get();
    }
// *********************************************************************************************
    if(curr_token.tok_type != IDENTIFIER) error(ERR_FATAL, "Identifier expected");

    // checks if there is another global variable with the same name
    if(search_global_var(curr_token.token_str) != -1) error(ERR_FATAL, "Duplicate global variable");
    
    global_var_table[global_var_tos].type.primitive_type = DT_STRUCT;
    global_var_table[global_var_tos].type.ind_level = ind_level;
    global_var_table[global_var_tos].type.struct_enum_union_id = struct_id;
    global_var_table[global_var_tos].type.dims[0] = 0;
    strcpy(global_var_table[global_var_tos].name, curr_token.token_str);
    get();
    // checks if this is a array declaration
    int dim = 0;
    if(curr_token.tok == OPENING_BRACKET){
      while(curr_token.tok == OPENING_BRACKET){
        get();
        if(curr_token.tok == CLOSING_BRACKET){ // variable length array
          int fixed_part_size = 1, initialization_size;
          get();
          if(curr_token.tok == OPENING_BRACKET){
            do{
              get();
              fixed_part_size = fixed_part_size * curr_token.int_const;
              get();
              expect(CLOSING_BRACKET, "Closing brackets expected");
              get();
            } while(curr_token.tok == OPENING_BRACKET);
          }
          back();
          initialization_size = find_array_initialization_size(global_var_table[global_var_tos].type.size_modifier);
          global_var_table[global_var_tos].type.dims[dim] = (int)ceil((float)initialization_size / (float)fixed_part_size);
          get();
          if(curr_token.tok != SEMICOLON) error(ERR_FATAL, "Semicolon expected.");
          break;
        }
        else{
          global_var_table[global_var_tos].type.dims[dim] = atoi(curr_token.token_str);
          get();
          if(curr_token.tok != CLOSING_BRACKET) error(ERR_FATAL, "Closing brackets expected");
        }
        get();
        dim++;
      }
      global_var_table[global_var_tos].type.dims[dim] = 0; // sets the last variable dimention to 0, to mark the end of the list

    }

    if(curr_token.tok == ASSIGNMENT){
      int array_size = 1;
      array_size = get_num_array_elements(global_var_table[global_var_tos].type);
      get();
      expect(OPENING_BRACE, "Opening braces expected in struct initialization.");
      emit_data("_%s_data:\n", global_var_table[global_var_tos].name);
      parse_struct_initialization_data(struct_id, array_size);
      get();
    }
    else{
      if(dim > 0 || (global_var_table[global_var_tos].type.primitive_type == DT_STRUCT && global_var_table[global_var_tos].type.ind_level == 0)){
        emit_data("_%s_data: .fill %u, 0\n", global_var_table[global_var_tos].name, get_total_type_size(global_var_table[global_var_tos].type));
      }
      else{
        emit_data("_%s: .fill %u, 0\n", global_var_table[global_var_tos].name, get_total_type_size(global_var_table[global_var_tos].type));
      }
    }

    global_var_tos++;  

    get();
  } while(curr_token.tok == COMMA);
  back();
}

void declare_func(void){
  int bp_offset; // for each parameter, keep the running offset of that parameter.
  char *temp_prog, *prog_before_void_tok;
  int total_parameter_bytes;
  char is_main;
  char add_argc_argv;
  int dimension;
  int typedef_id;

  add_argc_argv = FALSE;
  is_main = FALSE;

  if(function_table_tos == MAX_USER_FUNC - 1) error(ERR_FATAL, "Maximum number of function declarations exceeded. Max: %d", MAX_USER_FUNC);

  get();
  if(curr_token.tok == STATIC){
    function_table[function_table_tos].is_static = TRUE;
    get();
  }
  else 
    function_table[function_table_tos].is_static = FALSE;

  if((typedef_id = search_typedef(curr_token.token_str)) != -1){
    function_table[function_table_tos].return_type = typedef_table[typedef_id].type;
  }
  else{
    function_table[function_table_tos].return_type.sign_modifier = SIGNMOD_SIGNED; // set as signed by default
    function_table[function_table_tos].return_type.size_modifier = SIZEMOD_NORMAL; 
    while(curr_token.tok == SIGNED || curr_token.tok == UNSIGNED || 
          curr_token.tok == SHORT || curr_token.tok == LONG
    ){
           if(curr_token.tok == SIGNED)   function_table[function_table_tos].return_type.sign_modifier = SIGNMOD_SIGNED;
      else if(curr_token.tok == UNSIGNED) function_table[function_table_tos].return_type.sign_modifier = SIGNMOD_UNSIGNED;
      else if(curr_token.tok == SHORT)    function_table[function_table_tos].return_type.size_modifier = SIZEMOD_SHORT;
      else if(curr_token.tok == LONG)     function_table[function_table_tos].return_type.size_modifier = SIZEMOD_LONG;
      get();
    }
    function_table[function_table_tos].return_type.primitive_type = get_primitive_type_from_tok();
    function_table[function_table_tos].return_type.struct_enum_union_id = -1;
    if(function_table[function_table_tos].return_type.primitive_type == DT_STRUCT){ // check if this is a struct
      get();
      function_table[function_table_tos].return_type.struct_enum_union_id = search_struct(curr_token.token_str);
      if(function_table[function_table_tos].return_type.struct_enum_union_id == -1) error(ERR_FATAL, "Undeclared struct '%s' in function return type", curr_token.token_str);
    }
    else if(function_table[function_table_tos].return_type.primitive_type == DT_ENUM){
      get();
      function_table[function_table_tos].return_type.struct_enum_union_id = search_enum(curr_token.token_str);
      if(function_table[function_table_tos].return_type.struct_enum_union_id == -1) error(ERR_FATAL, "Undeclared enum '%s' in function return type", curr_token.token_str);
    }
  }

  get();
  while(curr_token.tok == STAR){
    function_table[function_table_tos].return_type.ind_level++;
    get();
  }

  strcpy(function_table[function_table_tos].name, curr_token.token_str);
  if(!strcmp(curr_token.token_str, "main")) is_main = TRUE;
  get(); // gets past "("

  function_table[function_table_tos].has_var_args = FALSE;
  function_table[function_table_tos].local_var_tos = 0;
  function_table[function_table_tos].num_fixed_args = 0;
  prog_before_void_tok = prog;
  get();
  if(curr_token.tok == CLOSING_PAREN){
    goto void_arguments;
  }
  else{
    if(curr_token.tok == VOID){
      get();
      if(curr_token.tok == CLOSING_PAREN){
        goto void_arguments;
      }
      else{
        prog = prog_before_void_tok;
      }
    }
    else back();
    total_parameter_bytes = get_total_func_fixed_param_size();
    function_table[function_table_tos].total_parameter_size = total_parameter_bytes;
    bp_offset = 5; // +4 to account for pc and bp in the stack
    //bp_offset = total_parameter_bytes + 4; // +4 to account for pc and bp in the stack
    prog = prog_before_void_tok;
    do{
      dimension = 0;
      // set as parameter so that we can tell that if a array is declared, the argument is also a pointer
      // even though it may not be declared with any '*' curr_token.token_strs;
      function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].is_parameter = TRUE;
      function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].is_volatile = FALSE;
      temp_prog = prog;
      get();
      if(curr_token.tok == VAR_ARG_DOTS){
        function_table[function_table_tos].has_var_args = TRUE;
        get();
        break; // exit parameter loop as '...' has to be the last curr_token.token_str in the param definition
      }

      while(curr_token.tok == VOLATILE || curr_token.tok == CONST){
              if(curr_token.tok == VOLATILE) function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].is_volatile = TRUE;
        else if(curr_token.tok == CONST) function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].type.is_constant = TRUE;
        get();
      }

      if((typedef_id = search_typedef(curr_token.token_str)) != -1){
        function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].type = typedef_table[typedef_id].type;
        get();
      }
      else{
        function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].type.sign_modifier = SIGNMOD_SIGNED; // set as signed by default
        function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].type.size_modifier = SIZEMOD_NORMAL; 
        while(curr_token.tok == SIGNED || curr_token.tok == UNSIGNED || 
              curr_token.tok == SHORT  || curr_token.tok == LONG      ||
              curr_token.tok == VOLATILE
        ){
               if(curr_token.tok == VOLATILE) function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].is_volatile = TRUE;
          else if(curr_token.tok == SIGNED)   function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].type.sign_modifier = SIGNMOD_SIGNED;
          else if(curr_token.tok == UNSIGNED) function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].type.sign_modifier = SIGNMOD_UNSIGNED;
          else if(curr_token.tok == SHORT)    function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].type.size_modifier = SIZEMOD_SHORT;
          else if(curr_token.tok == LONG)     function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].type.size_modifier = SIZEMOD_LONG;
          get();
        }
        if(curr_token.tok != VOID   && curr_token.tok != CHAR   && 
           curr_token.tok != INT    && curr_token.tok != FLOAT  && 
           curr_token.tok != DOUBLE && curr_token.tok != STRUCT && curr_token.tok != ENUM) 
          error(ERR_FATAL, "unknown or undeclared type given in argument declaration for function: %s", function_table[function_table_tos].name);
        // gets the parameter type
        function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].type.primitive_type = get_primitive_type_from_tok();
        function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].type.struct_enum_union_id = -1;
        if(function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].type.primitive_type == DT_STRUCT){ // check if this is a struct
          get();
          function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].type.struct_enum_union_id = search_struct(curr_token.token_str);
          if(function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].type.struct_enum_union_id == -1) 
            error(ERR_FATAL, "Undeclared struct: %s", curr_token.token_str);
        }
        else if(function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].type.primitive_type == DT_ENUM){ 
          get();
          function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].type.struct_enum_union_id = search_enum(curr_token.token_str);
          if(function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].type.struct_enum_union_id == -1) 
            error(ERR_FATAL, "Undeclared enum: %s", curr_token.token_str);
        }
        get();
      }

      while(curr_token.tok == STAR){
        function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].type.ind_level++;
        get();
      }
      if(curr_token.tok_type != IDENTIFIER) error(ERR_FATAL, "Identifier expected");
      strcpy(function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].name, curr_token.token_str);
      // Check if this is main, and argc or argv are declared
      // TODO: argc/argv need to be local to main but right now they are global
      if(is_main == TRUE && (!strcmp(curr_token.token_str, "argc") || !strcmp(curr_token.token_str, "argv"))){
        add_argc_argv = TRUE;
      }
      // checks if this is a array declaration
      get();
      function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].type.dims[0] = 0; // in case its not a array, this signals that fact
      if(curr_token.tok == OPENING_BRACKET){
        while(curr_token.tok == OPENING_BRACKET){
          get();
          if(curr_token.tok == CLOSING_BRACKET){ // dummy dimension in case this dimension is variable
            function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].type.dims[dimension] = 1;
            dimension++;
            get();
            continue;
          }
          else{
            function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].type.dims[dimension] = (uint16_t)atoi(curr_token.token_str);
            get();
            if(curr_token.tok != CLOSING_BRACKET) error(ERR_FATAL, "Closing bracket expected");
            dimension++;
            get();
          }
        }
        function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].type.dims[dimension] = 0; // sets the last variable dimention to 0, to mark the end of the list
      }
      prog = temp_prog;
      // assign the bp offset of this parameter
      function_table[function_table_tos].local_vars[function_table[function_table_tos].local_var_tos].bp_offset = bp_offset;
      bp_offset += get_param_size();

      get();
      function_table[function_table_tos].num_fixed_args++;
      function_table[function_table_tos].local_var_tos++;
    } while(curr_token.tok == COMMA);
  }
  void_arguments:
    if(curr_token.tok != CLOSING_PAREN) error(ERR_FATAL, "Closing parenthesis expected");
    function_table[function_table_tos].code_location = prog; // sets the function starting point to  just after the "(" curr_token.token_str
    get(); // gets to the "{" curr_token.token_str
    if(curr_token.tok != OPENING_BRACE) error(ERR_FATAL, "Opening curly braces expected");
    back(); // puts the "{" back so that it can be found by skip_block(0)
    function_table_tos++;
}

void declare_goto_label(void) {
}

int get_param_size(){
  int data_size;
  int struct_enum_union_id;
  t_size_modifier size_modifier;
  int typedef_id;

  data_size = 0;
  struct_enum_union_id = -1;
  size_modifier = SIZEMOD_NORMAL;  
  get();
  while(curr_token.tok == CONST  || curr_token.tok == STATIC   ||
        curr_token.tok == SIGNED || curr_token.tok == UNSIGNED ||
        curr_token.tok == SHORT  || curr_token.tok == LONG     ||
        curr_token.tok == VOLATILE
  ){
    if(curr_token.tok == LONG) size_modifier = SIZEMOD_LONG;
    get();
  }

  if((typedef_id = search_typedef(curr_token.token_str)) != -1){
    data_size = get_type_size_for_func_arg_parsing(typedef_table[typedef_id].type);
  }
  else switch(curr_token.tok){
    case VAR_ARG_DOTS:
      data_size = 0; // assign zero here as the real size will be computed when the variable arguments are pushed
      break;
    case CHAR:
      data_size = 1;
      break;
    case INT:
      if(size_modifier == SIZEMOD_LONG)
        data_size = 4;
      else  
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
      struct_enum_union_id = search_struct(curr_token.token_str);
      data_size = get_struct_size(struct_enum_union_id);
      break;
    case ENUM:
      get(); // get enum name
      data_size = 2;
      break;
    default:
      error(ERR_FATAL, "(get_param_size): unknown data type token");
  }

// FILE fp,       FILE fp)
// FILE *fp,      FILE *fp)
// int i,         int i)
  get(); // check for '*'
  if(curr_token.tok == STAR){
    data_size = 2;
    while(curr_token.tok == STAR) get();
  }

  get();
  if(curr_token.tok == OPENING_BRACKET){
    data_size = 2; // parameter is a pointer if it is an array
    while(curr_token.tok == OPENING_BRACKET){
      get();
      if(curr_token.tok == CLOSING_BRACKET){
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

int get_total_func_fixed_param_size(void){
  int total_bytes;

  total_bytes = 0;
  do{
    total_bytes += get_param_size();
    get();
  } while(curr_token.tok == COMMA);

  return total_bytes;
}

void parse_system(void){
  char *temp_prog;
  
  get();
  if(curr_token.tok != OPENING_BRACE) error(ERR_FATAL, "Opening braces expected");
  emitln("", "; --- BEGIN SYSTEM SEGMENT");
  for(;;){
    while(is_space(*prog)) prog++;
    temp_prog = prog;
    get_line();
    if(strchr(curr_token.string_const, '}')) break;
    else if(strchr(curr_token.string_const, ':') 
         || strstr(curr_token.string_const, ".include") 
         || strstr(curr_token.string_const, ".db") 
         || strstr(curr_token.string_const, ".dw") 
         || strstr(curr_token.string_const, ".equ") 
         || strstr(curr_token.string_const, ".EQU")){
      emitln("", curr_token.string_const);
    } 
    else if(strstr(curr_token.string_const, "ccmovd")){
      prog = temp_prog;
      get();  // get 'ccmovd'
      get();  // get identifier
      if(curr_token.tok_type != IDENTIFIER) error(ERR_FATAL, "Identifier expected.");
      emit_var_addr_into_d(curr_token.token_str);
    }
    else{
      emitln("", "  %s", curr_token.string_const);
    }
  }
  emitln("", "; --- END SYSTEM SEGMENT");
}

// > asgn d, shell_path
void parse_asm(void){
  char *temp_prog;
  
  get();
  if(curr_token.tok == OPENING_BRACE){
    emitln("", "; --- BEGIN INLINE ASM SEGMENT");
    for(;;){
      while(is_space(*prog)) prog++;
      temp_prog = prog;
      get_line();
      if(strchr(curr_token.string_const, '}')) break;
      else if(strchr(curr_token.string_const, ':') 
          || strstr(curr_token.string_const, ".include") 
          || strstr(curr_token.string_const, ".db") 
          || strstr(curr_token.string_const, ".dw") 
          || strstr(curr_token.string_const, ".equ") 
          || strstr(curr_token.string_const, ".EQU")){
        emitln("", curr_token.string_const);
      } 
      else if(strstr(curr_token.string_const, "ccmovd")){
        prog = temp_prog;
        get();  // get 'ccmovd'
        get();  // get identifier
        if(curr_token.tok_type != IDENTIFIER) error(ERR_FATAL, "Identifier expected.");
        emit_var_addr_into_d(curr_token.token_str);
      }
      else{
        emitln("", "  %s", curr_token.string_const);
      }
    }
    emitln("", "; --- END INLINE ASM SEGMENT");
  }
  else{
    back();
    while(is_space(*prog)) prog++;
    temp_prog = prog;
    get_line();
    if(strchr(curr_token.string_const, ':') 
        || strstr(curr_token.string_const, ".include") 
        || strstr(curr_token.string_const, ".db") 
        || strstr(curr_token.string_const, ".dw") 
        || strstr(curr_token.string_const, ".equ") 
        || strstr(curr_token.string_const, ".EQU")){
      emitln("", curr_token.string_const);
    } 
    else if(strstr(curr_token.string_const, "ccmovd")){
      prog = temp_prog;
      get();  // get 'ccmovd'
      get();  // get identifier
      if(curr_token.tok_type != IDENTIFIER) error(ERR_FATAL, "Identifier expected.");
      emit_var_addr_into_d(curr_token.token_str);
    }
    else{
      emitln("", "  %s", curr_token.string_const);
    }
  }
}

void parse_break(void){
       if(current_loop_type == FOR_LOOP)         emitln("", "  jmp _for%d_exit ; for break", current_label_index_for);
  else if(current_loop_type == WHILE_LOOP)       emitln("", "  jmp _while%d_exit ; while break", current_label_index_while);
  else if(current_loop_type == DO_LOOP)          emitln("", "  jmp _do%d_exit ; do break", current_label_index_do);
  else if(current_loop_type == SWITCH_CONSTRUCT) emitln("", "  jmp _switch%d_exit ; case break", current_label_index_switch);
  get();
}

void parse_continue(void){
       if(current_loop_type == FOR_LOOP)   emitln("", "  jmp _for%d_update ; for continue", current_label_index_for);
  else if(current_loop_type == WHILE_LOOP) emitln("", "  jmp _while%d_cond ; while continue", current_label_index_while);
  else if(current_loop_type == DO_LOOP)    emitln("", "  jmp _do%d_cond ; do continue", current_label_index_do);
  get();
}

void parse_for(void){
  char *update_loc;

  override_return_is_last_statement = TRUE;
  loop_type_stack[loop_type_tos] = current_loop_type;
  loop_type_tos++;
  current_loop_type = FOR_LOOP;
  highest_label_index++;
  label_stack_for[label_tos_for] = current_label_index_for;
  label_tos_for++;
  current_label_index_for = highest_label_index;

  get();
  if(curr_token.tok != OPENING_PAREN) error(ERR_FATAL, "Opening parenthesis expected");
  emitln("", "_for%d_init:", current_label_index_for);
  get();
  if(curr_token.tok != SEMICOLON){
    back();
    parse_expr();
  }
  if(curr_token.tok != SEMICOLON) error(ERR_FATAL, "Semicolon expected");

  emitln("", "_for%d_cond:", current_label_index_for);
  // checks for an empty condition, which means always TRUE
  get();
  if(curr_token.tok != SEMICOLON){
    back();
    parse_expr();
    if(curr_token.tok != SEMICOLON) error(ERR_FATAL, "Semicolon expected");
    emitln("", "  cmp b, 0");
    emitln("", "  je _for%d_exit", current_label_index_for);
  }

  update_loc = prog; // holds the location of incrementation part
  emitln("", "_for%d_block:", current_label_index_for);
  // gets past the update expression
  int paren = 1;
  do{
         if(*prog == '(') paren++;
    else if(*prog == ')') paren--;
    prog++;
  } while(paren && *prog);
  if(!*prog) error(ERR_FATAL, "Closing parenthesis expected");
  parse_block();
  
  emitln("", "_for%d_update:", current_label_index_for);
  prog = update_loc;
  // checks for an empty update expression
  get();
  if(curr_token.tok != CLOSING_PAREN){
    back();
    parse_expr();
  }
  emitln("", "  jmp _for%d_cond", current_label_index_for);
  skip_statements();
  emitln("", "_for%d_exit:", current_label_index_for);

  label_tos_for--;
  current_label_index_for = label_stack_for[label_tos_for];
  loop_type_tos--;
  current_loop_type = loop_type_stack[loop_type_tos];

  override_return_is_last_statement = FALSE;
}

void parse_while(void){
  override_return_is_last_statement = TRUE;
  loop_type_stack[loop_type_tos] = current_loop_type;
  loop_type_tos++;
  current_loop_type = WHILE_LOOP;
  highest_label_index++;
  label_stack_while[label_tos_while] = current_label_index_while;
  label_tos_while++;
  current_label_index_while = highest_label_index;

  emitln("", "_while%d_cond:", current_label_index_while);
  get();
  if(curr_token.tok != OPENING_PAREN) error(ERR_FATAL, "Opening parenthesis expected");
  parse_expr(); // evaluate condition
  if(curr_token.tok != CLOSING_PAREN) error(ERR_FATAL, "Closing parenthesis expected");
  emitln("", "  cmp b, 0");
  emitln("", "  je _while%d_exit", current_label_index_while);
  emitln("", "_while%d_block:", current_label_index_while);
  parse_block();  // parse while block
  emitln("", "  jmp _while%d_cond", current_label_index_while);
  emitln("", "_while%d_exit:", current_label_index_while);

  label_tos_while--;
  current_label_index_while = label_stack_while[label_tos_while];
  loop_type_tos--;
  current_loop_type = loop_type_stack[loop_type_tos];
  override_return_is_last_statement = FALSE;
}

void parse_do(void){
  override_return_is_last_statement = TRUE;
  loop_type_stack[loop_type_tos] = current_loop_type;
  loop_type_tos++;
  current_loop_type = DO_LOOP;
  highest_label_index++;
  label_stack_do[label_tos_do] = current_label_index_do;
  label_tos_do++;
  current_label_index_do = highest_label_index;

  emitln("", "_do%d_block:", current_label_index_do);
  get();
  if(curr_token.tok != OPENING_BRACE) error(ERR_FATAL, "Opening brace expected in 'do' statement.");
  back();
  parse_block();  // parse block

  emit_c_header_line();
  emitln("", "_do%d_cond:", current_label_index_do);
  get(); // get 'while'
  get();
  if(curr_token.tok != OPENING_PAREN) error(ERR_FATAL, "Opening parenthesis expected");
  parse_expr(); // evaluate condition
  if(curr_token.tok != CLOSING_PAREN) error(ERR_FATAL, "Closing parenthesis expected");
  emitln("", "  cmp b, 1");
  emitln("", "  je _do%d_block", current_label_index_do);

  emitln("", "_do%d_exit:", current_label_index_do);

  get();
  if(curr_token.tok != SEMICOLON) error(ERR_FATAL, "Semicolon expected");

  label_tos_do--;
  current_label_index_do = label_stack_do[label_tos_do];
  loop_type_tos--;
  current_loop_type = loop_type_stack[loop_type_tos];
  override_return_is_last_statement = FALSE;
}

void parse_goto(void){
  int i;
  char label[256];

  get();
  if(curr_token.tok_type != IDENTIFIER) error(ERR_FATAL, "Identifier expected");
  for(i = 0; i < function_table[current_func_id].goto_labels_table_tos; i++){
    snprintf(label, sizeof(label), "%.125s_%.125s", function_table[current_func_id].name, curr_token.token_str);
    if(!strcmp(function_table[current_func_id].goto_labels_table[i], label)){
      emitln("", "  jmp %s", label);
      get();
      if(curr_token.tok != SEMICOLON) error(ERR_FATAL, "Semicolon expected");
      return;
    }
  }
  error(ERR_FATAL, "(parse_goto) Undeclared identifier: %s", curr_token.token_str);
}

void parse_if(void){
  char *temp_p;

  override_return_is_last_statement = TRUE;
  highest_label_index++;
  label_stack_if[label_tos_if] = current_label_index_if;
  label_tos_if++;
  current_label_index_if = highest_label_index;

  emitln("", "_if%d_cond:", current_label_index_if);
  get();
  if(curr_token.tok != OPENING_PAREN) error(ERR_FATAL, "Opening parenthesis expected");
  parse_expr(); // evaluate condition
  if(curr_token.tok != CLOSING_PAREN) error(ERR_FATAL, "Closing parenthesis expected");
  emitln("", "  cmp b, 0");
  
  temp_p = prog;
  skip_statements(); // skip main IF block in order to check for ELSE block.
  get();
  if(curr_token.tok == ELSE) emitln("", "  je _if%d_else", current_label_index_if);
  else emitln("", "  je _if%d_exit", current_label_index_if);
  prog = temp_p;
  emitln("", "_if%d_TRUE:", current_label_index_if);
  parse_block();  // parse the positive condition block
  emitln("", "  jmp _if%d_exit", current_label_index_if);
  get(); // look for 'else'
  if(curr_token.tok == ELSE){
    emitln("", "_if%d_else:", current_label_index_if);
    parse_block();  // parse the positive condition block
  }
  else back();
  emitln("", "_if%d_exit:", current_label_index_if);

  label_tos_if--;
  current_label_index_if = label_stack_if[label_tos_if];

  override_return_is_last_statement = FALSE;
}

void parse_return(void){
  get();
  if(curr_token.tok != SEMICOLON){
    back();
    parse_expr();  // return value in register B
  }
  emitln("", "  leave");
  // check if this is "main"
  if(!strcmp(function_table[current_func_id].name, "main")) emitln("", "  syscall sys_terminate_proc");
  else emitln("", "  ret");
}

void skip_case(void){
  do{
    get();
    if(curr_token.tok == OPENING_BRACE){
      back();
      skip_block(0);
      get();
    }
  } while(curr_token.tok != CASE && curr_token.tok != DEFAULT && curr_token.tok != CLOSING_BRACE);

  if(curr_token.tok == CASE){
    back();
    curr_token.tok = CASE;
  }
}

void parse_switch(void){
  char *temp_p;
  int current_case_nbr;

  override_return_is_last_statement = TRUE;
  loop_type_stack[loop_type_tos] = current_loop_type;
  loop_type_tos++;
  current_loop_type = SWITCH_CONSTRUCT;
  highest_label_index++;
  label_stack_switch[label_tos_switch] = current_label_index_switch;
  label_tos_switch++;
  current_label_index_switch = highest_label_index;

  emitln("", "_switch%d_expr:", current_label_index_switch);
  get();
  if(curr_token.tok != OPENING_PAREN) error(ERR_FATAL, "Opening parenthesis expected");
  parse_expr(); // evaluate condition
  if(curr_token.tok != CLOSING_PAREN) error(ERR_FATAL, "Closing parenthesis expected");
  emitln("", "_switch%d_comparisons:", current_label_index_switch);

  get();
  if(curr_token.tok != OPENING_BRACE) error(ERR_FATAL, "Opening braces expected");

  temp_p = prog;
  current_case_nbr = 0;
  // emit compares and jumps
  do{
    get();
    if(curr_token.tok != CASE) error(ERR_FATAL, "Case expected");
    get();
    if(curr_token.tok_type == INTEGER_CONST){
      emitln("", "  cmp b, %d", curr_token.int_const);
      emitln("", "  je _switch%d_case%d", current_label_index_switch, current_case_nbr);
      get();
      if(curr_token.tok != COLON) error(ERR_FATAL, "Colon expected");
      skip_case();
    }
    else if(curr_token.tok_type == CHAR_CONST){
      emitln("", "  cmp bl, $%x", *curr_token.string_const);
      emitln("", "  je _switch%d_case%d", current_label_index_switch, current_case_nbr);
      get();
      if(curr_token.tok != COLON) error(ERR_FATAL, "Colon expected");
      skip_case();
    }
    else if(curr_token.tok_type == IDENTIFIER){
      if(enum_element_exists(curr_token.token_str) != -1){
        emitln("", "  cmp b, %d", get_enum_val(curr_token.token_str));
        emitln("", "  je _switch%d_case%d", current_label_index_switch, current_case_nbr);
        get();
        if(curr_token.tok != COLON) error(ERR_FATAL, "Colon expected");
        skip_case();
      }
    }
    else error(ERR_FATAL, "Constant expected");
    current_case_nbr++;
  } while(curr_token.tok == CASE);

  // generate default jump if it exists
  if(curr_token.tok == DEFAULT){
    emitln("", "  jmp _switch%d_default", current_label_index_switch);
    get(); // get default
    get(); // get ':'
    skip_case();
  }

  emitln("", "  jmp _switch%d_exit", current_label_index_switch);

  // emit code for each case block
  prog = temp_p;
  current_case_nbr = 0;
  do{
    get(); // get 'case'
    get(); // get constant
    get(); // get ':'
    emitln("", "_switch%d_case%d:", current_label_index_switch, current_case_nbr);
    parse_case();
    current_case_nbr++;
    if(curr_token.tok == CASE){
      back();
      curr_token.tok = CASE;
    }
  } while(curr_token.tok == CASE);

  if(curr_token.tok == DEFAULT){
    get(); // get ':'
    emitln("", "_switch%d_default:", current_label_index_switch);
    parse_case();
    back();
  }
  else back();

  get(); // get the final '}'
  if(curr_token.tok != CLOSING_BRACE) error(ERR_FATAL, "Closing braces expected");
  emitln("", "_switch%d_exit:", current_label_index_switch);
  
  label_tos_switch--;
  current_label_index_switch = label_stack_switch[label_tos_switch];
  loop_type_tos--;
  current_loop_type = loop_type_stack[loop_type_tos];

  override_return_is_last_statement = FALSE;
}

void parse_case(void){
  for(;;){
    get();
    switch(curr_token.tok){
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

void emit_c_header_line(){
  char *temp;
  char *s = curr_token.string_const;

  temp = prog;
  back();
  while(*prog != 0x0A && *prog){
    *s++ = *prog++;
  }
  *s = '\0';
  emitln("", "; %s ", curr_token.string_const);
  prog = temp;
}

void parse_block(void){
  int braces = 0;
  char *temp_prog;
  
  do{
    temp_prog = prog;
    get();
    if(curr_token.tok != CLOSING_BRACE) return_is_last_statement = FALSE;
    if(search_typedef(curr_token.token_str) != -1){
      emit_c_header_line();
      prog = temp_prog;
      declare_local();
      continue;
    }
    switch(curr_token.tok){
      case CONST:
      case VOLATILE:
      case REGISTER:
      case STATIC:
      case SIGNED:
      case UNSIGNED:
      case LONG:
      case SHORT:
      case VOID:
      case INT:
      case CHAR:
      case FLOAT:
      case DOUBLE:
      case STRUCT:
        emit_c_header_line();
        prog = temp_prog;
        declare_local();
        break;
      case ASM:
        parse_asm();
        break;
      case GOTO:
        emit_c_header_line();
        parse_goto();
        break;
      case IF:
        emit_c_header_line();
        parse_if();
        break;
      case SWITCH:
        emit_c_header_line();
        parse_switch();
        break;
      case FOR:
        emit_c_header_line();
        parse_for();
        break;
      case WHILE:
        emit_c_header_line();
        parse_while();
        break;
      case DO:
        emit_c_header_line();
        parse_do();
        break;
      case BREAK:
        emit_c_header_line();
        parse_break();
        break;
      case CONTINUE:
        emit_c_header_line();
        parse_continue();
        break;
      case OPENING_BRACE:
        braces++;
        break;
      case CLOSING_BRACE:
        braces--;
        break;
      case RETURN:
        emit_c_header_line();
        parse_return();
        if(!override_return_is_last_statement) return_is_last_statement = TRUE; // only consider this return as a final return if we are not inside an IF statement.
        break;
      default:
        if(curr_token.tok_type == END) error(ERR_FATAL, "Closing brace expected");
        emit_c_header_line();
        prog = temp_prog;
        parse_expr();
        if(curr_token.tok != SEMICOLON) error(ERR_FATAL, "Semicolon expected");
    }    
  } while(braces); // exits when it finds the last closing brace
}


void skip_statements(void){
  int paren = 0;

  get();
  switch(curr_token.tok){
    case ASM:
      skip_statements();
      break;
    case IF:
      // skips the conditional expression between parenthesis
      get();
      if(curr_token.tok != OPENING_PAREN) error(ERR_FATAL, "Opening parenthesis expected");
      paren = 1; // found the first parenthesis
      do{
             if(*prog == '(') paren++;
        else if(*prog == ')') paren--;
        prog++;
      } while(paren && *prog);
      if(!*prog) error(ERR_FATAL, "Closing parenthesis expected");
      skip_statements();
      get();
      if(curr_token.tok == ELSE) skip_statements();
      else back();
      break;
    case OPENING_BRACE: // if it's a block, then the block is skipped
      back();
      skip_block(0);
      break;
    case FOR:
      get();
      if(curr_token.tok != OPENING_PAREN) error(ERR_FATAL, "Opening parenthesis expected");
      paren = 1;
      do{
             if(*prog == '(') paren++;
        else if(*prog == ')') paren--;
        prog++;
      } while(paren && *prog);
      if(!*prog) error(ERR_FATAL, "Closing paren expected");
      get();
      if(curr_token.tok != SEMICOLON){
        back();
        skip_statements();
      }
      break;
    default: // if it's not a keyword, then it must be an expression
      back(); // puts the last curr_token.token_str back, which might be a ";" curr_token.token_str
      while(curr_token.tok != SEMICOLON && curr_token.tok_type != END) get();
      //while(*prog++ != ';' && *prog);
      if(curr_token.tok_type == END) error(ERR_FATAL, "Semicolon expected");
  }
}

void skip_block(int braces){
  do{
    get();
    if(curr_token.tok == OPENING_BRACE) braces++;
    else if(curr_token.tok == CLOSING_BRACE) braces--;
  } while(braces && curr_token.tok_type != END);
  if(braces && curr_token.tok_type == END) error(ERR_FATAL, "Closing braces expected");
}

t_type parse_expr(){
  t_type type;

  type.dims[0] = 0;
  type.ind_level = 0;
  type.primitive_type = DT_INT;
  type.sign_modifier = SIGNMOD_SIGNED;
  type.size_modifier = SIZEMOD_NORMAL;
  get();
  if(curr_token.tok == SEMICOLON) 
    return type;
  else{
    back();
    return parse_assignment();
  }
}

// int a = 9, b = a;
int is_assignment(){
  char *temp_prog;
  int paren = 0, bracket = 0;
  int found_assignment = 0;

  temp_prog = prog;
  for(;;){
    get();
    if(paren == 0 && bracket == 0 && curr_token.tok == ASSIGNMENT){
      found_assignment = 1;
      break;
    }
    if(curr_token.tok_type == END) 
      error(ERR_FATAL, "Unterminated expression.");
    if(curr_token.tok == SEMICOLON || curr_token.tok == COMMA) 
      break;
    if(curr_token.tok == OPENING_PAREN) 
      paren++;
    else if(curr_token.tok == CLOSING_PAREN){
      if(paren == 0) break;
      else paren--;
    }
    else if(curr_token.tok == OPENING_BRACKET) 
      bracket++;
    else if(curr_token.tok == CLOSING_BRACKET){
      if(bracket == 0) break; 
      else bracket--;
    }
  }
  prog = temp_prog;
  return found_assignment;
}

t_type parse_assignment(){
  char var_name[ID_LEN];
  t_type expr_in, var_type, expr_out;
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
  if(curr_token.tok_type == IDENTIFIER){
    if(is_constant(curr_token.token_str)) 
      error(ERR_FATAL, "assignment of read-only variable: %s", curr_token.token_str);
    strcpy(var_name, curr_token.token_str);
    var_type = emit_var_addr_into_d(var_name);
    get();
    // past '=' here
    emitln("", "  push d"); // save 'd'. this is the array base address. save because expr below could use 'd' and overwrite it
    expr_in = parse_expr(); // evaluate expression, result in 'b'
    emitln("", "  pop d"); 
    if(var_type.ind_level > 0){
      emitln("", "  mov [d], b");
    }
    else if(var_type.primitive_type == DT_INT && var_type.ind_level == 0 && var_type.size_modifier == SIZEMOD_LONG){
      if(expr_in.ind_level == 0 && expr_in.size_modifier == SIZEMOD_LONG){
        emitln("", "  mov [d], b");
        emitln("", "  mov b, c");
        emitln("", "  mov [d + 2], b");
      }
      else{
        emitln("", "  mov [d], b");
        emitln("", "  mov b, 0");
        emitln("", "  mov [d + 2], b");
      }
    }
    else if(var_type.primitive_type == DT_INT || var_type.primitive_type == DT_ENUM)
      emitln("", "  mov [d], b");
    else if(var_type.primitive_type == DT_CHAR)
      emitln("", "  mov [d], bl");
    else if(var_type.primitive_type == DT_STRUCT){
      emitln("", "  mov si, b");
      emitln("", "  mov di, d");
      emitln("", "  mov c, %d", get_total_type_size(var_type));
      emitln("", "  rep movsb");
    }
    expr_out = var_type;
    return expr_out;
  }
  else if(curr_token.tok == STAR){ // tests if this is a pointer assignment
    t_type pointer_expr;
    pointer_expr = parse_atomic(); // parse what comes after '*' (considered a pointer)
    emitln("", "  push b"); // pointer given in 'b'. push 'b' into stack to save it. we will retrieve it below into 'd' for the assignment address
    // after evaluating the address expression, the curr_token.token_str will be a "="
    if(curr_token.tok != ASSIGNMENT) 
      error(ERR_FATAL, "Syntax error: Assignment expected");
    parse_expr(); // evaluates the value to be assigned to the address, result in 'b'
    emitln("", "  pop d"); // now pop 'b' from before into 'd' so that we can recover the address for the assignment
    switch(pointer_expr.primitive_type){
      case DT_CHAR:
        if(pointer_expr.ind_level > 1)
          emitln("", "  mov [d], b");
        else
          emitln("", "  mov [d], bl");
        break;
      case DT_INT:
        if(pointer_expr.ind_level == 1 && pointer_expr.size_modifier == SIZEMOD_LONG){
          emitln("", "  mov [d], b");
          emitln("", "  mov b, c");
          emitln("", "  mov [d + 2], b");
        }
        else
          emitln("", "  mov [d], b");
        break;
      default: error(ERR_FATAL, "Invalid pointer");
    }
    expr_out = pointer_expr;
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
    error(ERR_FATAL, "Undeclared variable: %s", varname);
  return 0;
}

// A = cond1 ? TRUE_val : FALSE_val;
t_type parse_ternary_op(void){
  char *temp_prog, *temp_asm_p;
  t_type type1, type2, expr_out;
  t_type logical_or_result;
  //char s[256];
  //int len;

  temp_prog = prog;
  temp_asm_p = asm_p; // save current assembly output pointer
  //sprintf(s, "_ternary%d_cond:", highest_label_index + 1); // this is used to count the number of chars in the ternary operator label string
  //len = strlen(s);                                         // so that we can delete that label if there was no ternary operator afterall
  emitln("", "_ternary%d_cond:", highest_label_index + 1); // +1 because we are emitting the label ahead
  logical_or_result = parse_logical_or(); // evaluate condition
  if(curr_token.tok != TERNARY_OP){
    //overwrite_with_spaces(temp_asm_p, len); // delete the ternary operator condition in the assembly file output
    //return logical_or_result;
    prog = temp_prog;
    asm_p = temp_asm_p; // recover asm output pointer
    return parse_logical_or();
  }

  // '?' was found
  highest_label_index++;
  label_stack_ter[label_tos_ter] = current_label_index_ter;
  label_tos_ter++;
  current_label_index_ter = highest_label_index;
  emitln("", "  cmp b, 0");
  emitln("", "  je _ternary%d_FALSE", current_label_index_ter);
  emitln("", "_ternary%d_TRUE:", current_label_index_ter);
  type1 = parse_ternary_op(); // result in 'b'
  if(curr_token.tok != COLON) error(ERR_FATAL, "Colon expected");
  emitln("", "  jmp _ternary%d_exit", current_label_index_ter);
  emitln("", "_ternary%d_FALSE:", current_label_index_ter);
  type2 = parse_ternary_op(); // result in 'b'
  emitln("", "_ternary%d_exit:", current_label_index_ter);

  label_tos_ter--;
  current_label_index_ter = label_stack_ter[label_tos_ter];
  expr_out = cast(type1, type2);
  return expr_out;
}

// 'A' || 0xFFFFAAAA || 0xFFFFFFFF
// 0xFFFFFFFF || 'A' || 0xFFFFFFFF
// 'A' || 'B' || 0xFFFFFFFF
t_type parse_logical_or(void){
  t_type type1, type2, expr_out;

  type1 = parse_logical_and();
  expr_out = type1;
  if(curr_token.tok == LOGICAL_OR){
    emitln("", "; --- START LOGICAL OR");
    emitln("", "  push a");
    if(type_is_32bit(type1)) emitln("", "  push g");
    while(curr_token.tok == LOGICAL_OR){
      emitln("", "  mov a, b");
      if(type_is_32bit(expr_out)) emitln("", "  mov g, c");
      type2 = parse_logical_and();
      // or between ga and cb
      if(type_is_32bit(cast(expr_out, type2))){
        if(!type_is_32bit(expr_out))
          emitln("", "  mov g, 0");
        else if(!type_is_32bit(type2))
          emitln("", "  mov c, 0");

        emitln("", "  sor32 ga, cb"); // result in b
      }
      else
        emitln("", "  sor a, b ; ||");

      expr_out = cast(expr_out, type2);
    }
    if(type_is_32bit(type1))
      emitln("", "  pop g");
    emitln("", "  pop a");
    emitln("", "; --- END LOGICAL OR");

    expr_out.primitive_type = DT_INT;
    expr_out.ind_level = 0;
    expr_out.dims[0] = 0;
    expr_out.is_constant = FALSE;
    expr_out.sign_modifier = SIGNMOD_UNSIGNED;
    expr_out.size_modifier = SIZEMOD_NORMAL;
  }
  return expr_out;
}

t_type parse_logical_and(void){
  t_type type1, type2, expr_out;

  type1 = parse_bitwise_or();
  expr_out = type1;
  if(curr_token.tok == LOGICAL_AND){
    emitln("", "; --- START LOGICAL AND");
    emitln("", "  push a");
    if(type_is_32bit(type1)) emitln("", "  push g");
    while(curr_token.tok == LOGICAL_AND){
      emitln("", "  mov a, b");
      if(type_is_32bit(expr_out)) emitln("", "  mov g, c");
      type2 = parse_bitwise_or();
      // or between ga and cb
      // (b!=0 or c!=0) and (a!=0 or g!=0)
      if(type_is_32bit(cast(expr_out, type2))){
        if(!type_is_32bit(expr_out))
          emitln("", "  mov g, 0");
        else if(!type_is_32bit(type2))
          emitln("", "  mov c, 0");

        emitln("", "  sand32 ga, cb"); // result in b
      }
      else 
        emitln("", "  sand a, b");

      expr_out = cast(expr_out, type2);
    }
    if(type_is_32bit(type1)) emitln("", "  pop g");
    emitln("", "  pop a");
    emitln("", "; --- END LOGICAL AND");

    expr_out.primitive_type = DT_INT;
    expr_out.ind_level = 0;
    expr_out.dims[0] = 0;
    expr_out.is_constant = FALSE;
    expr_out.sign_modifier = SIGNMOD_UNSIGNED;
    expr_out.size_modifier = SIZEMOD_NORMAL;
  }
  return expr_out;
}

t_type parse_bitwise_or(void){
  t_type type1, type2, expr_out;

  type1 = parse_bitwise_xor();
  expr_out = type1;
  if(curr_token.tok == BITWISE_OR){
    emitln("", "  push a");
    if(type_is_32bit(type1)) emitln("", "  push g");
    while(curr_token.tok == BITWISE_OR){
      emitln("", "  mov a, b");
      if(type_is_32bit(expr_out)) emitln("", "  mov g, c");
      type2 = parse_bitwise_xor();
      if(type_is_32bit(cast(expr_out, type2))){
        if(!type_is_32bit(expr_out))
          emitln("", "  mov g, 0");
        else if(!type_is_32bit(type2))
          emitln("", "  mov c, 0");

        emitln("", "  or32 cb, ga");
      }
      else{
        emitln("", "  or b, a ; |");
      }
      expr_out = cast(expr_out, type2);
    }
    if(type_is_32bit(type1)) emitln("", "  pop g");
    emitln("", "  pop a");
  }
  return expr_out;
}

// todo: implement with long ints
t_type parse_bitwise_xor(void){
  t_type type1, type2, expr_out;

  type1 = parse_bitwise_and();
  expr_out = type1;
  if(curr_token.tok == BITWISE_XOR){
    emitln("", "  push a");
    if(type_is_32bit(type1)) emitln("", "  push g");
    emitln("", "  mov a, b");
    if(type_is_32bit(expr_out)) emitln("", "  mov g, c");
    while(curr_token.tok == BITWISE_XOR){
      type2 = parse_bitwise_and();
      if(type_is_32bit(cast(expr_out, type2))){
        if(!type_is_32bit(expr_out))
          emitln("", "  mov g, 0");
        else if(!type_is_32bit(type2))
          emitln("", "  mov c, 0");

        emitln("", "  xor32 ga, cb");
      }
      else{
        emitln("", "  xor a, b ; ^");
      }
      expr_out = cast(expr_out, type2);
    }
    emitln("", "  mov b, a");
    if(type_is_32bit(expr_out)) emitln("", "  mov c, g");
    if(type_is_32bit(type1)) emitln("", "  pop g");
    emitln("", "  pop a");
  }
  return expr_out;
}

t_type parse_bitwise_and(void){
  t_type type1, type2, expr_out;

  type1 = parse_relational();
  expr_out = type1;
  if(curr_token.tok == AMPERSAND){
    emitln("", "  push a");
    if(type_is_32bit(type1)) emitln("", "  push g");
    while(curr_token.tok == AMPERSAND){
      emitln("", "  mov a, b");
      if(type_is_32bit(expr_out)) emitln("", "  mov g, c");
      type2 = parse_relational();
      if(type_is_32bit(cast(expr_out, type2))){
        if(!type_is_32bit(expr_out))
          emitln("", "  mov g, 0");
        else if(!type_is_32bit(type2))
          emitln("", "  mov c, 0");

        emitln("", "  and32 cb, ga");
      }
      else{
        emitln("", "  and b, a ; &");
      }
      expr_out = cast(expr_out, type2);
    }
    if(type_is_32bit(type1)) emitln("", "  pop g");
    emitln("", "  pop a");
  }
  return expr_out;
}

t_type parse_relational(void){
  t_tok temp_tok;
  t_type type1, type2, expr_out;

/* x = y > 1 && z<4 && y == 2 */
  temp_tok = TOK_UNDEF;
  type1 = parse_bitwise_shift();
  expr_out = type1;
  
  if(curr_token.tok == EQUAL              || curr_token.tok == NOT_EQUAL    || curr_token.tok == LESS_THAN ||
     curr_token.tok == LESS_THAN_OR_EQUAL || curr_token.tok == GREATER_THAN || curr_token.tok == GREATER_THAN_OR_EQUAL){
    emitln("", "; --- START RELATIONAL");
    emitln("", "  push a");
    if(type_is_32bit(type1)) emitln("", "  push g");
    while(curr_token.tok == EQUAL              || curr_token.tok == NOT_EQUAL    || curr_token.tok == LESS_THAN || 
          curr_token.tok == LESS_THAN_OR_EQUAL || curr_token.tok == GREATER_THAN || curr_token.tok == GREATER_THAN_OR_EQUAL){
      temp_tok = curr_token.tok;
      emitln("", "  mov a, b");
      if(type_is_32bit(expr_out)) emitln("", "  mov g, c");
      type2 = parse_bitwise_shift();
      switch(temp_tok){
        case EQUAL:
          if(type_is_32bit(cast(expr_out, type2))){
            if(!type_is_32bit(expr_out))
              emitln("", "  mov g, 0");
            else if(!type_is_32bit(type2))
              emitln("", "  mov c, 0");

            emitln("", "  cmp32 ga, cb");
            emitln("", "  seq ; ==");
          }
          else{
            emitln("", "  cmp a, b");
            emitln("", "  seq ; ==");
          }
          break;
        case NOT_EQUAL:
          if(type_is_32bit(cast(expr_out, type2))){
            if(!type_is_32bit(expr_out))
              emitln("", "  mov g, 0");
            else if(!type_is_32bit(type2))
              emitln("", "  mov c, 0");

            emitln("", "  cmp32 ga, cb");
            emitln("", "  sneq ; !=");
          }
          else{
            emitln("", "  cmp a, b");
            emitln("", "  sneq ; !=");
          }
          break;
        case LESS_THAN:
        //    ga < cb      00000000_00000000 < 00000000_00000000
        //                    g       a           c         b
        // g_a < c_b         if(g < c || (c==g && a < b)) then LESS_THAN == 1    
        // cb is the current parsed long.  ga is the previously parsed long.   
        // check if g < c. save result. check that c==g && a < b. save result. or both results together
          if(type_is_32bit(cast(expr_out, type2))){
            if(!type_is_32bit(expr_out))
              emitln("", "  mov g, 0");
            else if(!type_is_32bit(type2))
              emitln("", "  mov c, 0");

            emitln("", "  cmp32 ga, cb");
            if(expr_out.ind_level > 0 || expr_out.sign_modifier == SIGNMOD_UNSIGNED)
              emitln("", "  slu ; <");
            else
              emitln("", "  slt ; <");
          }
          else{
            emitln("", "  cmp a, b");
            if(expr_out.ind_level > 0 || expr_out.sign_modifier == SIGNMOD_UNSIGNED)
              emitln("", "  slu ; < (unsigned)");
            else
              emitln("", "  slt ; < (signed)");
          }
          break;
        case LESS_THAN_OR_EQUAL:
        //    ga <= cb      00000000_00000000 < 00000000_00000000
        //                    g       a           c         b
        // g_a < c_b         if(g < c || (c==g && a < b)) then LESS_THAN == 1    
        // g_a == c_b
        // cb is the current parsed long.  ga is the previously parsed long.   
        // check if g < c. save result. check that c==g && a < b. save result. or both results together save result
        // check if g_a == c_b. save result. or both results together
          if(type_is_32bit(cast(expr_out, type2))){
            if(!type_is_32bit(expr_out))
              emitln("", "  mov g, 0");
            else if(!type_is_32bit(type2))
              emitln("", "  mov c, 0");

            emitln("", "  cmp32 ga, cb");
            if(expr_out.ind_level > 0 || expr_out.sign_modifier == SIGNMOD_UNSIGNED)
              emitln("", "  sleu"); // result in b
            else
              emitln("", "  sle"); // result in b
          }
          else{
            emitln("", "  cmp a, b");
            if(expr_out.ind_level > 0 || expr_out.sign_modifier == SIGNMOD_UNSIGNED)
              emitln("", "  sleu ; <= (unsigned)");
            else
              emitln("", "  sle ; <= (signed)");
          }
          break;
        case GREATER_THAN:
          if(type_is_32bit(cast(expr_out, type2))){
            if(!type_is_32bit(expr_out))
              emitln("", "  mov g, 0");
            else if(!type_is_32bit(type2))
              emitln("", "  mov c, 0");

            emitln("", "  cmp32 ga, cb");
            if(expr_out.ind_level > 0 || expr_out.sign_modifier == SIGNMOD_UNSIGNED)
              emitln("", "  sgu"); // result in b
            else
              emitln("", "  sgt"); // result in b
          }
          else{
            emitln("", "  cmp a, b");
            if(expr_out.ind_level > 0 || expr_out.sign_modifier == SIGNMOD_UNSIGNED)
              emitln("", "  sgu ; > (unsigned)");
            else
              emitln("", "  sgt ; >");
          }
          break;
        case GREATER_THAN_OR_EQUAL:
          if(type_is_32bit(cast(expr_out, type2))){
            if(!type_is_32bit(expr_out))
              emitln("", "  mov g, 0");
            else if(!type_is_32bit(type2))
              emitln("", "  mov c, 0");

            emitln("", "  cmp32 ga, cb");
            if(expr_out.ind_level > 0 || expr_out.sign_modifier == SIGNMOD_UNSIGNED)
              emitln("", "  sgeu"); // result in b
            else
              emitln("", "  sge"); // result in b
          }
          else{
            emitln("", "  cmp a, b");
            if(expr_out.ind_level > 0 || expr_out.sign_modifier == SIGNMOD_UNSIGNED)
              emitln("", "  sgeu ; >= (unsigned)");
            else
              emitln("", "  sge ; >=");
          }
      }
      expr_out = cast(expr_out, type2);
    }
    if(type_is_32bit(type1))
      emitln("", "  pop g");
    emitln("", "  pop a");
    emitln("", "; --- END RELATIONAL");

    expr_out.primitive_type = DT_INT;
    expr_out.ind_level = 0;
    expr_out.dims[0] = 0;
    expr_out.is_constant = FALSE;
    expr_out.sign_modifier = SIGNMOD_UNSIGNED;
    expr_out.size_modifier = SIZEMOD_NORMAL;
  }
  return expr_out;
}

// todo: deal with 32bit ints!
t_type parse_bitwise_shift(void){
  t_tok temp_tok;
  t_type type1, type2, expr_out;

  // a >> 2 << 3;
  temp_tok = 0;
  type1 = parse_terms();
  expr_out = type1;
  if(curr_token.tok == BITWISE_SHL || curr_token.tok == BITWISE_SHR){
    emitln("", "; --- START SHIFT");
    emitln("", "  push a");
    emitln("", "  mov a, b");
    while(curr_token.tok == BITWISE_SHL || curr_token.tok == BITWISE_SHR){
      temp_tok = curr_token.tok;
      type2 = parse_terms();
      expr_out = cast(expr_out, type2);
      emitln("", "  mov c, b"); // using 16bit values even though only cl is needed, because 'mov cl, bl' is not implemented as an opcode
      if(temp_tok == BITWISE_SHL){
        if(type1.sign_modifier == SIGNMOD_SIGNED) 
          emitln("", "  shl a, cl"); // there is no ashl, since it is equal to shl
        else 
          emitln("", "  shl a, cl");
      }
      else if(temp_tok == BITWISE_SHR){
        if(type1.sign_modifier == SIGNMOD_SIGNED) 
          emitln("", "  ashr a, cl");
        else 
          emitln("", "  shr a, cl");
      }
    }
    emitln("", "  mov b, a");
    emitln("", "  pop a");
    emitln("", "; --- END SHIFT");
  }
  return expr_out;
}

t_type parse_terms(void){
  t_tok temp_tok;
  t_type type1, type2, expr_out;
  
  temp_tok = TOK_UNDEF;
  type1 = parse_factors();
  expr_out = type1;
  if(curr_token.tok == PLUS || curr_token.tok == MINUS){
    emitln("", "; --- START TERMS");
    emitln("", "  push a");
    if(type_is_32bit(type1)) emitln("", "  push g");
    while(curr_token.tok == PLUS || curr_token.tok == MINUS){
      temp_tok = curr_token.tok;
      emitln("", "  mov a, b");
      if(type_is_32bit(expr_out)) emitln("", "  mov g, c");
      type2 = parse_factors();
      // ga + cb
      if(temp_tok == PLUS){
        if(type_is_32bit(cast(expr_out, type2))){
          if(!type_is_32bit(expr_out))
            emitln("", "  mov g, 0");
          else if(!type_is_32bit(type2))
            emitln("", "  mov c, 0");

          emitln("", "  add32 cb, ga");
        }
        else
          emitln("", "  add b, a");
      }
      else if(temp_tok == MINUS){
        if(type_is_32bit(cast(expr_out, type2))){
          if(!type_is_32bit(expr_out))
            emitln("", "  mov g, 0");
          else if(!type_is_32bit(type2))
            emitln("", "  mov c, 0");

          emitln("", "  sub32 ga, cb");
          emitln("", "  mov b, a");
          emitln("", "  mov c, g");
        }
        else{
          emitln("", "  sub a, b");
          emitln("", "  mov b, a");
        }
      }
      expr_out = cast(expr_out, type2);
    }
    if(type_is_32bit(type1)) emitln("", "  pop g");
    emitln("", "  pop a");
    emitln("", "; --- END TERMS");
  }
  return expr_out;
}

t_type parse_factors(void){
  t_tok temp_tok;
  t_type type1, type2, expr_out;

// if type1 is an INT and type2 is a char*, then the result should be a char* still
  temp_tok = TOK_UNDEF;
  type1 = parse_atomic();
  expr_out = type1;
  if(curr_token.tok == STAR || curr_token.tok == FSLASH || curr_token.tok == MOD){
    emitln("", "; --- START FACTORS");
    emitln("", "  push a");
    emitln("", "  push g");
    emitln("", "  mov a, b");
    emitln("", "  mov g, c");
    while(curr_token.tok == STAR || curr_token.tok == FSLASH || curr_token.tok == MOD){
      highest_label_index++;
      temp_tok = curr_token.tok;
      type2 = parse_atomic();
      expr_out = cast(expr_out, type2);
      if(temp_tok == STAR){
          emitln("", "  push a     ; save left operand");
          emitln("", "  xor a, b   ; xor sign bits");
          emitln("", "  swp a      ; swap bytes");
          emitln("", "  mov cl, al ; save result of xor into 'dl'");
          emitln("", "  pop a      ; restore left side operator");
          emitln("", "  push cl    ; save result of xor above");

          emitln("", "  swp a  ");
          emitln("", "  test al, $80  ");
          emitln("", "  swp a  ");
          emitln("", "  jz skip_invert_a_%d  ", highest_label_index);
          emitln("", "  neg a ");
          emitln("", "skip_invert_a_%d:   ", highest_label_index);
          emitln("", "  swp b");
          emitln("", "  test bl, $80  ");
          emitln("", "  swp b");
          emitln("", "  jz skip_invert_b_%d  ", highest_label_index);
          emitln("", "  neg b ");
          emitln("", "skip_invert_b_%d:   ", highest_label_index);

          emitln("", "  mul a, b ; *");
          emitln("", "  mov g, a");
          emitln("", "  mov a, b");

          emitln("", "  pop bl");
          emitln("", "  test bl, $80");
          emitln("", "  jz _same_signs_%d", highest_label_index);

          emitln("", "  mov bl, al");
          emitln("", "  not a");
          emitln("", "  neg b");
          emitln("", "  adc a, 0");
          emitln("", "  mov g, a");
          emitln("", "  mov a, b");

          emitln("", "_same_signs_%d:", highest_label_index);

          expr_out.size_modifier = SIZEMOD_LONG; // set it as a 32bit int
      }
      else if(temp_tok == FSLASH){
        emitln("", "  push g ; save 'g' as the div instruction uses it");
        emitln("", "  div a, b ; /, a: quotient, b: remainder");
        emitln("", "  pop g");
      }
      else if(temp_tok == MOD){
        emitln("", "  push g ; save 'g' as the div instruction uses it");
        emitln("", "  div a, b ; %, a: quotient, b: remainder");
        emitln("", "  mov a, b");
        emitln("", "  pop g");
      }
    }
    emitln("", "  mov c, g");
    emitln("", "  mov b, a");
    emitln("", "  pop g");
    emitln("", "  pop a");
    emitln("", "; --- END FACTORS");
  }

  return expr_out;
}

t_type parse_atomic(void){
  int func_id;
  char temp_name[ID_LEN];
  t_type expr_out;
  int ind_level = 0;
  t_sign_modifier sign_modifier;
  t_primitive_type primitive_type;
  t_size_modifier size_modifier;

  get();

  if(curr_token.tok_type == STRING_CONST)
    expr_out = parse_string_const();

  else if(curr_token.tok_type == INTEGER_CONST)
    expr_out = parse_integer_const();

  else if(curr_token.tok_type == CHAR_CONST)
    expr_out = parse_char_const();

  else if(curr_token.tok == SIZEOF)
    expr_out = parse_sizeof();

  else if(curr_token.tok == STAR)
    expr_out = parse_dereferencing();

  else if(curr_token.tok == AMPERSAND)
    expr_out = parse_referencing();

  else if(curr_token.tok == MINUS)
    expr_out = parse_unary_minus();

  else if(curr_token.tok == BITWISE_NOT)
    expr_out = parse_bitwise_not();

  else if(curr_token.tok == LOGICAL_NOT)
    expr_out = parse_unary_logical_not();

  else if(curr_token.tok == INCREMENT)
    expr_out = parse_pre_incrementing();

  else if(curr_token.tok == DECREMENT)
    expr_out = parse_pre_decrementing();

  else if(curr_token.tok_type == IDENTIFIER){
    strcpy(temp_name, curr_token.token_str);
    get();
    if(curr_token.tok == OPENING_PAREN){ // function call      
      if((func_id = search_function(temp_name)) != -1){
        expr_out = function_table[func_id].return_type; // get function's return type
        parse_function_call(func_id);
      }
      else error(ERR_FATAL, "Undeclared function: %s", temp_name);
    }
    else if(enum_element_exists(temp_name) != -1){
      back();
      emitln("", "  mov32 cb, $%x ; enum element: %s", get_enum_val(temp_name), temp_name);
      expr_out.primitive_type = DT_INT;
      expr_out.ind_level = 0;
      expr_out.sign_modifier = SIGNMOD_SIGNED; // TODO: check enums can always be signed...
    }
    else{
      back();
      expr_out = emit_var_addr_into_d(temp_name); // into 'b'
      // emit base address for variable, whether struct or not
      back();
      if(is_array(expr_out)){
        emitln("", "  mov b, d");
        emitln("", "  mov c, 0");  // for long ints
      }
      else if(expr_out.ind_level > 0){
        emitln("", "  mov b, [d]"); 
        emitln("", "  mov c, 0");  // for long ints
      }
      else if(expr_out.primitive_type == DT_INT){
        if(expr_out.size_modifier == SIZEMOD_LONG){
          emitln("", "  mov b, [d + 2] ; Upper Word of the Long Int");
          emitln("", "  mov c, b ; And place it into C"); 
          emitln("", "  mov b, [d] ; Lower Word in B"); 
        }
        else{
          emitln("", "  mov b, [d]"); 
          emitln("", "  mov c, 0");  // for long ints
        }
      }
      else if(expr_out.primitive_type == DT_CHAR){
        emitln("", "  mov bl, [d]");
        emitln("", "  mov bh, 0"); 
        emitln("", "  mov c, 0");  // for long ints
      }
      else if(expr_out.primitive_type == DT_STRUCT){ // this is used by the assignment parser to obtain the base address of the struct
        emitln("", "  mov b, d");
        emitln("", "  mov c, 0");  
      }
      else if(expr_out.primitive_type == DT_UNION){ // this is used by the assignment parser to obtain the base address of the struct
        emitln("", "  mov b, d");
        emitln("", "  mov c, 0");  
      }
      else if(expr_out.primitive_type == DT_ENUM){
        emitln("", "  mov b, [d]"); 
        emitln("", "  mov c, 0");  
      }
    }
  }

  else if(curr_token.tok == OPENING_PAREN){
    get();
    if(curr_token.tok != SIGNED && curr_token.tok != UNSIGNED && 
       curr_token.tok != LONG   && curr_token.tok != SHORT    && 
       curr_token.tok != INT    && curr_token.tok != CHAR     && 
       curr_token.tok != VOID   && curr_token.tok != ENUM     &&
       curr_token.tok != STRUCT
    ){
      back();
      expr_out = parse_expr();  // parses expression between parenthesis and result will be in B
      if(curr_token.tok != CLOSING_PAREN) error(ERR_FATAL, "closing paren expected");
    }
    else{
      sign_modifier = SIGNMOD_SIGNED;
      size_modifier  = SIZEMOD_NORMAL;

      while(curr_token.tok == SIGNED || curr_token.tok == UNSIGNED || 
            curr_token.tok == LONG   || curr_token.tok == SHORT
      ){
        if(curr_token.tok == SIGNED)
          sign_modifier = SIGNMOD_SIGNED;
        else if(curr_token.tok == UNSIGNED)
          sign_modifier = SIGNMOD_UNSIGNED;
        else if(curr_token.tok == SHORT)
          size_modifier = SIZEMOD_SHORT;
        else if(curr_token.tok == LONG)
          size_modifier = SIZEMOD_LONG;
        get();
      }

      primitive_type = DT_INT;
      if(curr_token.tok == VOID){
        primitive_type = DT_VOID;
      }
      else if(curr_token.tok == INT){
        primitive_type = DT_INT;
      }
      else if(curr_token.tok == CHAR){
        primitive_type = DT_CHAR;
      }
      ind_level = 0;
      get();
      while(curr_token.tok == STAR){
        ind_level++;
        get();
      }

      if(primitive_type == DT_VOID){
        if(ind_level == 0) 
          error(ERR_FATAL, "Invalid data type of pure 'void'.");
        expr_out = parse_atomic();
        back();
      }
      else if(primitive_type == DT_INT){
        if(size_modifier == SIZEMOD_NORMAL){
          expr_out = parse_atomic();
          if(sign_modifier == SIGNMOD_SIGNED && ind_level == 0 && expr_out.primitive_type == DT_CHAR) 
            emitln("", "  snex b"); // sign extend b
          else if(sign_modifier == SIGNMOD_UNSIGNED && ind_level == 0 && expr_out.primitive_type == DT_CHAR) 
            emitln("", "  mov bh, 0"); // zero extend b
          back();
        }
        else if(size_modifier == SIZEMOD_LONG){
          expr_out = parse_atomic();
          if(sign_modifier == SIGNMOD_SIGNED && ind_level == 0 && expr_out.primitive_type == DT_INT){
            emitln("", "  snex b"); // sign extend b
            emitln("", "  push a");
            emitln("", "  mov al, bh");
            emitln("", "  mov ah, al");
            emitln("", "  mov c, a"); // sign extend c
            emitln("", "  pop a");
          }
          else if(sign_modifier == SIGNMOD_UNSIGNED && ind_level == 0 && expr_out.primitive_type == DT_INT){
            emitln("", "  mov bh, 0"); // zero extend b
            emitln("", "  mov c, 0"); // zero extend c
          }
          back();
        }
      }
      else if(primitive_type == DT_CHAR){
        expr_out = parse_atomic();
        if(ind_level == 0){
          emitln("", "  mov bh, 0"); // zero out bh to make it a char
          if(expr_out.size_modifier == SIZEMOD_LONG)
            emitln("", "  mov c, 0"); // and if the type is longm then zero out c as well
        }
        back();
      }
      expr_out.primitive_type = primitive_type;
      expr_out.ind_level = ind_level;
      expr_out.sign_modifier = sign_modifier;
      expr_out.size_modifier = size_modifier;
    }
  }

  else error(ERR_FATAL, "Invalid expression");

// Check for post ++/--
  get();
  if(curr_token.tok == INCREMENT)  // post increment. get value first, then do assignment
    expr_out = parse_post_incrementing(expr_out, temp_name);
  else if(curr_token.tok == DECREMENT) // post decrement. get value first, then do assignment
    expr_out = parse_post_decrementing(expr_out, temp_name);

  return expr_out;
}

t_type parse_sizeof(){
  int var_id;
  t_type type;

  get();
  expect(OPENING_PAREN, "Opening parenthesis expected");
  get();
  if(curr_token.tok_type == IDENTIFIER){
    if(local_var_exists(curr_token.token_str) != -1){ // is a local variable
      var_id = local_var_exists(curr_token.token_str);
      emitln("", "  mov32 cb, %d", get_total_type_size(function_table[current_func_id].local_vars[var_id].type));
    }
    else if(global_var_exists(curr_token.token_str) != -1){  // is a global variable
      var_id = global_var_exists(curr_token.token_str);
      emitln("", "  mov32 cb, %d", get_total_type_size(global_var_table[var_id].type));
    }
    else if(search_typedef(curr_token.token_str) != -1){
      emitln("", "  mov32 cb, %d", get_total_type_size(typedef_table[search_typedef(curr_token.token_str)].type));
    }
    else{
      error(ERR_FATAL, "(Parse atomic) Undeclared identifier: %s", curr_token.token_str);
    }
    get();
  }
  else if(
    curr_token.tok == SIGNED   || curr_token.tok == UNSIGNED || 
    curr_token.tok == LONG     || curr_token.tok == CONST    || 
    curr_token.tok == VOID     || curr_token.tok == CHAR     ||
    curr_token.tok == INT      || curr_token.tok == FLOAT    || 
    curr_token.tok == DOUBLE   || curr_token.tok == STRUCT   ||
    curr_token.tok == SHORT    || curr_token.tok == STATIC   ||
    curr_token.tok == ENUM     || curr_token.tok == UNION    ||
    search_typedef(curr_token.token_str) != -1 
  ){
    back();
    type = get_type();
    emitln("", "  mov32 cb, %d", get_total_type_size(type));
    get();
  }
  else{
    back();
    type = parse_expr();
    emitln("", "  mov32 cb, %d", get_total_type_size(type));
  }
  type.primitive_type = DT_INT;
  type.ind_level = 0;
  type.sign_modifier = SIGNMOD_SIGNED;
  type.size_modifier = SIZEMOD_NORMAL;
  expect(CLOSING_PAREN, "Closing paren expected");
  return type;
}

t_type parse_string_const(){
  t_type expr_out;
  int string_id;

  string_id = add_string_data(curr_token.string_const);
  // now emit the reference to this string into the ASM
  emitln("", "  mov b, _s%d ; \"%s\"", string_id, curr_token.string_const);
  expr_out.size_modifier = SIZEMOD_NORMAL;
  expr_out.primitive_type = DT_CHAR;
  expr_out.ind_level = 1;
  expr_out.sign_modifier = SIGNMOD_SIGNED;
  return expr_out;
}

t_type parse_integer_const(){
  t_type expr_out;

  emitln("", "  mov32 cb, $%08x", (uint32_t)(curr_token.int_const));

  expr_out.sign_modifier = curr_token.const_sign_modifier;
  expr_out.size_modifier = curr_token.const_size_modifier;
  expr_out.primitive_type = DT_INT;
  expr_out.ind_level = 0;

  return expr_out;
}

t_type parse_unary_logical_not(){
  t_type expr_out;

  expr_out = parse_atomic(); // in 'cb'
  if(expr_out.ind_level > 0){
    emitln("", "  cmp b, 0");
    emitln("", "  seq ; !");
  }
  else if(expr_out.size_modifier == SIZEMOD_LONG){
    emitln("", "  cmp32 cb, 0");
    emitln("", "  seq ; !");
  } 
  back();
  expr_out.size_modifier = SIZEMOD_NORMAL;
  expr_out.primitive_type = DT_INT;
  expr_out.ind_level = 0;
  expr_out.sign_modifier = SIGNMOD_UNSIGNED;
  return expr_out;
}

t_type parse_bitwise_not(){
  t_type expr_out;

  expr_out = parse_atomic(); // in 'cb'
  if(expr_out.ind_level > 0)  
    emitln("", "  not b");
  else if(expr_out.primitive_type == DT_INT){
    if(expr_out.size_modifier == SIZEMOD_LONG){
      emitln("", "  mov a, c");
      emitln("", "  not a");
      emitln("", "  not b");
      emitln("", "  mov c, a");
    } 
  }
  else 
    emitln("", "  not b"); // treating as int as an experiment
  expr_out.size_modifier = SIZEMOD_NORMAL;
  expr_out.primitive_type = DT_INT;
  expr_out.ind_level = 0;
  expr_out.sign_modifier = expr_out.sign_modifier;
  back();
  return expr_out;
}

// -127, -128, -255, -32768, -32767, -65535
t_type parse_unary_minus(){
  t_type expr_out;

  expr_out = parse_atomic(); // TODO: add error if type is pointer since cant neg a pointer
  if(expr_out.ind_level > 0) 
    error(ERR_FATAL, "Negation of a pointer type.");
  if(expr_out.primitive_type == DT_INT){
    if(expr_out.size_modifier == SIZEMOD_LONG){
      emitln("", "  mov a, c");
      emitln("", "  not a");
      emitln("", "  not b");
      emitln("", "  add b, 1");
      emitln("", "  adc a, 0");
      emitln("", "  mov c, a");
    } 
    else
      emitln("", "  neg b");
  } 
  else 
    emitln("", "  neg b"); // treating as int as experiment
  back();
  expr_out.primitive_type = DT_INT; // convert to int
  expr_out.ind_level = 0;
  return expr_out;
}

t_type parse_char_const(){
  t_type expr_out;
  emitln("", "  mov32 cb, $000000%02x", curr_token.string_const[0]);
  expr_out.primitive_type = DT_CHAR; //TODO: int or char? 
  expr_out.ind_level = 0;
  expr_out.sign_modifier = SIGNMOD_UNSIGNED;
  expr_out.size_modifier = SIZEMOD_NORMAL;
  expr_out.dims[0] = 0;
  return expr_out;
}


t_type parse_post_decrementing(t_type expr_in, char *temp_name){
  t_type expr_out;
  int size;

  size = get_incdec_unit(expr_in);
  if(size == 2){
    emitln("", "  mov a, b");
    emitln("", "  dec b");
    emitln("", "  dec b");
    emit_var_addr_into_d(temp_name);
    emitln("", "  mov [d], b");
    emitln("", "  mov b, a");
  }
  else if(size == 4){
    emitln("", "  mov a, b");
    emitln("", "  sub b, 4");
    emit_var_addr_into_d(temp_name);
    emitln("", "  mov [d], b");
    emitln("", "  mov b, a");
  }
  else if(size == 1){
    if(expr_in.primitive_type == DT_INT){
      if(expr_in.size_modifier == SIZEMOD_LONG){
        emitln("", "  mov g, c");
        emitln("", "  mov a, b");
        emitln("", "  mov32 cb, 1");
        emitln("", "  sub32 ga, cb");
        emitln("", "  mov c, g");
        emitln("", "  mov b, a");
        emit_var_addr_into_d(temp_name);
        emitln("", "  mov b, c");
        emitln("", "  mov [d+2], b");
        emitln("", "  mov [d], b");
        emitln("", "  mov32 ga, 1");
        emitln("", "  add32 cb, ga");
      }
      else{
        emitln("", "  mov a, b");
        emitln("", "  dec b");
        emit_var_addr_into_d(temp_name);
        emitln("", "  mov [d], b");
        emitln("", "  mov b, a");
      }
    }
    else if(expr_in.primitive_type == DT_CHAR){
      if(expr_in.ind_level > 0){
        emitln("", "  dec b");
        emit_var_addr_into_d(temp_name);
        emitln("", "  mov [d], b");
        emitln("", "  inc b");

      }
      else{
        emitln("", "  dec b");
        emit_var_addr_into_d(temp_name);
        emitln("", "  mov [d], bl");
        emitln("", "  inc b");
      }
    }
  }
  else{
    emitln("", "  mov a, b");
    emitln("", "  dec b");
    emitln("", "  dec b");
    emit_var_addr_into_d(temp_name);
    emitln("", "  mov [d], b");
    emitln("", "  mov b, a");
  }
  expr_out = expr_in;
  get(); // gets the next curr_token.token_str (it must be a delimiter)

  return expr_out;
}

t_type parse_post_incrementing(t_type expr_in, char *temp_name){
  t_type expr_out;
  int size;
  // p++
  size = get_incdec_unit(expr_in);
  if(size == 2){
    emitln("", "  mov a, b");
    emitln("", "  inc b");
    emitln("", "  inc b");
    emit_var_addr_into_d(temp_name);
    emitln("", "  mov [d], b");
    emitln("", "  mov b, a");
  }
  else if(size == 4){
    emitln("", "  mov a, b");
    emitln("", "  add b, 4");
    emit_var_addr_into_d(temp_name);
    emitln("", "  mov [d], b");
    emitln("", "  mov b, a");
  }
  else if(size == 1){
    if(expr_in.primitive_type == DT_INT){
      if(expr_in.size_modifier == SIZEMOD_LONG){
        emitln("", "  mov32 ga, 1");
        emitln("", "  add32 cb, ga");
        emitln("", "  mov a, b");
        emitln("", "  mov g, c");
        emit_var_addr_into_d(temp_name);
        emitln("", "  mov [d], b");
        emitln("", "  mov b, c");
        emitln("", "  mov [d+2], b");
        emitln("", "  mov32 cb, 1");
        emitln("", "  sub32 ga, cb");
        emitln("", "  mov c, g");
        emitln("", "  mov b, a");
      }
      else{
        emitln("", "  mov a, b");
        emitln("", "  inc b");
        emit_var_addr_into_d(temp_name);
        emitln("", "  mov [d], b");
        emitln("", "  mov b, a");
      }
    }
    else if(expr_in.primitive_type == DT_CHAR){
      if(expr_in.ind_level > 0){
        emitln("", "  inc b");
        emit_var_addr_into_d(temp_name);
        emitln("", "  mov [d], b");
        emitln("", "  dec b");

      }
      else{
        emitln("", "  inc b");
        emit_var_addr_into_d(temp_name);
        emitln("", "  mov [d], bl");
        emitln("", "  dec b");
      }
    }
  }
  else{
    emitln("", "  mov a, b");
    emitln("", "  inc b");
    emitln("", "  inc b");
    emit_var_addr_into_d(temp_name);
    emitln("", "  mov [d], b");
    emitln("", "  mov b, a");
  }
  expr_out = expr_in;
  get(); // gets the next curr_token.token_str (it must be a delimiter)

  return expr_out;
}
/*
t_type parse_post_decrementing(t_type expr_in, char *temp_name){
  t_type expr_out;

  if(get_incdec_unit(expr_in) > 1){
    emitln("", "  dec b");
    emitln("", "  dec b");
    emit_var_addr_into_d(temp_name);
    emitln("", "  mov [d], b");
    emitln("", "  inc b");
    emitln("", "  inc b");
  }
  else{
    emitln("", "  dec b");
    emit_var_addr_into_d(temp_name);
    emitln("", "  mov [d], b");
    emitln("", "  inc b");
  }
  expr_out = expr_in;
  get(); // gets the next curr_token.token_str (it must be a delimiter)

  return expr_out;
}

t_type parse_post_incrementing(t_type expr_in, char *temp_name){
  t_type expr_out;

  if(get_incdec_unit(expr_in) > 1){
    emitln("", "  inc b");
    emitln("", "  inc b");
    emit_var_addr_into_d(temp_name);
    emitln("", "  mov [d], b");
    emitln("", "  dec b");
    emitln("", "  dec b");
  }
  else{
    emitln("", "  inc b");
    emit_var_addr_into_d(temp_name);
    emitln("", "  mov [d], b");
    emitln("", "  dec b");
  }
  expr_out = expr_in;
  get(); // gets the next curr_token.token_str (it must be a delimiter)

  return expr_out;
}
*/
t_type parse_pre_decrementing(){
  t_type expr_out;
  char temp_name[ID_LEN];
  int size;

  get();
  if(curr_token.tok_type != IDENTIFIER) error(ERR_FATAL, "Identifier expected");
  strcpy(temp_name, curr_token.token_str);
  expr_out = emit_var_addr_into_d(temp_name);

  switch(expr_out.primitive_type){
    case DT_CHAR:
      if(expr_out.ind_level > 0)
        emitln("", "  mov b, [d]");
      else
        emitln("", "  mov bl, [d]");
      break;
    case DT_INT:
      if(expr_out.ind_level == 0){
        if(expr_out.size_modifier == SIZEMOD_LONG){
          emitln("", "  mov b, [d+2]");
          emitln("", "  mov c, b");
          emitln("", "  mov b, [d]");
        }
        else
          emitln("", "  mov b, [d]");
      }
      else
        emitln("", "  mov b, [d]");
      break;
    default:
      emitln("", "  mov b, [d]");
  }

  size = get_incdec_unit(expr_out);
  if(size == 4) { // for long int
    emitln("", "  sub b, 4");
  }
  else if(size > 1) {
    emitln("", "  sub b, %d", size);
  }
  else 
    emitln("", "  dec b");

  expr_out = emit_var_addr_into_d(temp_name);

  switch(expr_out.primitive_type){
    case DT_CHAR:
      if(expr_out.ind_level > 0)
        emitln("", "  mov [d], b");
      else
        emitln("", "  mov [d], bl");
      break;
    case DT_INT:
      if(expr_out.ind_level == 0){
        if(expr_out.size_modifier == SIZEMOD_LONG){
          emitln("", "  mov [d], b");
          emitln("", "  mov b, c");
          emitln("", "  mov [d+2], b");
        }
        else
          emitln("", "  mov [d], b");
      }
      else
        emitln("", "  mov [d], b");
      break;
    default:
      emitln("", "  mov [d], b");
  }

  return expr_out;
}

t_type parse_pre_incrementing(){
  t_type expr_out;
  char temp_name[ID_LEN];
  int size;

  get();
  if(curr_token.tok_type != IDENTIFIER) error(ERR_FATAL, "Identifier expected");
  strcpy(temp_name, curr_token.token_str);
  expr_out = emit_var_addr_into_d(temp_name);

  switch(expr_out.primitive_type){
    case DT_CHAR:
      if(expr_out.ind_level > 0)
        emitln("", "  mov b, [d]");
      else
        emitln("", "  mov bl, [d]");
      break;
    case DT_INT:
      if(expr_out.ind_level == 0){
        if(expr_out.size_modifier == SIZEMOD_LONG){
          emitln("", "  mov b, [d+2]");
          emitln("", "  mov c, b");
          emitln("", "  mov b, [d]");
        }
        else
          emitln("", "  mov b, [d]");
      }
      else
        emitln("", "  mov b, [d]");
      break;
    default:
      emitln("", "  mov b, [d]");
  }

  size = get_incdec_unit(expr_out);
  if(size == 4) { // for long int
    emitln("", "  add b, 4");
  }
  else if(size > 1) {
    emitln("", "  add b, %d", size);
  }
  else 
    emitln("", "  inc b");

  expr_out = emit_var_addr_into_d(temp_name);

  switch(expr_out.primitive_type){
    case DT_CHAR:
      if(expr_out.ind_level > 0)
        emitln("", "  mov [d], b");
      else
        emitln("", "  mov [d], bl");
      break;
    case DT_INT:
      if(expr_out.ind_level == 0){
        if(expr_out.size_modifier == SIZEMOD_LONG){
          emitln("", "  mov [d], b");
          emitln("", "  mov b, c");
          emitln("", "  mov [d+2], b");
        }
        else
          emitln("", "  mov [d], b");
      }
      else
        emitln("", "  mov [d], b");
      break;
    default:
      emitln("", "  mov [d], b");
  }

  return expr_out;
}

t_type parse_referencing(){
  t_type expr_out;

  get(); // get variable name
  if(curr_token.tok_type != IDENTIFIER) error(ERR_FATAL, "Identifier expected");
  expr_out = emit_var_addr_into_d(curr_token.token_str);
  emitln("", "  mov b, d");
  expr_out.ind_level++;
  return expr_out;
}

t_type parse_dereferencing(void){
  t_type expr_out;

  expr_out = parse_atomic(); // parse expression after STAR, which could be inside parenthesis. result in B

  if(expr_out.primitive_type == DT_VOID && expr_out.ind_level <= 1) 
    error(ERR_FATAL, "Dereferencing void pointer with indirection level of 1 or less.");

  if(expr_out.ind_level > 1){
    emitln("", "  mov d, b");// now we have the pointer value.
    emitln("", "  mov b, [d]"); 
  }
  else if(expr_out.primitive_type == DT_INT){
    if(expr_out.size_modifier == SIZEMOD_LONG){
      emitln("", "  mov d, b");// now we have the pointer value.
      emitln("", "  mov b, [d + 2] ; Upper Word of the Long Int");
      emitln("", "  mov c, b ; And place it into C"); 
      emitln("", "  mov b, [d] ; Lower Word in B"); 
    }
    else{
      emitln("", "  mov d, b");// now we have the pointer value.
      emitln("", "  mov b, [d]"); 
      emitln("", "  mov c, 0"); 
    }
  }
  else if(expr_out.primitive_type == DT_CHAR){
    emitln("", "  mov d, b");// now we have the pointer value.
    emitln("", "  mov bl, [d]"); 
    emitln("", "  mov bh, 0");
    emitln("", "  mov c, 0"); 
  }
  
  back();
  return expr_out;
}

//  so the fixed args will be pushed closer to where BP points, because in order to calculate the BP
//  offset for those arguments, we need a known reference from BP. if we pushed the var args closer to BP than
//  the fixed args, it would not match with the way the BP offsets are calculated in the function declaration.
//  so from BP, we push the fixed arguments so that their offsets are known and match the declaration.
//  after that, we push the variable arguments on addresses above the ones for the fixed args.
//
//  myfunc(fixed1, fixed2, var_arg1, var_arg2, var_arg3);
//  var3
//  var2
//  var1
//  fixed2
//  fixed1
//  pc
//  bp
//  locals...             <---- bp, sp
void parse_function_call(int func_id){
  int total_function_arguments;
  t_type arg_expr;
  t_type arg_type;
  int current_func_call_total_arg_size;
  int curr_arg_num;
  int paren_count;
  int parenthesis_count;
  char *prog_at_end_of_header;


  emitln("", "; --- START FUNCTION CALL");
  get();
  if(curr_token.tok == CLOSING_PAREN){
    if(function_table[func_id].num_fixed_args != 0)
      error(ERR_FATAL, "Incorrect number of arguments for function: %s. Expecting %d, detected: 0", function_table[func_id].name, function_table[func_id].num_fixed_args);
    else{
      emitln("", "  call %s", function_table[func_id].name);
      return;
    }
  }
  else back();

  current_func_call_total_arg_size = 0;
  total_function_arguments = 1;
  // count the total number of arguments being passed to the function by counting the number of ',' characters
  paren_count = 1;
  do{
    get();
    if(curr_token.tok == COMMA) total_function_arguments++;
    else if(curr_token.tok == OPENING_PAREN) paren_count++;
    else if(curr_token.tok == CLOSING_PAREN) paren_count--;
  } while(paren_count > 0);
  prog_at_end_of_header = prog;
  
  // while(is_space(*p));
  prog--; // here prog is at ')'

  parenthesis_count = 0;  
  curr_arg_num = total_function_arguments;
  // now we are at the end of the function header, at the ')' curr_token.token_str.
  // go backwards finding one comma at a time, and then parsing the expression corresponding to that parameter.
  do{
    for(;;){
      if(*prog == '\"'){
        prog--;
        while(*prog != '\"'){
          prog--;
          if(prog == c_in) error(ERR_FATAL, "Unterminated string.");
        }
      }
      else if(*prog == ')') parenthesis_count++;
      else if(*prog == '('){
        parenthesis_count--;
        if(parenthesis_count == 0){
          prog++; // skip the parenthesis 
          push_prog(); // save the current prog position so that we can go back to it when finished parsing this argument
          break;
        }
      }
      else if(*prog == ','){
        prog--; // go back one position to the left to skip the comma char, for the next iteration
        push_prog(); // save the current prog position so that we can go back to it when finished parsing this argument
        prog += 2; // go forwards to skip the comma in order to parse the expression
        break;
      }
      prog--;
    }
    arg_expr = parse_expr(); // parse this argument
    // if this argument is a variable one, then its type or size is not given by a declaration at the function header, but from the result of the expression itself  
    if(curr_arg_num > function_table[func_id].num_fixed_args) arg_type = arg_expr;
    // if the argument is a fixed one, then its type and hence size, is given in the function declaration
    else arg_type = function_table[func_id].local_vars[curr_arg_num - 1].type;
    current_func_call_total_arg_size += get_type_size_for_func_arg_parsing(arg_type); 

    if(arg_type.ind_level > 0 || is_array(arg_type)){
      emitln("", "  swp b");
      emitln("", "  push b");
    }
    else if(arg_type.primitive_type == DT_STRUCT){
      emitln("", "  sub sp, %d", get_type_size_for_func_arg_parsing(arg_type));
      emitln("", "  mov si, b"); 
      emitln("", "  lea d, [sp + 1]");
      emitln("", "  mov di, d");
      emitln("", "  mov c, %d", get_type_size_for_func_arg_parsing(arg_type));
      emitln("", "  rep movsb");
    }
    else if(arg_type.size_modifier == SIZEMOD_LONG){
      emitln("", "  mov a, c");
      emitln("", "  swp a");
      emitln("", "  push a");
      emitln("", "  swp b");
      emitln("", "  push b");
    }
    else if(arg_type.primitive_type == DT_CHAR){
      if(curr_arg_num > function_table[func_id].num_fixed_args) {
        // if is a var arg, then it needs to be pushed as 16bit because printf cannot differentiate an 8bit integer vs a 16bit integer. printf will always print as 16bits
        emitln("", "  swp b");
        emitln("", "  push b"); 
      }
      else 
        emitln("", "  push bl");
    }
    else if(arg_type.primitive_type == DT_INT){
      if(arg_expr.primitive_type == DT_CHAR && arg_expr.ind_level == 0) 
        emitln("", "  snex b");
      emitln("", "  swp b");
      emitln("", "  push b");
    }
    else if(arg_type.primitive_type == DT_ENUM){
      if(arg_expr.primitive_type == DT_CHAR && arg_expr.ind_level == 0) 
        emitln("", "  snex b");
      emitln("", "  swp b");
      emitln("", "  push b");
    }
    curr_arg_num--;
    pop_prog(); // recover prog position, which is exactly one char to the left of the comma after which this current argument comes
  } while(curr_arg_num > 0); 

  // Check if the number of arguments matches the number of function parameters
  // but only if the function does not have variable arguments
  if(function_table[func_id].num_fixed_args != total_function_arguments && !function_has_variable_arguments(func_id))  
    error(ERR_FATAL, "incorrect number of arguments for function: %s. Expecting %d, detected: %d", function_table[func_id].name, function_table[func_id].num_fixed_args, total_function_arguments);

  emitln("", "  call %s", function_table[func_id].name);
  // the function's return value is in register B
  if(current_func_call_total_arg_size > 0)
    emitln("", "  add sp, %d", current_func_call_total_arg_size); // clean stack of the arguments added to it

  // recover prog, placing it at the end of the function header
  prog = prog_at_end_of_header;
  emitln("", "; --- END FUNCTION CALL");
}

int get_struct_element_offset(int struct_id, char *name){
  int offset = 0;

  for(int i = 0; *struct_table[struct_id].elements[i].name; i++)
    if(!strcmp(struct_table[struct_id].elements[i].name, name))
      return offset;
    else
      offset += get_total_type_size(struct_table[struct_id].elements[i].type);
}

int get_union_element_offset(int union_id, char *name){
  return 0; // union element offsets always start at 0 since they all share the same space
}

t_type get_struct_element_type(int struct_id, char *name){
  for(int i = 0; *struct_table[struct_id].elements[i].name; i++)
    if(!strcmp(struct_table[struct_id].elements[i].name, name))
      return struct_table[struct_id].elements[i].type;
  error(ERR_FATAL, "Undeclared struct element: %s", name);
}

t_type get_union_element_type(int union_id, char *name){
  for(int i = 0; *union_table[union_id].elements[i].name; i++)
    if(!strcmp(union_table[union_id].elements[i].name, name))
      return union_table[union_id].elements[i].type;
  error(ERR_FATAL, "Undeclared union element: %s", name);
}

/* function used for dealihg with pointer arithmetic.
since for example:
char *p;
p++ increases p by one
whereas:
char **p;
p++ increases p by 2 since it is a pointer to pointer.
*/
int get_incdec_unit(t_type type){
  switch(type.primitive_type){
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
      else if(type.ind_level == 1)
        if(type.size_modifier == SIZEMOD_LONG)
          return 4;
        else
          return 2;
      else if(type.ind_level > 1)
        return 2;
      break;
  }
}

t_type emit_array_arithmetic(t_type type){
  t_type expr_out;
  int i, dims; // array data size

  expr_out = type;
  dims = array_dim_count(type); // gets the number of dimensions for this array
  emitln("", "  push a"); // needed because for loop below will modify 'a'. But 'a' is used by functions such as parse_terms, so keep previous results. so we cannot overwrite 'a' here.
  for(i = 0; i < dims; i++){
    expr_out.dims[dims - i - 1] = 0; // decrease array dimensions as they get parsed so that the final data type makes sense
    emitln("", "  push d"); // save 'd' in case the expressions inside brackets use 'd' for addressing (likely)
    parse_expr(); // result in 'b'
    emitln("", "  pop d");
    if(get_array_offset(i, type) > 1){ // optimize it so there's no multiplication if not needed
      emitln("", "  mma %u ; mov a, %u; mul a, b; add d, b", get_array_offset(i, type), get_array_offset(i, type)); // mov a, uint16_t; mul a, b; add d, b
    }
    else 
      emitln("", "  add d, b");
    if(curr_token.tok != CLOSING_BRACKET) error(ERR_FATAL, "Closing brackets expected");
    get();
    if(curr_token.tok != OPENING_BRACKET){
      back();
      break;
    }
  }
  emitln("", "  pop a");
  
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

  switch(t1.primitive_type){
    case DT_CHAR:
      switch(t2.primitive_type){
        case DT_CHAR:
          if(t1.ind_level > 0){
            type = t1;
          }
          else if(t2.ind_level > 0){
            type = t2;
          }
          else{
            type.primitive_type = DT_INT;
            type.ind_level  = 0;
            type.sign_modifier = SIGNMOD_SIGNED;
            type.dims[0] = 0;
            type.size_modifier = SIZEMOD_NORMAL;
            type.struct_enum_union_id = -1;
          }
          break;
        case DT_INT:
          if(t1.ind_level > 0){
            type = t1;
          }
          else if(t2.ind_level > 0){
            type = t2;
          }
          else{
            type = t2;
          }
      }
      break;
    case DT_INT:
      switch(t2.primitive_type){
        case DT_CHAR:
          if(t1.ind_level > 0){
            type = t1;
          }
          else if(t2.ind_level > 0){
            type = t2;
          }
          else{
            type = t1;
          }
          break;
        case DT_INT:
          if(t1.ind_level > 0){
            type = t1;
          }
          else if(t2.ind_level > 0){
            type = t2;
          }
          else{
            type = t2;
            if(t1.sign_modifier == SIGNMOD_UNSIGNED || t2.sign_modifier == SIGNMOD_UNSIGNED)
              type.sign_modifier = SIGNMOD_UNSIGNED;
            else
              type.sign_modifier = SIGNMOD_SIGNED;
          }
      }
  }
  if(t1.size_modifier == SIZEMOD_LONG || t2.size_modifier == SIZEMOD_LONG)
    type.size_modifier = SIZEMOD_LONG;
  else
    type.size_modifier = SIZEMOD_NORMAL;

  return type;
}

unsigned int add_string_data(char *str){
  int i;

  // Check if string already exists
  for(i = 0; i < string_table_tos; i++)
    if(!strcmp(string_table[i], str))
      return i;

  if(string_table_tos == STRING_TABLE_SIZE) error(ERR_FATAL, "Maximum number of string literals reached.");

  // Declare new string
  strcpy(string_table[string_table_tos], str);
  string_table_tos++;
  return string_table_tos - 1;
  
}

void emit_string_table_data(void){
  int i, j;
  char *p;

  printf("emitting string constant table data...");

  //emit_data("_s%d: .db \"%s\", 0\n", i, string_table[i]);
  for(i = 0; i < string_table_tos; i++){
    emit_data("_s%d: .db \"", i); // emit string header
    for(j = 0; ; j++){
      if(string_table[i][j] == '\0'){
        emit_data("\", 0\n");
        break;
      }
      emit_data("%c", string_table[i][j]);
      if((j + 1) % 128 == 0){
        if(string_table[i][j+1]){
          emit_data("\"\n.db \"");
        }
        else{
          emit_data("\", 0\n");
          break;
        }
      }
    }
  }
  printf(" OK\n");
}

char *get_var_base_addr(char *dest, char *var_name){
  int var_id;

  if(local_var_exists(var_name) != -1){ // is a local variable
    var_id = local_var_exists(var_name);
    if(function_table[current_func_id].local_vars[var_id].is_parameter){
      sprintf(dest, "bp + %d", function_table[current_func_id].local_vars[var_id].bp_offset);
    }
    else{
      sprintf(dest, "bp + %d", function_table[current_func_id].local_vars[var_id].bp_offset);
    }
  }
  else if(global_var_exists(var_name) != -1)  // is a global variable
    strcpy(dest, var_name);
  else 
    error(ERR_FATAL, "(get_var_base_addr) Undeclared identifier: %s", var_name);

  return dest;
}

t_type emit_var_addr_into_d(char *var_name){
  int dims, offset, var_id;
  char temp[128], element_name[ID_LEN];
  t_type type;

  if((var_id = local_var_exists(var_name)) != -1){ // is a local variable
    type = function_table[current_func_id].local_vars[var_id].type;
    if(function_table[current_func_id].local_vars[var_id].is_static){
      if(is_array(function_table[current_func_id].local_vars[var_id].type)         || 
          (function_table[current_func_id].local_vars[var_id].type.primitive_type == DT_STRUCT && 
           function_table[current_func_id].local_vars[var_id].type.ind_level == 0) ||
          (function_table[current_func_id].local_vars[var_id].type.primitive_type == DT_UNION && 
           function_table[current_func_id].local_vars[var_id].type.ind_level == 0)
      )
        emitln("", "  mov d, st_%s_%s_dt ; static %s", function_table[current_func_id].name, function_table[current_func_id].local_vars[var_id].name, function_table[current_func_id].local_vars[var_id].name);
      else
        emitln("", "  mov d, st_%s_%s ; static %s", function_table[current_func_id].name, function_table[current_func_id].local_vars[var_id].name, function_table[current_func_id].local_vars[var_id].name);
    }
    else{
      get_var_base_addr(temp, var_name);
      // both array and parameter means this is a parameter local variable to a function
      // that is really a pointer variable and not really an array.
      if(is_array(function_table[current_func_id].local_vars[var_id].type) && function_table[current_func_id].local_vars[var_id].is_parameter){
        emitln("", "  mov b, [%s] ; $%s", temp, var_name);
        emitln("", "  mov d, b");
      }
      else 
        emitln("", "  lea d, [%s] ; $%s", temp, var_name);
    }
  }
  else if((var_id = global_var_exists(var_name)) != -1){  // is a global variable
    type = global_var_table[var_id].type;
    if(is_array(global_var_table[var_id].type) || 
        (global_var_table[var_id].type.primitive_type == DT_STRUCT && global_var_table[var_id].type.ind_level == 0) ||
        (global_var_table[var_id].type.primitive_type == DT_UNION  && global_var_table[var_id].type.ind_level == 0)
    ) 
      emitln("", "  mov d, _%s_data ; $%s", global_var_table[var_id].name, global_var_table[var_id].name);
    else
      emitln("", "  mov d, _%s ; $%s", global_var_table[var_id].name, global_var_table[var_id].name);
  }
  else error(ERR_FATAL, "(emit_var_addr_into_d) Undeclared identifier: %s", var_name);

  get();
  // emit base address for variable, whether struct or not
  // then look for '.' or '[]' in each cycle, if found, add offsets
  if(curr_token.tok == OPENING_BRACKET || curr_token.tok == STRUCT_DOT || curr_token.tok == STRUCT_ARROW){ // array operations
    if(curr_token.tok == OPENING_BRACKET && !is_array(type) && type.ind_level > 0){
      emitln("", "  mov d, [d]");
    }
    do{
      if(curr_token.tok == OPENING_BRACKET){
        if(is_array(type)){
          dims = array_dim_count(type); // gets the number of dimensions for this type
          type = emit_array_arithmetic(type); // emit type final address in 'd'
        }
        // pointer indexing
        else if(type.ind_level > 0){
          emitln("", "  push a");
          emitln("", "  push d"); // save 'd' in case the expressions inside brackets use 'd' for addressing (likely)
          parse_expr(); // parse index expression, result in B
          emitln("", "  pop d");
          if(curr_token.tok != CLOSING_BRACKET) error(ERR_FATAL, "Closing brackets expected");
          emitln("", "  mma %u ; mov a, %u; mul a b; add d, b", get_data_size_for_indexing(type), get_data_size_for_indexing(type)); // mov a, uint16_t; mul a b; add d, b
          emitln("", "  pop a");
          type.ind_level--; // indexing reduces ind_level by 1
        }
        else error(ERR_FATAL, "Invalid indexing");
      }
      else if(curr_token.tok == STRUCT_DOT){
        get(); // get element name
        strcpy(element_name, curr_token.token_str);
        offset = get_struct_element_offset(type.struct_enum_union_id, element_name);
        if(type.primitive_type == DT_STRUCT)
          type = get_struct_element_type(type.struct_enum_union_id, element_name);
        else if(type.primitive_type == DT_UNION)
          type = get_union_element_type(type.struct_enum_union_id, element_name);
        emitln("", "  add d, %d", offset);
      }
      else if(curr_token.tok == STRUCT_ARROW){
        get(); // get element name
        strcpy(element_name, curr_token.token_str);
        offset = get_struct_element_offset(type.struct_enum_union_id, element_name);
        if(type.primitive_type == DT_STRUCT)
          type = get_struct_element_type(type.struct_enum_union_id, element_name);
        else if(type.primitive_type == DT_UNION)
          type = get_union_element_type(type.struct_enum_union_id, element_name);
        //get_var_base_addr(temp, var_name);
        emitln("", "  mov d, [d]");
        emitln("", "  add d, %d", offset);
      }
      get();
    } while (curr_token.tok == OPENING_BRACKET || curr_token.tok == STRUCT_DOT || curr_token.tok == STRUCT_ARROW);
    back();
  }
  else back();
  return type;
}

int get_num_array_elements(t_type type){
  int size = 1;

  for(int i = 0; type.dims[i]; i++){
    size *= type.dims[i];
  }
  return size;
}

int get_array_offset(char dim, t_type type){
  int i, offset = 1;
  
  if(dim < array_dim_count(type) - 1){
    for(i = dim + 1; i < array_dim_count(type); i++)
      offset = offset * type.dims[i];
    return offset * get_primitive_type_size(type);
  }
  else
    return 1 * get_primitive_type_size(type);
}

int is_enum(t_type type){
  return type.primitive_type == DT_ENUM;
}

int is_struct(t_type type){
  return type.primitive_type == DT_STRUCT;
}

int is_union(t_type type){
  return type.primitive_type == DT_UNION;
}

int is_array(t_type type){
  return type.dims[0] ? 1 : 0;
}

int array_dim_count(t_type type){
  int i = 0;
  
  for(i = 0; type.dims[i]; i++);
  return i;
}

int get_total_type_size(t_type type){
  int i;
  int size = 1;

  // if it is a array, return its number of dimensions * type size
  for(i = 0; i < array_dim_count(type); i++){
    size = size * type.dims[i];
  }
  
  // if it is not a array, it will return 1 * the data size
  return size * get_primitive_type_size(type);
}

int get_primitive_type_size(t_type type){
  if(type.ind_level > 0) 
    return 2;
  else switch(type.primitive_type){
    case DT_CHAR:
      return 1;

    case DT_INT:
      if(type.size_modifier == SIZEMOD_LONG)
        return 4;
      else
        return 2;

    case DT_STRUCT:
      return get_struct_size(type.struct_enum_union_id);

    case DT_UNION:
      return get_union_size(type.struct_enum_union_id);

    case DT_ENUM:
      return 2;
  }
}

int get_type_size_for_func_arg_parsing(t_type type){
  if(type.ind_level > 0) 
    return 2;
  else if(is_array(type))
    return 2;
  else switch(type.primitive_type){
    case DT_CHAR:
      return 1;

    case DT_INT:
      if(type.size_modifier == SIZEMOD_LONG)
        return 4;
      else
        return 2;

    case DT_STRUCT:
      return get_struct_size(type.struct_enum_union_id);

    case DT_UNION:
      return get_union_size(type.struct_enum_union_id);

    case DT_ENUM:
      return 2;
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
    if(struct_table[id].elements[i].type.ind_level > 0) 
      size += array_size * 2;
    else switch(struct_table[id].elements[i].type.primitive_type){
      case DT_CHAR:
        size += array_size * 1;
        break;
      case DT_INT:
        if(struct_table[id].elements[i].type.size_modifier == SIZEMOD_LONG)
          size += array_size * 4;
        else
          size += array_size * 2;
        break;
      case DT_STRUCT:
        size += array_size * get_struct_size(struct_table[id].elements[i].type.struct_enum_union_id);
        break;
      case DT_ENUM:
        size += array_size * 2;
    }
  }

  return size;
}

int get_union_size(int id){
  int size, array_size;

  size = 0;
  
  for(int i = 0; *union_table[id].elements[i].name; i++){
    array_size = get_num_array_elements(union_table[id].elements[i].type);
    if(union_table[id].elements[i].type.ind_level > 0){
      if(array_size * 2 > size) size = array_size * 2;
      //size += array_size * 2;
    }
    else 
      switch(union_table[id].elements[i].type.primitive_type){
        case DT_CHAR:
          if(array_size * 1 > size) size = array_size * 1;
          //size += array_size * 1;
          break;
        case DT_INT:
          if(union_table[id].elements[i].type.size_modifier == SIZEMOD_LONG){
            if(array_size * 4 > size) size = array_size * 4;
            size += array_size * 4;
          }
          else{
            if(array_size * 2 > size) size = array_size * 2;
            //size += array_size * 2;
          }
          break;
        case DT_STRUCT:
          if(array_size * get_struct_size(union_table[id].elements[i].type.struct_enum_union_id) > size) 
            size = array_size * get_struct_size(union_table[id].elements[i].type.struct_enum_union_id);
          //size += array_size * get_struct_size(union_table[id].elements[i].type.struct_enum_union_id);
          break;
        case DT_UNION:
          if(array_size * get_union_size(union_table[id].elements[i].type.struct_enum_union_id) > size) 
            size = array_size * get_union_size(union_table[id].elements[i].type.struct_enum_union_id);
          //size += array_size * get_union_size(union_table[id].elements[i].type.struct_enum_union_id);
          break;
        case DT_ENUM:
          if(array_size * 2 > size) size = array_size * 2;
          //size += array_size * 2;
      }
  }

  return size;
}

t_primitive_type get_primitive_type_from_tok(){
  switch(curr_token.tok){
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
    case UNION:
      return DT_UNION;
    case ENUM:
      return DT_ENUM;
    default:
      error(ERR_FATAL, "Unknown data type: %s (get_primitive_type_from_tok)", curr_token.token_str);
  }
}

int get_data_size_for_indexing(t_type type){
  if(type.ind_level >= 2) 
    return 2;
  else switch(type.primitive_type){
    case DT_CHAR:
      return 1;
    case DT_INT:
      if(type.size_modifier == SIZEMOD_LONG)
        return 4;
      else
        return 2;
    case DT_STRUCT:
      return get_struct_size(type.struct_enum_union_id);
    case DT_UNION:
      return get_union_size(type.struct_enum_union_id);
    case DT_ENUM:
      return 2;
  }
}

int function_has_variable_arguments(int func_id){
  return function_table[func_id].has_var_args;
}

void parse_struct_initialization_data(int struct_id, int array_size){
  int i, j, k;
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
        if(curr_token.tok_type == IDENTIFIER && enum_element_exists(curr_token.token_str) != -1){ // obtain enum values if curr_token.token_str is an enum element
          curr_token.int_const = get_enum_val(curr_token.token_str);
          curr_token.tok_type = INTEGER_CONST;
        }
        switch(struct_table[struct_id].elements[i].type.primitive_type){
          case DT_STRUCT:
            expect(OPENING_BRACE, "Opening braces expected for array or struct element initialization.");
            parse_struct_initialization_data(struct_table[struct_id].elements[i].type.struct_enum_union_id, 1);
            break;
          case DT_VOID:
            emit_data(".dw $%04x\n", curr_token.int_const);
            break;
          case DT_CHAR:
            if(struct_table[struct_id].elements[i].type.ind_level > 0){
              switch(curr_token.tok_type){
                case CHAR_CONST:
                  emit_data(".dw %s\n", curr_token.token_str);
                  break;
                case INTEGER_CONST:
                  emit_data(".dw $%04x\n", curr_token.int_const);
                  break;
                case STRING_CONST:
                  int string_id = add_string_data(curr_token.string_const);
                  emit_data(".dw _s%u\n", string_id);
              }
            }
            else{
              switch(curr_token.tok_type){
                case CHAR_CONST:
                  emit_data(".db %s\n", curr_token.token_str);
                  break;
                case INTEGER_CONST:
                  emit_data(".db %d\n", (char)curr_token.int_const);
                  break;
                case STRING_CONST:
                  error(ERR_FATAL, "Incompatible data type for struct element in initialization.");
              }
            }
            break;
          case DT_INT:
            switch(curr_token.tok_type){
              case CHAR_CONST:
                emit_data(".dw %s\n", curr_token.token_str);
                break;
              case INTEGER_CONST:
                emit_data(".dw %d\n", curr_token.int_const);
                break;
              case STRING_CONST:
                int string_id = add_string_data(curr_token.string_const);
                emit_data(".dw _s%u\n", string_id);
                break;
            }
            break;
        }
        if(is_array(struct_table[struct_id].elements[i].type)){
          get();
          if(curr_token.tok == CLOSING_BRACE) break;
          else if(curr_token.tok != COMMA) error(ERR_FATAL, "Comma expected in struct initialization.");
        }
      }
      get();
      if(curr_token.tok == CLOSING_BRACE) break;
      else if(curr_token.tok != COMMA) error(ERR_FATAL, "Comma expected in struct initialization.");
    }
    if(curr_token.tok == CLOSING_BRACE) break;
  }
}

void parse_union_initialization_data(int union_id, int array_size){
  int i, j, k;
  int element_array_size, total_elements;

  total_elements = get_union_elements_count(union_id);
  
  for(j = 0; j < array_size; j++){
    for(i = 0; *union_table[union_id].elements[i].name; i++){
      // Array but not union
      if(is_array(union_table[union_id].elements[i].type)){
        get(); expect(OPENING_BRACE, "Opening braces expected for array or union element initialization.");
        element_array_size = get_num_array_elements(union_table[union_id].elements[i].type);
      }
      else{
        element_array_size = 1;
      }
      // Read array elements
      for(k = 0; k < element_array_size; k++){
        get();
        if(curr_token.tok_type == IDENTIFIER && enum_element_exists(curr_token.token_str) != -1){ // obtain enum values if curr_token.token_str is an enum element
          curr_token.int_const = get_enum_val(curr_token.token_str);
          curr_token.tok_type = INTEGER_CONST;
        }
        switch(union_table[union_id].elements[i].type.primitive_type){
          case DT_STRUCT:
            expect(OPENING_BRACE, "Opening braces expected for array or union element initialization.");
            parse_union_initialization_data(union_table[union_id].elements[i].type.struct_enum_union_id, 1);
            break;
          case DT_VOID:
            emit_data(".dw $%04x\n", curr_token.int_const);
            break;
          case DT_CHAR:
            if(union_table[union_id].elements[i].type.ind_level > 0){
              switch(curr_token.tok_type){
                case CHAR_CONST:
                  emit_data(".dw %s\n", curr_token.token_str);
                  break;
                case INTEGER_CONST:
                  emit_data(".dw $%04x\n", curr_token.int_const);
                  break;
                case STRING_CONST:
                  int string_id = add_string_data(curr_token.string_const);
                  emit_data(".dw _s%u\n", string_id);
              }
            }
            else{
              switch(curr_token.tok_type){
                case CHAR_CONST:
                  emit_data(".db %s\n", curr_token.token_str);
                  break;
                case INTEGER_CONST:
                  emit_data(".db %d\n", (char)curr_token.int_const);
                  break;
                case STRING_CONST:
                  error(ERR_FATAL, "Incompatible data type for union element in initialization.");
              }
            }
            break;
          case DT_INT:
            switch(curr_token.tok_type){
              case CHAR_CONST:
                emit_data(".dw %s\n", curr_token.token_str);
                break;
              case INTEGER_CONST:
                emit_data(".dw %d\n", curr_token.int_const);
                break;
              case STRING_CONST:
                int string_id = add_string_data(curr_token.string_const);
                emit_data(".dw _s%u\n", string_id);
                break;
            }
            break;
        }
        if(is_array(union_table[union_id].elements[i].type)){
          get();
          if(curr_token.tok == CLOSING_BRACE) break;
          else if(curr_token.tok != COMMA) error(ERR_FATAL, "Comma expected in union initialization.");
        }
      }
      get();
      if(curr_token.tok == CLOSING_BRACE) break;
      else if(curr_token.tok != COMMA) error(ERR_FATAL, "Comma expected in union initialization.");
    }
    if(curr_token.tok == CLOSING_BRACE) break;
  }
}

int get_struct_elements_count(int struct_enum_union_id){
  int total;
  for(total = 0; *struct_table[struct_enum_union_id].elements[total].name; total++);
  return total;
}

int get_union_elements_count(int struct_enum_union_id){
  int total;
  for(total = 0; *union_table[struct_enum_union_id].elements[total].name; total++);
  return total;
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

int find_array_initialization_size(t_size_modifier size_modifier){
  int len = 0;
  int braces;
  get();
  expect(ASSIGNMENT, "Assignment expected");
  get();
  expect(OPENING_BRACE, "Opening braces expected");
  braces = 1;
  do{
    get();
    if(curr_token.tok == OPENING_BRACE) braces++;
    else if(curr_token.tok == CLOSING_BRACE) braces--;
    else if(curr_token.tok == COMMA) continue;
    else{
      switch(curr_token.tok_type){
        case CHAR_CONST:
          len += 1;
          break;
        case INTEGER_CONST:
          if(size_modifier == SIZEMOD_LONG)
            len += 4;
          else
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

void emit_global_var_initialization(t_var *var){
  char temp[512 + 8];
  int number_initialized_bytes, braces;
  char var_base_addr[ID_LEN];

  if(is_array(var->type)){
    emit_data("_%s_data: ", var->name);
    if(var->type.primitive_type != DT_STRUCT) emit_data_dbdw(var->type);
    number_initialized_bytes = 0;
    braces = 0;
    for(;;){
      get();
      if(curr_token.tok == OPENING_BRACE) braces++;
      else if(curr_token.tok == CLOSING_BRACE) braces--;
      else switch(var->type.primitive_type){
        case DT_VOID: // todo: fix cases where data is other than pointers
        case DT_CHAR:
          if(var->type.ind_level > 0){
            number_initialized_bytes += 1;
            if(curr_token.tok_type == INTEGER_CONST){
              emit_data("$%04x,", (uint16_t)curr_token.int_const);
            }
            else if(curr_token.tok_type == STRING_CONST){
              emit_data("_s%u, ", add_string_data(curr_token.string_const));
            }
            else if(curr_token.tok_type == IDENTIFIER){
              error(ERR_FATAL, "initializing a global var with an identifier name is not implemented yet");
            }
            else error(ERR_FATAL, "unknown data type in char array initialization");
          }
          else{
            if(curr_token.tok_type == CHAR_CONST){
              number_initialized_bytes += 1;
              emit_data("$%02x,", (uint8_t)curr_token.string_const[0]);
            }
            else if(curr_token.tok_type == INTEGER_CONST){
              number_initialized_bytes += 1;
              emit_data("$%02x,", (uint8_t)curr_token.int_const);
            }
            else if(curr_token.tok_type == STRING_CONST){
              emit_data("%s, ", curr_token.token_str);
              number_initialized_bytes += strlen(curr_token.string_const);
            }
            else error(ERR_FATAL, "unknown data type in char array initialization");
          }
          break;

        case DT_INT:
          number_initialized_bytes += 1;
          if(var->type.ind_level > 0){
            if(curr_token.tok_type == INTEGER_CONST){
              emit_data("$%04x,", (uint16_t)curr_token.int_const);
            }
            else if(curr_token.tok_type == STRING_CONST){
              emit_data("_s%u, ", add_string_data(curr_token.string_const));
            }
            else if(curr_token.tok_type == IDENTIFIER){
              error(ERR_FATAL, "initializing a global var with an identifier name is not implemented yet");
            }
            else error(ERR_FATAL, "unknown data type in char array initialization");
          }
          else{
            if(curr_token.tok_type == CHAR_CONST){
              emit_data("$%04x,", (uint16_t)curr_token.string_const[0]);
            }
            else if(curr_token.tok_type == INTEGER_CONST){
              emit_data("$%04x,", (uint16_t)curr_token.int_const);
            }
            else if(curr_token.tok_type == STRING_CONST){
              emit_data("_s%u, ", add_string_data(curr_token.string_const));
            }
            else error(ERR_FATAL, "unknown data type in char array initialization");
          }
          break;

        case DT_STRUCT:
        case DT_UNION:
          number_initialized_bytes++;
          if(var->type.ind_level > 0){
            if(curr_token.tok_type == INTEGER_CONST){
              emit_data(".dw $%04x\n", (uint16_t)curr_token.int_const);
            }
            else if(curr_token.tok_type == IDENTIFIER){
              error(ERR_FATAL, "initializing a global var with an identifier name is not implemented yet");
            }
            else error(ERR_FATAL, "unknown data type in char array initialization");
          }
          else{
            if(curr_token.tok_type == CHAR_CONST){
              emit_data(".db $%02x\n", (uint8_t)curr_token.string_const[0]);
            }
            else if(curr_token.tok_type == INTEGER_CONST){
              emit_data(".dw $%04x\n", (uint16_t)curr_token.int_const);
            }
            else if(curr_token.tok_type == STRING_CONST){
              emit_data(".dw _s%u\n", add_string_data(curr_token.string_const));
            }
            else error(ERR_FATAL, "unknown data type in char array initialization");
          }
        break;  

        default:
      } 
      if(braces == 0) break;
      get();
      if(curr_token.tok != COMMA) back();
      if((number_initialized_bytes + 1) % 16 == 0){ // split into multiple lines due to TASM limitation of how many items per .dw directive
        emit_data("\n");
        emit_data_dbdw(var->type);
      }
    }
    emit_data("\n");
    // fill in the remaining unitialized array values with 0's 
    if(var->type.primitive_type == DT_STRUCT){ // todo: temporary solution here.  counting each struct element here is wrong but that is whats happening for now. so in the end we divide by the number of elements so we get the actual number of structs initialized
      number_initialized_bytes = number_initialized_bytes / get_num_struct_elements(var->type.struct_enum_union_id);
    }
    if(get_total_type_size(var->type) - number_initialized_bytes * get_primitive_type_size(var->type) > 0){
      emit_data("\n.fill %u, 0\n", get_total_type_size(var->type) - number_initialized_bytes * get_primitive_type_size(var->type));
    }
  }
  else{
    get();
    switch(var->type.primitive_type){
      case DT_VOID:
        emit_data("_%s: ", var->name);
        emit_data(".dw $%04x, ", (uint16_t)atoi(curr_token.token_str));
        break;
      case DT_CHAR:
        if(var->type.ind_level > 0){ // if is a string
          if(curr_token.tok == AMPERSAND){
            get();
            if(curr_token.tok_type == IDENTIFIER){
              get_var_base_addr(temp, curr_token.token_str);
              if(is_array(global_var_table[search_global_var(curr_token.token_str)].type))
                emit_data("_%s: .dw _%s_data\n", var->name, temp);
              else
                emit_data("_%s: .dw _%s\n", var->name, temp);
            }
            else error(ERR_FATAL, "identifier expected after '&' operator");
          }
          else if(curr_token.tok_type == IDENTIFIER){
            get_var_base_addr(temp, curr_token.token_str);
            if(is_array(global_var_table[search_global_var(curr_token.token_str)].type))
              emit_data("_%s: .dw _%s_data\n", var->name, temp);
            else 
              error(ERR_FATAL, "idenfitier referenced in global var initialization is not an array. for non-array variables the '&' operator is needed to reference the variable's address");
          }
          else{
            if(curr_token.tok_type != STRING_CONST) error(ERR_FATAL, "String constant expected");
            emit_data("_%s_data: ", var->name);
            emit_data_dbdw(var->type);
            emit_data("%s, 0\n", curr_token.token_str);
            emit_data("_%s: .dw _%s_data\n", var->name, var->name);
          }
        }
        else{
          emit_data("_%s: ", var->name);
          emit_data_dbdw(var->type);
          if(curr_token.tok_type == CHAR_CONST)
            emit_data("$%02x\n", (uint8_t)curr_token.string_const[0]);
          else if(curr_token.tok_type == INTEGER_CONST)
            emit_data("$%02x\n", (uint8_t)curr_token.int_const);
          else
            error(ERR_FATAL, "unknown data type in global var initialization");
        }
        break;
      case DT_INT:
        if(var->type.ind_level > 0){ // if is a string
          if(curr_token.tok == AMPERSAND){
            get();
            if(curr_token.tok_type == IDENTIFIER){
              get_var_base_addr(temp, curr_token.token_str);
              if(is_array(global_var_table[search_global_var(curr_token.token_str)].type))
                emit_data("_%s: .dw _%s_data\n", var->name, temp);
              else
                emit_data("_%s: .dw _%s\n", var->name, temp);
            }
            else error(ERR_FATAL, "identifier expected after '&' operator");
          }
          else if(curr_token.tok_type == IDENTIFIER){
            get_var_base_addr(temp, curr_token.token_str);
            if(is_array(global_var_table[search_global_var(curr_token.token_str)].type))
              emit_data("_%s: .dw _%s_data\n", var->name, temp);
            else 
              error(ERR_FATAL, "idenfitier referenced in global var initialization is not an array. for non-array variables the '&' operator is needed to reference the variable's address");
          }
          else{
            emit_data("_%s: .dw $%04x\n", var->name, (uint16_t)curr_token.int_const);
          }
        }
        else{
          emit_data("_%s: ", var->name);
          if(curr_token.tok_type == CHAR_CONST)
            emit_data("$%04x\n", (uint16_t)curr_token.string_const[0]);
          else if(curr_token.tok_type == INTEGER_CONST){
            if(var->type.size_modifier == SIZEMOD_LONG){
              emit_data(".dw $%04x\n", (uint16_t)(curr_token.int_const & 0x0000FFFF));
              emit_data(".dw $%04x\n", (uint16_t)(curr_token.int_const >> 16));
            }
            else{
              emit_data(".dw $%04x\n", (uint16_t)curr_token.int_const);
            }
          }
          else
            error(ERR_FATAL, "unknown data type in global var initialization");
        }
        break;
      case DT_STRUCT:
        if(curr_token.tok_type == IDENTIFIER){
          get_var_base_addr(temp, curr_token.token_str);
          emit_data("_%s: .dw _%s_data\n", var->name, temp);
        }
        else{ // value is a constant
          emit_data("_%s: .dw %s\n", var->name, curr_token.token_str);
        }
        break;
      case DT_UNION:
        if(curr_token.tok_type == IDENTIFIER){
          get_var_base_addr(temp, curr_token.token_str);
          emit_data("_%s: .dw _%s_data\n", var->name, temp);
        }
        else{ // value is a constant
          emit_data("_%s: .dw %s\n", var->name, curr_token.token_str);
        }
    }
  }
  get();
}

int get_num_struct_elements(int struct_id){
  int i;
  for(i = 0; *struct_table[struct_id].elements[i].name; i++);
  return i;
}

void emit_static_var_initialization(t_var *var){
  int number_initialized_bytes;
  int braces;

  if(is_array(var->type)){
    get();
    expect(OPENING_BRACE, "Opening braces expected");
    emit_data("\nst_%s_%s_dt: \n", function_table[current_func_id].name, var->name);
    emit_data_dbdw(var->type);
    number_initialized_bytes = 0;
    braces = 1;
    for(;;){
      get();
      if(curr_token.tok == OPENING_BRACE) braces++;
      else if(curr_token.tok == CLOSING_BRACE) braces--;
      if(braces == 0) break;

      switch(var->type.primitive_type){
        case DT_VOID: // todo: fix cases where data is other than pointers
        case DT_CHAR:
          if(var->type.ind_level > 0){
            number_initialized_bytes += 1;
            if(curr_token.tok_type == INTEGER_CONST){
              emit_data("$%04x,", (uint16_t)curr_token.int_const);
            }
            else if(curr_token.tok_type == STRING_CONST){
              emit_data("_s%u, ", add_string_data(curr_token.string_const));
            }
            else if(curr_token.tok_type == IDENTIFIER){
              error(ERR_FATAL, "initializing a global var with an identifier name is not implemented yet");
            }
          }
          else{
            if(curr_token.tok_type == CHAR_CONST){
              number_initialized_bytes += 1;
              emit_data("$%02x,", (uint8_t)curr_token.string_const[0]);
            }
            else if(curr_token.tok_type == INTEGER_CONST){
              number_initialized_bytes += 1;
              emit_data("$%02x,", (uint8_t)curr_token.int_const);
            }
            else if(curr_token.tok_type == STRING_CONST){
              emit_data("%s, ", curr_token.token_str);
              number_initialized_bytes += strlen(curr_token.string_const);
            }
          }
          break;

        case DT_INT:
          number_initialized_bytes += 1;
          if(var->type.ind_level > 0){
            if(curr_token.tok_type == INTEGER_CONST){
              emit_data("$%04x,", (uint16_t)curr_token.int_const);
            }
            else if(curr_token.tok_type == STRING_CONST){
              emit_data("_s%u, ", add_string_data(curr_token.string_const));
            }
            else if(curr_token.tok_type == IDENTIFIER){
              error(ERR_FATAL, "initializing a global var with an identifier name is not implemented yet");
            }
          }
          else{
            if(var->type.size_modifier == SIZEMOD_LONG){
              if(curr_token.tok_type == CHAR_CONST){
                emit_data("$%04x,", (uint16_t)curr_token.string_const[0]);
                emit_data("$0000, ");
              }
              else if(curr_token.tok_type == INTEGER_CONST){
                if(curr_token.const_size_modifier == SIZEMOD_LONG){
                  emit_data("$%04x, ", (uint16_t)(curr_token.int_const & 0x0000FFFF));
                  emit_data("$%04x, ", (uint16_t)(curr_token.int_const >> 16));
                }
                else
                  emit_data("$%04x,", (uint16_t)curr_token.int_const);
              }
              else if(curr_token.tok_type == STRING_CONST){
                emit_data("_s%u, ", add_string_data(curr_token.string_const));
              }
            }
            else{
              if(curr_token.tok_type == CHAR_CONST){
                emit_data("$%04x,", (uint16_t)curr_token.string_const[0]);
              }
              else if(curr_token.tok_type == INTEGER_CONST){
                emit_data("$%04x,", (uint16_t)curr_token.int_const);
              }
              else if(curr_token.tok_type == STRING_CONST){
                emit_data("_s%u, ", add_string_data(curr_token.string_const));
              }
            }
          }
          break;

        default:
      } 
/*
      if(curr_token.tok_type == CHAR_CONST)
        emit_data("$%x,", curr_token.string_const[0]);
      else if(curr_token.tok_type == INTEGER_CONST)
        emit_data("%u,", (char)atoi(curr_token.token_str));
      else if(curr_token.tok_type == STRING_CONST){
        int string_id;
        string_id = add_string_data(curr_token.string_const);
        emit_data("_s%u, ", string_id);
      }
      if(curr_token.tok_type == CHAR_CONST    || 
         curr_token.tok_type == INTEGER_CONST || 
         curr_token.tok_type == STRING_CONST
      )
        j++;
      */
      // {1, 2, {1, 2, 3}, 4, 3, {2, 3}}
      get(); // get comma or '}'
      if(curr_token.tok != COMMA) back();
      if(number_initialized_bytes % 30 == 0){ // split into multiple lines due to TASM limitation of how many items per .dw directive
        emit_data("\n");
        emit_data_dbdw(var->type);
      }
    }
    // fill in the remaining unitialized array values with 0's 
    if(get_total_type_size(var->type) - number_initialized_bytes * get_primitive_type_size(var->type) > 0){
      emit_data("\n");
      emit_data(".fill %u, 0\n", get_total_type_size(var->type) - number_initialized_bytes * get_primitive_type_size(var->type));
    }
    //emit_data("\nst_%s_%s: .dw st_%s_%s_dt\n", function_table[current_func_id].name, var->name, function_table[current_func_id].name, var->name);
  }
  else{
    get();
    switch(var->type.primitive_type){
      case DT_VOID:
        emit_data("st_%s_%s: ", function_table[current_func_id].name, var->name);
        emit_data_dbdw(var->type);
        emit_data("%u, ", atoi(curr_token.token_str));
        break;

      case DT_CHAR:
        if(var->type.ind_level > 0){ // if is a string
          if(curr_token.tok_type != STRING_CONST) error(ERR_FATAL, "String constant expected");
          emit_data("st_%s_%s_dt: ", function_table[current_func_id].name, var->name);
          emit_data_dbdw(var->type);
          emit_data("%s, 0\n", curr_token.token_str); // TODO: do not require char pointer initialization to be a string only!
          emit_data("st_%s_%s: .dw st_%s_%s_dt\n", function_table[current_func_id].name, var->name, function_table[current_func_id].name, var->name);
        }
        else{
          emit_data("st_%s_%s: ", function_table[current_func_id].name, var->name);
          emit_data_dbdw(var->type);
          if(curr_token.tok_type == CHAR_CONST)
            emit_data("$%02x\n", curr_token.string_const[0]);
          else if(curr_token.tok_type == INTEGER_CONST)
            emit_data("$%02x\n", (uint8_t)(curr_token.int_const));
        }
        break;

      case DT_INT:
        emit_data("st_%s_%s: ", function_table[current_func_id].name, var->name);
        emit_data_dbdw(var->type);
        if(var->type.ind_level > 0)
          emit_data("$%04x\n", (uint16_t)(curr_token.int_const));
        else{
          if(var->type.size_modifier == SIZEMOD_LONG){
            if(curr_token.const_size_modifier == SIZEMOD_LONG){
              emit_data("$%04x, ", (uint16_t)(curr_token.int_const & 0x0000FFFF));
              emit_data("$%04x, ", (uint16_t)(curr_token.int_const >> 16));
            }
            else{
              emit_data("$%04x\n", (uint16_t)(curr_token.int_const));
            }
          }
          else{
            emit_data("$%04x\n", (uint16_t)(curr_token.int_const));
          }
        }
        break;
    }
  }
  get();
}

uint8_t type_is_32bit(t_type type){
  return type.primitive_type == DT_INT && type.ind_level == 0 && type.size_modifier == SIZEMOD_LONG;
}

void emit_data_dbdw(t_type type){
  if((type.ind_level == 1 && type.primitive_type == DT_CHAR && type.dims[0] == 0) || 
     (type.ind_level == 0 && type.primitive_type == DT_CHAR) ||
     (type.primitive_type == DT_STRUCT && type.ind_level == 0)
  ) 
    emit_data(".db ");
  else
    emit_data(".dw ");
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

char token_not_a_const(void){
  return curr_token.tok_type != CHAR_CONST && curr_token.tok_type != INTEGER_CONST && curr_token.tok_type != STRING_CONST;
}

t_var get_internal_var_ptr(char *var_name){
  register int i;

  //check local variables whose function id is the id of current function being parsed
  for(i = 0; i < function_table[current_func_id].local_var_tos; i++)
    if(!strcmp(function_table[current_func_id].local_vars[i].name, var_name))
      return function_table[current_func_id].local_vars[i];

  for(i = 0; (i < global_var_tos) && (*global_var_table[i].name); i++)
    if(!strcmp(global_var_table[i].name, var_name)) return global_var_table[i];
  
  error(ERR_FATAL, "Undeclared variable: %s", var_name);
}

void expect(t_tok tok, char *message){
  if(curr_token.tok != tok) error(ERR_FATAL, message);
}

void expect_type(t_tok tok, char *message){
  if(curr_token.tok != tok) error(ERR_FATAL, message);
}

// converts a literal string or char constant into constants with TRUE escape sequences
void convert_constant(){
  char *s = curr_token.string_const;
  char *t = curr_token.token_str;
  
  if(curr_token.tok_type == CHAR_CONST){
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
  else if(curr_token.tok_type == STRING_CONST){
    do{
      t++; // skip '"'
      while(*t != '"'){
        *s++ = *t++;
      }
      t++; // skip '"'
      while(is_space(*t)){
        t++;
      }
    } while(*t == '"');
  }
  *s = '\0';
}

void get_asm(void){
  char *t;

  // skip blank spaces
  *curr_token.token_str = '\0';
  curr_token.tok = TOK_UNDEF;
  curr_token.tok_type = TYPE_UNDEF;
  t = curr_token.token_str;
  
  // Save the position of prog before getting a curr_token.token_str. If an 'unexpected token' error occurs,
  // the position of prog before lines were skipped, will be known.  
  prog_before_error = prog;

/* Skip comments and whitespaces */
  do{
    while(is_space(*prog)) prog++;
    if(*prog == ';'){
      while(*prog != '\n') prog++;
      prog++;
    }
  } while(is_space(*prog) || (*prog == ';'));

  if(*prog == '\0'){
    curr_token.tok_type = END;
    curr_token.tok = END_OF_PROG;
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
    else
      *t++ = *prog++;
    if(*prog != '\'')
      error(ERR_FATAL, "Single quotes expected");
    *t++ = '\'';
    prog++;
    curr_token.tok_type = CHAR_CONST;
    *t = '\0';
    convert_constant(); // converts this string curr_token.token_str with quotation marks to a non quotation marks string, and also converts escape sequences to their real bytes
  }
  else if(*prog == '\"'){
    *t++ = *prog++;
    while(*prog != '\"' && *prog){
      *t++ = *prog++;
    }
    if(*prog != '\"') error(ERR_FATAL, "Double quotes expected");
    *t++ = *prog++;
    *t = '\0';
    curr_token.tok_type = STRING_CONST;
    convert_constant(); // converts this string curr_token.token_str qith quotation marks to a non quotation marks string, and also converts escape sequences to their real bytes
  }
  else if(is_digit(*prog) || *prog == '$' && is_hex_digit(*(prog+1))){
    curr_token.tok_type = INTEGER_CONST;
    curr_token.const_size_modifier = SIZEMOD_NORMAL;
    curr_token.const_sign_modifier = SIGNMOD_SIGNED;
    if(*prog == '0' && *(prog+1) == 'x'){
      *t++ = *prog++;
      *t++ = *prog++;
      while(is_hex_digit(*prog)) *t++ = *prog++;
      *t = '\0';
      sscanf(curr_token.token_str, "%lx", &curr_token.int_const);
    }
    else if(*prog == '$'){
      *t++ = *prog++;
      while(is_hex_digit(*prog)) *t++ = *prog++;
      *t = '\0';
      sscanf(curr_token.token_str, "%lx", &curr_token.int_const);
    }
    else{
      while(is_digit(*prog)){
        *t++ = *prog++;
      }
      *t = '\0';
      sscanf(curr_token.token_str, "%ld", &curr_token.int_const);
    }
    return; // return to avoid *t = '\0' line at the end of function
  }
  else if(isalpha(*prog) || *prog == '_'){
    while(isalpha(*prog) || *prog == '_' || is_digit(*prog)){
      *t++ = *prog++;
    }
    *t = '\0';

    if((curr_token.tok = search_keyword(curr_token.token_str)) != -1) 
      curr_token.tok_type = RESERVED;
    else 
      curr_token.tok_type = IDENTIFIER;
  }
  else if(is_delimiter(*prog)){
    curr_token.tok_type = DELIMITER;  
    
    if(*prog == '['){
      *t++ = *prog++;
      curr_token.tok = OPENING_BRACKET;
    }
    else if(*prog == ']'){
      *t++ = *prog++;
      curr_token.tok = CLOSING_BRACKET;
    }
    else if(*prog == ':'){
      *t++ = *prog++;
      curr_token.tok = COLON;
    }
    else if(*prog == '+'){
      *t++ = *prog++;
      curr_token.tok = PLUS;
    }
    else if(*prog == '-'){
      *t++ = *prog++;
      curr_token.tok = MINUS;
    }
    else if(*prog == '@'){
      *t++ = *prog++;
      curr_token.tok = AT;
    }
    else if(*prog == '('){
      *t++ = *prog++;
      curr_token.tok = OPENING_PAREN;
    }
    else if(*prog == ')'){
      *t++ = *prog++;
      curr_token.tok = CLOSING_PAREN;
    }
    else if(*prog == ','){
      *t++ = *prog++;
      curr_token.tok = COMMA;
    }
    else if(*prog == '.'){
      *t++ = *prog++;
      curr_token.tok = STRUCT_DOT;
    }
  }

  *t = '\0';
}

void get(void){
  char *t;

  // skip blank spaces
  *curr_token.token_str = '\0';
  curr_token.tok = TOK_UNDEF;
  curr_token.tok_type = TYPE_UNDEF;
  t = curr_token.token_str;
  
  // Save the position of prog before getting a curr_token.token_str. If an 'unexpected token' error occurs,
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
    curr_token.tok_type = END;
    curr_token.tok = END_OF_PROG;
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
    else
      *t++ = *prog++;
    if(*prog != '\'')
      error(ERR_FATAL, "Single quotes expected");
    *t++ = '\'';
    prog++;
    curr_token.tok_type = CHAR_CONST;
    *t = '\0';
    convert_constant(); // converts this string curr_token.token_str with quotation marks to a non quotation marks string, and also converts escape sequences to their real bytes
  }
  else if(*prog == '"'){
    do{
      *t++ = *prog++; // start the string
      while(*prog != '"' && *prog){
        *t++ = *prog++;
      }
      if(*prog != '"'){
        error(ERR_FATAL, "ending double quotes expected");
      }
      *t++ = *prog++;
      while(is_space(*prog)) *t++ = *prog++;
    } while(*prog == '"');
    *t = '\0';
    curr_token.tok_type = STRING_CONST;
    convert_constant(); // converts this string curr_token.token_str qith quotation marks to a non quotation marks string, and also converts escape sequences to their real bytes
  }
  else if(is_digit(*prog) || *prog == '-' && is_digit(*(prog+1))){
    curr_token.tok_type = INTEGER_CONST;
    curr_token.const_size_modifier = SIZEMOD_NORMAL;
    curr_token.const_sign_modifier = SIGNMOD_SIGNED;
    if(*prog == '-') *t++ = *prog++;
    if(*prog == '0' && *(prog+1) == 'x'){
      *t++ = *prog++;
      *t++ = *prog++;
      while(is_hex_digit(*prog)) *t++ = *prog++;
      *t = '\0';
      sscanf(curr_token.token_str, "%lx", &curr_token.int_const);
    }
    else{
      while(is_digit(*prog)){
        *t++ = *prog++;
      }
      *t = '\0';
      sscanf(curr_token.token_str, "%ld", &curr_token.int_const);
    }
    if(*prog == 'L' || *prog == 'l' || *prog == 'u' || *prog == 'U'){
      while(*prog == 'L' || *prog == 'l' || *prog == 'u' || *prog == 'U'){
        if(*prog == 'L' || *prog == 'l')
          curr_token.const_size_modifier = SIZEMOD_LONG;
        else if(*prog == 'U' || *prog == 'u')
          curr_token.const_sign_modifier = SIGNMOD_UNSIGNED;
        *t++ = *prog++;
      }
      *t = '\0';
    }
    else{
      if(curr_token.int_const > 32767 && curr_token.int_const <= 65535)
        curr_token.const_sign_modifier = SIGNMOD_UNSIGNED;
      else if(curr_token.int_const > 65535 && curr_token.int_const <= 2147483647)
        curr_token.const_size_modifier = SIZEMOD_LONG;
      else if(curr_token.int_const > 2147483647){
        curr_token.const_size_modifier = SIZEMOD_LONG;
        curr_token.const_sign_modifier = SIGNMOD_UNSIGNED;
      }
      else if(curr_token.int_const > 4294967295){
        error(ERR_WARNING, "constant value exceed maximum value of unsigned long int: %d", curr_token.int_const);
      }
      else if(curr_token.int_const >= -2147483648 && curr_token.int_const < -32768)
        curr_token.const_size_modifier = SIZEMOD_LONG;
      else if(curr_token.int_const < -2147483648)
        error(ERR_WARNING, "constant value exceed maximum value of unsigned long int: %d", curr_token.int_const);
    }
    return; // return to avoid *t = '\0' line at the end of function
  }
  else if(isalpha(*prog) || *prog == '_'){
    while(isalpha(*prog) || *prog == '_' || is_digit(*prog)){
      *t++ = *prog++;
    }
    *t = '\0';

    if((curr_token.tok = search_keyword(curr_token.token_str)) != -1) 
      curr_token.tok_type = RESERVED;
    else 
      curr_token.tok_type = IDENTIFIER;
  }
  else if(is_delimiter(*prog)){
    curr_token.tok_type = DELIMITER;  
    
    if(*prog == '#'){
      *t++ = *prog++;
      curr_token.tok = DIRECTIVE;
    }
    else if(*prog == '{'){
      *t++ = *prog++;
      curr_token.tok = OPENING_BRACE;
    }
    else if(*prog == '}'){
      *t++ = *prog++;
      curr_token.tok = CLOSING_BRACE;
    }
    else if(*prog == '['){
      *t++ = *prog++;
      curr_token.tok = OPENING_BRACKET;
    }
    else if(*prog == ']'){
      *t++ = *prog++;
      curr_token.tok = CLOSING_BRACKET;
    }
    else if(*prog == '='){
      *t++ = *prog++;
      if (*prog == '='){
        *t++ = *prog++;
        curr_token.tok = EQUAL;
      }
      else 
        curr_token.tok = ASSIGNMENT;
    }
    else if(*prog == '&'){
      *t++ = *prog++;
      if(*prog == '&'){
        *t++ = *prog++;
        curr_token.tok = LOGICAL_AND;
      }
      else
        curr_token.tok = AMPERSAND;
    }
    else if(*prog == '|'){
      *t++ = *prog++;
      if (*prog == '|'){
        *t++ = *prog++;
        curr_token.tok = LOGICAL_OR;
      }
      else 
        curr_token.tok = BITWISE_OR;
    }
    else if(*prog == '~'){
      *t++ = *prog++;
      curr_token.tok = BITWISE_NOT;
    }
    else if(*prog == '<'){
      *t++ = *prog++;
      if (*prog == '='){
        *t++ = *prog++;
        curr_token.tok = LESS_THAN_OR_EQUAL;
      }
      else if (*prog == '<'){
        *t++ = *prog++;
        curr_token.tok = BITWISE_SHL;
      }
      else
        curr_token.tok = LESS_THAN;
    }
    else if(*prog == '>'){
      *t++ = *prog++;
      if (*prog == '='){
        *t++ = *prog++;
        curr_token.tok = GREATER_THAN_OR_EQUAL;
      }
      else if (*prog == '>'){
        *t++ = *prog++;
        curr_token.tok = BITWISE_SHR;
      }
      else 
        curr_token.tok = GREATER_THAN;
    }
    else if(*prog == '!'){
      *t++ = *prog++;
      if(*prog == '='){
        *t++ = *prog++;
        curr_token.tok = NOT_EQUAL;
      }
      else 
        curr_token.tok = LOGICAL_NOT;
    }
    else if(*prog == '?'){
      *t++ = *prog++;
      curr_token.tok = TERNARY_OP;
    }
    else if(*prog == '+'){
      *t++ = *prog++;
      if(*prog == '+'){
        *t++ = *prog++;
        curr_token.tok = INCREMENT;
      }
      else 
        curr_token.tok = PLUS;
    }
    else if(*prog == '-'){
      *t++ = *prog++;
      if(*prog == '-'){
        *t++ = *prog++;
        curr_token.tok = DECREMENT;
      }
      else if(*prog == '>'){
        *t++ = *prog++;
        curr_token.tok = STRUCT_ARROW;
      }
      else 
        curr_token.tok = MINUS;
    }
    else if(*prog == '$'){
      *t++ = *prog++;
      curr_token.tok = DOLLAR;
    }
    else if(*prog == '^'){
      *t++ = *prog++;
      curr_token.tok = BITWISE_XOR;
    }
    else if(*prog == '@'){
      *t++ = *prog++;
      curr_token.tok = AT;
    }
    else if(*prog == '*'){
      *t++ = *prog++;
      curr_token.tok = STAR;
    }
    else if(*prog == '/'){
      *t++ = *prog++;
      curr_token.tok = FSLASH;
    }
    else if(*prog == '%'){
      *t++ = *prog++;
      curr_token.tok = MOD;
    }
    else if(*prog == '('){
      *t++ = *prog++;
      curr_token.tok = OPENING_PAREN;
    }
    else if(*prog == ')'){
      *t++ = *prog++;
      curr_token.tok = CLOSING_PAREN;
    }
    else if(*prog == ';'){
      *t++ = *prog++;
      curr_token.tok = SEMICOLON;
    }
    else if(*prog == ':'){
      *t++ = *prog++;
      curr_token.tok = COLON;
    }
    else if(*prog == ','){
      *t++ = *prog++;
      curr_token.tok = COMMA;
    }
    else if(*prog == '.'){
      *t++ = *prog++;
      if(*prog == '.' && *(prog+1) == '.'){
        *t++ = *prog++;
        *t++ = *prog++;
        curr_token.tok = VAR_ARG_DOTS;
      }
      else curr_token.tok = STRUCT_DOT;
    }
  }

  *t = '\0';
}

void back(void){
  char *t = curr_token.token_str;
  
  while(*t){
    prog--;
    t++;
  }
  curr_token.tok = TOK_UNDEF;
  curr_token.tok_type = TYPE_UNDEF;
  curr_token.token_str[0] = '\0';
}

void push_prog(){
  if(prog_tos == 2048) error(ERR_FATAL, "cannot push prog. Stack overflow.");
  prog_stack[prog_tos] = prog;
  prog_tos++;
}

void pop_prog(){
  if(prog_tos == 0) error(ERR_FATAL, "cannot pop prog. Stack overflow.");
  prog_tos--;
  prog = prog_stack[prog_tos];
}

void get_line(void){
  char *t;

  t = curr_token.string_const;
  *t = '\0';
  
  while(*prog != 0x0A && *prog){
    *t++ = *prog++;
  }

  if(*prog == '\0' && curr_token.string_const[0] == '\0') error(ERR_FATAL, "Unexpected EOF");

  while(is_space(*prog)) prog++;
  *t = '\0';
}

void error(t_error_type error_type, const char* format, ...){
  int line = 1;
  char tempbuffer[TEMP_BUFFER_SIZE];
  char error_token[256];
  char *temp_prog;
  va_list args;

  char *tok_to_str(t_tok tok){
    for(int i=0; token_to_str[i].token; i++){
      if(tok == token_to_str[i].token) return token_to_str[i].as_str;
    }
    return NULL;
  }

  va_start(args, format);
  vsnprintf(tempbuffer, sizeof(tempbuffer), format, args);
  va_end(args);

  temp_prog = prog;  
  strcpy(error_token, curr_token.token_str);

  prog = c_in;
  while(prog != prog_before_error){
    if(*prog == '\n') line++;
    prog++;
  }

  printf("\n************************************************");

  if(error_type == ERR_WARNING)
    printf("\n* warning       : %s\n", tempbuffer);
  else 
    printf("\n* error         : %s\n", tempbuffer);

  printf("* in function   : %s\n", function_table[current_func_id].name);
  printf("* at line %05d : ", line);
  while(*prog != '\n' && prog != c_in) prog--;
  prog++;
  while(*prog != '\n') putchar(*prog++);
  printf("\n");
  printf("* token string  : %s\n", error_token);
  printf("* string const  : %s\n", curr_token.string_const);
  printf("* int const     : %ld\n", curr_token.int_const);
  printf("* tok           : %s\n", tok_to_str(curr_token.tok));
  printf("* toktype       : %s\n", tok_type_to_str[curr_token.tok_type].as_str);
  printf("************************************************\n");

  if(error_type == ERR_WARNING)
    prog = temp_prog;
  else
    exit(1);
}


char* basename(char* path) {
  static char bname[1024];
  char *last_slash;

  // Handle NULL input
  if (path == NULL || *path == '\0') {
    bname[0] = '.';
    bname[1] = '\0';
    return bname;
  }

  // Strip trailing slashes
  size_t len = strlen(path);
  while (len > 1 && path[len - 1] == '/') {
    path[--len] = '\0';
  }

  // Find the last slash in the path
  last_slash = strrchr(path, '/');
  if (last_slash != NULL) {
    // Return the part after the last slash
    strncpy(bname, last_slash + 1, sizeof(bname) - 1);
    bname[sizeof(bname) - 1] = '\0';
  } else {
    // No slash found, return the whole path
    strncpy(bname, path, sizeof(bname) - 1);
    bname[sizeof(bname) - 1] = '\0';
  }

  return bname;
}