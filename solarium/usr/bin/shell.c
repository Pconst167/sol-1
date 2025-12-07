// Solarium Shell Environment

#include <stdio.h>
#include <stdlib.h>
#include "lib/token.h"

#define MAX_SHELL_VARIABLES 10

char *transient_area;
char command[512];
char path[256], temp[256];
char argument[256];

enum e_shell_var_type {SHELL_VAR_TYP_STR, SHELL_VAR_TYP_INT};

char last_cmd[128]; 

struct t_shell_var{
  char varname[16];
  char var_type;
  char *as_string;
  int as_int;
} variables[MAX_SHELL_VARIABLES];
int vars_tos;

int main(){
  char *p;
  char *t;
  char *temp_prog;
  char varname[ID_LEN];
  char is_assignment;
  char variable_str[128];
  int variable_int;
  int var_index;
  int i;

  new_str_var("path", "", 64);
  new_str_var("home", "", 64);
  read_config("/etc/shell.cfg", "path", variables[0].as_string);
  read_config("/etc/shell.cfg", "home", variables[1].as_string);

  for(;;){
    printf("root@Sol-1:"); 
    print_cwd(); 
    printf(" # ");
    gets(command);
    printf("\n\r");
    if(command[0]) strcpy(last_cmd, command);
    prog = command;
    // Loop through the shell command
    for(;;){
      temp_prog = prog;
      get();
      if(tok == SEMICOLON) get();
      if(toktype == END) break; // check for empty input
      is_assignment = 0;
      if(toktype == IDENTIFIER){
        strcpy(varname, token);
        get();
        is_assignment = tok == ASSIGNMENT;
      }
      if(is_assignment){
        get();
        if(toktype == INTEGER_CONST) set_int_var(varname, atoi(token));
        else if(toktype == STRING_CONST) new_str_var(varname, string_const, strlen(string_const));
        else if(toktype == IDENTIFIER) new_str_var(varname, token, strlen(token));
      }
      else{
        prog = temp_prog;
        get();
        if(!strcmp(token, "cd")) command_cd();
        else if(!strcmp(token, "shell")) command_shell();
        // Execute as a program.
        else{
          back();
          get_path();
          strcpy(path, token); // save file path
          for(i = 0; i < 256; i++) argument[i] = 0;
          get();
          if(tok != SEMICOLON && toktype != END){
            back();
            // get argument
            p = argument;
            do{
              if(*prog == '$'){
                prog++;
                get(); // get variable name
                var_index = get_var_index(token);
                if(var_index != -1){
                  if(get_var_type(token) == SHELL_VAR_TYP_INT) strcat(argument, "123");
                  else if(get_var_type(token) == SHELL_VAR_TYP_STR) strcat(argument, get_shell_var_strval(var_index));
                  while(*p) p++;
                }
              }
              else *p++ = *prog++;
            } while(*prog != '\0' && *prog != ';');
            *p = '\0';
          }
          if(*path == '/' || *path == '.') spawn_new_proc(path, argument);
          else{
            temp_prog = prog;
            prog = variables[0].as_string;
            for(;;){
              get();
              if(toktype == END){
                //printf("Command not found.\n");
                break;
              }
              else back();

              get_path();
              strcpy(temp, token);
              strcat(temp, "/");
              strcat(temp, path); // form full filepath with ENV_PATH + given filename
              if(file_exists(temp) != 0){
                spawn_new_proc(temp, argument);
                break;
              }
              get(); // get separator
            }
            prog = temp_prog;
          }
        }
      }
    }
  }
}

void last_cmd_insert(){
  if(last_cmd[0]){
    strcpy(command, last_cmd);
    printf(command);
  }
}

int new_str_var(char *varname, char *strval, int size){
  variables[vars_tos].var_type = SHELL_VAR_TYP_STR;
  variables[vars_tos].as_string = alloc(64);
  strcpy(variables[vars_tos].varname, varname);
  strcpy(variables[vars_tos].as_string, strval);
  vars_tos++;

  return vars_tos - 1;
}

