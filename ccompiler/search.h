#include "definitions.h"
#include <string.h>

int search_global_var(char *var_name);
int search_struct(char *name);
int search_union(char *name);
int search_enum(char *name);
int search_function_parameter(int function_id, char *param_name);
int search_function(char *name);
int search_keyword(char *keyword);
int search_define(char *name);
int search_typedef(char *name);
int search_string(char *str);