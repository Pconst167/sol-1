#include "debug.h"

void dbg(char *s){
  puts(s);
  exit(0);
}

void print_function_table(void){
  for(int i = 0; i < function_table_tos; i++)
    dbg_print_function_info(&function_table[i]);
}

void print_typedef_table(){
  int i, j;

  printf("TYPEDEF TABLE:\n");

  for(i = 0; i < typedef_table_tos; i++){
    printf("Typedef Name: %s\n", typedef_table[i].name);

    printf("Primitive type: %s\n", primitive_type_to_str_table[typedef_table[i].type.primitive_type]);
    printf("Indirection: %d\n", typedef_table[i].type.ind_level);
    printf("Struct ID: %d\n", typedef_table[i].type.struct_id);

    for(j = 0; typedef_table[i].type.dims[j]; j++){
      printf("Dims[%d]: %d\n", j, typedef_table[i].type.dims[j]);
    }
  }
}

void dbg_print_var_info(t_var *var){
  int i;
  int local = 0;

  if(local_var_exists(var->name) != -1) local = 1;
  printf("Name: %s\n", var->name);
  printf("Scope: %s\n", local ? "Local" : "Global");
  printf("Func Name: %s\n", function_table[var->function_id].name);
  printf("Is Parameter: %d\n", var->is_parameter);
  printf("Is Static: %d\n", var->is_static);
  printf("Basic Type: %s\n", primitive_type_to_str_table[var->type.primitive_type]);
  for(i = 0; var->type.dims[i]; i++)
    printf("Dims[%d]: %d\n", i, var->type.dims[i]);
  printf("Ind Level: %d\n", var->type.ind_level);
  printf("modifier: %d\n", var->type.size_modifier);
  printf("sign_modifier: %d\n", var->type.sign_modifier);
  printf("Struct ID: %d\n", var->type.struct_id);
  printf("*******************************************\n");
}

void dbg_print_function_info(t_function *function){
  int i, j;

  printf("function name: %s\n", function->name);
  printf("RETURN TYPE INFO:\n");
  dbg_print_type_info(&function->return_type);
  printf("PARAMETER LIST:\n");
  for(i = 0; function->local_vars[i].name && function->local_vars[i].is_parameter ; i++){
    printf("parameter[%d] Name: %s\n", i, function->local_vars[i].name);
    printf("ind level: %d\n", function->local_vars[i].type.ind_level);
    printf("size modifier: %d\n", function->local_vars[i].type.size_modifier);
    printf("sign modifier: %d\n", function->local_vars[i].type.sign_modifier);
    printf("struct id: %d\n", function->local_vars[i].type.struct_id);
    if(function->local_vars[i].type.dims[0]){
      for(j = 0; function->local_vars[i].type.dims[j]; j++){
        printf("Dim %d: %d\n", j, function->local_vars[i].type.dims[j]);
      }
    }
  }
  printf("*******************************************\n");
}

void dbg_print_type_info(t_type *type){
  int i;

  printf("basic type: %s\n", primitive_type_to_str_table[type->primitive_type]);
  for(i = 0; type->dims[i]; i++)
    printf("dims[%d]: %d\n", i, type->dims[i]);
  printf("ind level: %d\n", type->ind_level);
  printf("size modifier: %d\n", type->size_modifier);
  printf("sign modifier: %d\n", type->sign_modifier);
  printf("struct id: %d\n", type->struct_id);
  printf("*******************************************\n");
}