#include "search.h"

extern defines_table_t defines_table[MAX_DEFINES];
extern keyword_table_t keyword_table[];
extern t_struct struct_table[MAX_STRUCT_DECLARATIONS];
extern t_union union_table[MAX_UNION_DECLARATIONS];
extern t_enum enum_table[MAX_ENUM_DECLARATIONS];
extern t_typedef typedef_table[MAX_TYPEDEFS];
extern t_function function_table[MAX_USER_FUNC];
extern char string_table[STRING_TABLE_SIZE][TOKEN_LEN];
extern t_var global_var_table[MAX_GLOBAL_VARS];

extern int string_table_tos;
extern int global_var_tos;
extern int function_table_tos;
extern int defines_tos;
extern int enum_table_tos;
extern int struct_table_tos;
extern int union_table_tos;
extern int typedef_table_tos;

int search_global_var(char *var_name){
  register int i;
  
  for(i = 0; i < global_var_tos; i++)
    if(!strcmp(global_var_table[i].name, var_name)) return i;
  
  return -1;
}

int search_enum(char *name){
  int i;
  
  for(i = 0; i < enum_table_tos; i++)
    if(!strcmp(enum_table[i].name, name)) return i;
  return -1;
}

int search_union(char *name){
  int i;
  
  for(i = 0; i < union_table_tos; i++)
    if(!strcmp(union_table[i].name, name)) return i;
  return -1;
}

int search_struct(char *name){
  int i;
  
  for(i = 0; i < struct_table_tos; i++)
    if(!strcmp(struct_table[i].name, name)) return i;
  return -1;
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

int search_keyword(char *keyword){
  register int i;
  
  for(i = 0; keyword_table[i].key; i++)
    if (!strcmp(keyword_table[i].keyword, keyword)) return keyword_table[i].key;
  
  return -1;
}

int search_define(char *name){
  int i;
  for(i = 0; i < defines_tos; i++)
    if(!strcmp(defines_table[i].name, name)) return i;
  return -1;
}

int search_typedef(char *name){
  int i;
  for(i = 0; i < typedef_table_tos; i++){
    if(!strcmp(typedef_table[i].name, name)) return i;
  }
  return -1;
}

int search_string(char *str){
  int i;

  for(i = 0; i < string_table_tos; i++) 
    if(!strcmp(string_table[i], str)) 
      return i;

  return -1;
}