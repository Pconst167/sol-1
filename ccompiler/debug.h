#include "definitions.h"
#include <stdio.h>
#include <stdlib.h>


extern char *primitive_type_to_str_table[];
extern t_function function_table[MAX_USER_FUNC];
extern t_typedef typedef_table[MAX_TYPEDEFS];
extern int typedef_table_tos;
extern int function_table_tos;

void dbg(char *s);
void print_function_table(void);
void print_typedef_table();
void dbg_print_var_info(t_var var);
void dbg_print_function_info(t_function function);
void dbg_print_type_info(t_type type);