int set_str_var(char *varname, char *strval){
  int var_index;
  // Check if variable is pre-existing
  for(var_index = 0; var_index < vars_tos; var_index++){
    if(!strcmp(variables[var_index].varname, varname)){
      strcpy(variables[var_index].as_string, strval);
      return var_index;
    }
  }
  printf("Error: Variable does not exist.");
}

int set_int_var(char *varname, int as_int){
  int i;
  // Check if variable is pre-existing
  for(i = 0; i < vars_tos; i++){
    if(!strcmp(variables[i].varname, varname)){
      variables[vars_tos].as_int = as_int;
      return i;
    }
  }
  variables[vars_tos].var_type = SHELL_VAR_TYP_INT;
  strcpy(variables[vars_tos].varname, varname);
  variables[vars_tos].as_int = as_int;
  vars_tos++;

  return vars_tos - 1;
}

int get_var_index(char *varname){
  int i;
  for(i = 0; i < vars_tos; i++)
    if(!strcmp(variables[i].varname, varname)) return i;
  return -1;
}

int get_var_type(char *varname){
  int i;
  for(i = 0; i < vars_tos; i++)
    if(!strcmp(variables[i].varname, varname)) return variables[i].var_type;
  return -1;
}

int show_var(char *varname){
  int i;
  for(i = 0; i < vars_tos; i++){
    if(!strcmp(variables[i].varname, varname)){
      if(variables[i].var_type == SHELL_VAR_TYP_INT){
        printf("%d", variables[i].as_int);
      }
      else if(variables[i].var_type == SHELL_VAR_TYP_STR){
        printf(variables[i].as_string);
      }
      return i;
    }
  }
  error("Undeclared variable.");
}

char *get_shell_var_strval(int index){
  return variables[index].as_string;
}

int get_shell_var_intval(int index){
  return variables[index].as_int;
}



int file_exists(char *filename){
  int file_exists;
  asm{
    ccmovd filename
    mov d, [d]
    mov al, 21
    syscall sys_filesystem
    ccmovd file_exists
    mov [d], a
  }
  return file_exists;
}

void command_cd(){
  int dirID;

  *path = '\0';
  get();
  if(toktype == END || tok == SEMICOLON || tok == BITWISE_NOT){
    back();
    cd_to_dir(variables[1].as_string);
  }
  else{
    for(;;){
      strcat(path, token);
      get();
      if(toktype == END) break;
      else if(tok == SEMICOLON){
        back();
        break;
      }
    }
    cd_to_dir(path);
  }
}


void cd_to_dir(char *dir){
  int dirID;
  asm{
    ccmovd dir
    mov d, [d]
    mov al, 19
    syscall sys_filesystem ; get dirID in 'A'
    ccmovd dirID
    mov d, [d]
    mov [d], a ; set dirID
    push a
  }
  if(dirID != -1){
    asm{
      pop a
      mov b, a
      mov al, 3
      syscall sys_filesystem
    }
  }
  else{
    asm{
      pop a
    }
  }
}

void print_cwd(){
  asm{
    mov al, 18
    syscall sys_filesystem        ; print current directory
  }
}

int spawn_new_proc(char *executable_path, char *args){
  asm{
    ccmovd args
    mov b, [d]
    ccmovd executable_path
    mov d, [d]
    syscall sys_spawn_proc
  }
}

void command_shell(){

}

void command_fg(){

}

int read_config(char *filename, char *entry_name, char *value){
  transient_area = alloc(16385);
  *value = '\0';
  // Swap pointers because of nested function calls
  loadfile(filename, transient_area);
  prog = transient_area;

  for(;;){
    get();
    if(toktype == END) break;
    if(!strcmp(entry_name, token)){
      get(); // get '='
      for(;;){
        get();
        if(!strcmp(token, ";")) return;
        strcat(value, token);
      }
    }
  }
  free(16385);
}

