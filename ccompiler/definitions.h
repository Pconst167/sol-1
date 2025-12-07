#include <stdint.h>

#pragma once
#define TOKEN_LEN                  4096
#define CONST_LEN                  4096
#define ID_LEN                     512
#define FUNCTION_SIZE_MAX_LEN      6 * 1024
#define MAX_DEFINES                512
#define MAX_DEFINE_LEN             4096
#define MAX_ENUM_DECLARATIONS      32
#define MAX_ENUM_ELEMENTS          64
#define MAX_GLOBAL_VARS            512
#define MAX_GOTO_LABELS_PER_FUNC   32
#define MAX_LOCAL_VARS             128
#define MAX_MATRIX_DIMS            8
#define MAX_STRUCT_DECLARATIONS    64
#define MAX_STRUCT_ELEMENTS        32
#define MAX_UNION_DECLARATIONS     64
#define MAX_UNION_ELEMENTS         32
#define CLASS_DECLARATIONS         32
#define MAX_CLASS_VARIABLES        64
#define MAX_CLASS_METHODS          64
#define MAX_TYPEDEFS               128
#define MAX_USER_FUNC              512
#define PROG_SIZE                  512 * 1024
#define STRING_TABLE_SIZE          4096
#define ASM_SIZE                   512 * 1024
#define TEMP_BUFFER_SIZE           4 * 1024

#define STRINGIFY(x) #x
#define TOSTRING(x) STRINGIFY(x)

#define tkn curr_token.token_str
#define tokt curr_token.toktype

typedef enum {FALSE = 0, TRUE} t_bool;

typedef enum {ERR_WARNING, ERR_FATAL} t_error_type;

typedef enum{
  LOCAL = 0, GLOBAL
} t_var_scope;

typedef enum{
  FOR_LOOP, WHILE_LOOP, DO_LOOP, SWITCH_CONSTRUCT
} t_loop_type;

// basic data types
typedef enum {
  DT_VOID = 1, DT_CHAR, DT_INT, DT_FLOAT, DT_DOUBLE, DT_STRUCT, DT_ENUM, DT_UNION, DT_FUNCPTR
} t_primitive_type;

typedef enum {
  SIZEMOD_NORMAL, SIZEMOD_SHORT, SIZEMOD_LONG
} t_size_modifier;

typedef enum {
  SIGNMOD_SIGNED = 0, SIGNMOD_UNSIGNED
} t_sign_modifier;

typedef enum {
  TOK_UNDEF = 0, 
  END_OF_PROG,

  AMPERSAND,
  ASM,
  SYSTEM,
  ASSIGNMENT,
  AT,
  AUTO,
  BITWISE_NOT,
  BITWISE_OR,
  BITWISE_SHL,
  BITWISE_SHR,
  BITWISE_XOR,
  BREAK,
  CARET,
  CASE,
  CHAR,
  CLOSING_BRACE,
  CLOSING_BRACKET,
  CLOSING_PAREN,
  COLON,
  COMMA,
  CONST,
  CONTINUE,
  DECREMENT,
  DEFAULT,
  DEFINE,
  DEF_IFDEF,
  DEF_ENDIF,
  DIRECTIVE, 
  DO,
  DOLLAR,
  DOUBLE,
  ELSE,
  ENUM,
  EQUAL,
  EXTERN,
  FLOAT,
  FOR,
  FSLASH,
  GOTO,
  GREATER_THAN,
  GREATER_THAN_OR_EQUAL,
  IF,
  INCLUDE, 
  INCREMENT,
  INT,
  LESS_THAN,
  LESS_THAN_OR_EQUAL,
  LOGICAL_AND,
  LOGICAL_NOT,
  LOGICAL_OR,
  LONG,
  MINUS,
  MOD,
  NOT_EQUAL,
  OPENING_BRACE,
  OPENING_BRACKET,
  OPENING_PAREN,
  PLUS,
  PRAGMA, 
  RETURN,
  SEMICOLON,
  SHORT,
  SIGNED,
  SIZEOF,
  STAR,
  VOLATILE,
  STATIC,
  REGISTER,
  STRUCT,
  STRUCT_ARROW,
  STRUCT_DOT,
  SWITCH,
  TERNARY_OP,
  TYPEDEF,
  UNION,
  UNSIGNED,
  VAR_ARG_DOTS,
  VOID,
  WHILE
} t_tok; // internal token representation

typedef enum {
  CHAR_CONST, 
  DELIMITER,
  DOUBLE_CONST,
  END,
  FLOAT_CONST,
  IDENTIFIER, 
  INTEGER_CONST,
  RESERVED, 
  STRING_CONST, 
  TYPE_UNDEF
} t_tok_type;

typedef struct{
  char *keyword;
  t_tok key;
} keyword_table_t;

typedef struct{
  char name[ID_LEN];
  char content[MAX_DEFINE_LEN];
} defines_table_t;

typedef struct{
  t_tok_type      tok_type;
  t_tok           tok;
  char            token_str[TOKEN_LEN];            // string token representation
  char            string_const[TOKEN_LEN];  // holds string and char constants without quotes and with escape sequences converted into the correct bytes
  long int        int_const;
  t_size_modifier const_size_modifier;
  t_sign_modifier const_sign_modifier;
  char            *addr;
} t_token;

typedef struct{
  char name[ID_LEN]; // enum name
  struct{
    char name[ID_LEN];
    int value;
  } elements[MAX_ENUM_ELEMENTS];
} t_enum;

typedef struct {
  t_primitive_type primitive_type;
  t_sign_modifier  sign_modifier;
  t_size_modifier  size_modifier;
  t_bool           is_func_ptr;
  t_bool           is_constant; // is it a constant?
  t_bool           ind_level; // holds the pointer indirection level
  int16_t          struct_enum_union_id; // struct ID or enum ID if var is a struct or enum
  uint16_t         dims[MAX_MATRIX_DIMS];
} t_type;

typedef struct{
  char name[ID_LEN];
  t_type type;
} t_typedef;

typedef struct{
  char name[ID_LEN];
  struct{
    char name[ID_LEN];
    t_type type;
  } elements[MAX_STRUCT_ELEMENTS];
} t_struct;

typedef struct{
  char name[ID_LEN];
  struct{
    char name[ID_LEN];
    t_type type;
  } elements[MAX_UNION_ELEMENTS];
} t_union;

typedef struct {
  char    name[ID_LEN];
  t_type  type; // holds the type of data and the value itself
  t_bool  is_parameter;
  t_bool  is_volatile;
  t_bool  is_static;
  t_bool  is_register;
  int     bp_offset; // if var is local, this holds the offset of the var from BP.
  int     function_id; // the function does var belong to? (if it is a local var)
} t_var;

typedef struct {
  char     name[ID_LEN];
  t_type   return_type;
  char     *code_location;
  t_var    local_vars[MAX_LOCAL_VARS];
  uint16_t local_var_tos;
  uint16_t total_parameter_size;
  char     goto_labels_table[MAX_GOTO_LABELS_PER_FUNC][ID_LEN];
  int      goto_labels_table_tos;
  uint8_t  has_var_args;
  uint8_t  num_fixed_args;
  t_bool   is_static;
} t_function;

typedef struct{
  char *start;
  char *end;
} t_function_endpoints;

typedef struct{
  char name[ID_LEN];
  t_function_endpoints endpoints;
} t_included_function_list_item;

// functions
char         is_delimiter(char c);
char         is_identifier_char(char c);
int          local_var_exists(char *var_name);
int          global_var_exists(char *var_name);
void         load_program(char *filename);
void         pre_scan(void);
void         generate_file(char *filename);
void         pre_processor(void);
void         include_asm_lib(char *lib_name);
unsigned int add_string_data(char *str);

void         get_asm(void);
void         get(void);
void         get_line(void);
void         back(void);
void         print_info(const char* format, ...);
void         error(t_error_type error_type, const char* format, ...);
void         expect(t_tok _tok, char *message);

int          declare_enum(void);
void         declare_typedef(void);
int          declare_struct(void);
int          declare_union(void);
void         declare_func(void);
void         declare_global(void);
int          declare_local(void);
void         declare_struct_global_vars(int struct_id);
void         parse_struct_initialization_data(int struct_id, int array_size);
void         declare_goto_label(void);
void         declare_define(void);

int          enum_element_exists(char *element_name);

void         emit_c_header_line(void);
void         emit(const char* format, ...);
void         emitln(char *comment, const char* format, ...);
void         emit_datablock_asm();
void         emit_data(const char* format, ...);
void         emit_data_dbdw(t_type type);
void         emit_string_table_data(void);
t_type       emit_array_arithmetic(t_type type);
void         emit_global_var_initialization(t_var *var);
void         emit_static_var_initialization(t_var *var);
t_type       emit_var_addr_into_d(char *var_name);

void         skip_statements(void);
void         skip_block(int braces);
void         skip_case(void);

int          count_cases(void);

t_type       parse_expr(void);
t_type       parse_assignment(void);
t_type       parse_ternary_op(void);
t_type       parse_logical_and(void);
t_type       parse_logical_or(void);
t_type       parse_bitwise_and(void);
t_type       parse_bitwise_or(void);
t_type       parse_bitwise_xor(void);
t_type       parse_relational(void);
t_type       parse_bitwise_shift(void);
t_type       parse_terms(void);
t_type       parse_factors(void);
t_type       parse_atomic(void);

t_type       parse_sizeof();
t_type       parse_string_const();
t_type       parse_integer_const();
t_type       parse_unary_logical_not();
t_type       parse_bitwise_not();
t_type       parse_unary_minus();
t_type       parse_char_const();
t_type       parse_post_decrementing(t_type expr_in, char *temp_name);
t_type       parse_post_incrementing(t_type expr_in, char *temp_name);
t_type       parse_pre_decrementing();
t_type       parse_pre_incrementing();
t_type       parse_referencing();
t_type       parse_dereferencing(void);

void         parse_case(void);
void         parse_block(void);
void         parse_functions(void);
void         parse_return(void);
void         parse_for(void);
void         parse_if(void);
void         parse_switch(void);
void         parse_while(void);
void         parse_do(void);
void         parse_continue(void);
void         parse_break(void);
void         parse_asm(void);
void         parse_system(void);
void         parse_directive(void);
int          parse_variable_args(void);
void         parse_function_call(int func_id);
void         parse_goto(void);

t_type       cast(t_type t1, t_type t2);

int              get_num_array_elements(t_type type);
int              get_array_offset(char dim, t_type array);
int              get_data_size_for_indexing(t_type type);
int              get_enum_val(char *element_name);
int              get_total_func_fixed_param_size(void);
t_var            get_internal_var_ptr(char *var_name);
int              get_total_type_size(t_type type);
char            *get_var_base_addr(char *dest, char *var_name);
int              get_param_size(void);
int              get_incdec_unit(t_type type);
int              get_primitive_type_size(t_type type);
int              get_type_size_for_func_arg_parsing(t_type type);
int              get_struct_size(int id);
int              get_union_size(int id);
int              get_struct_elements_count(int struct_id);
int              get_struct_element_offset(int struct_id, char *name);
t_type           get_struct_element_type(int struct_id, char *name);
t_primitive_type get_primitive_type_from_tok(void);
int              is_struct(t_type type);
int              is_enum(t_type type);

int find_array_initialization_size(t_size_modifier modifier);
int is_array(t_type type);
int array_dim_count(t_type type);


char is_hex_digit(char c);
char is_digit(char c);


void dbg_print_var_info(t_var var);
void dbg_print_type_info(t_type type);
void dbg_print_function_info(t_function function);

void print_typedef_table(void);
void print_function_table(void);
char find_cmdline_switch(int argc, char **argv, char *_switch);


void insert_runtime(void);
void declare_heap_global_var(void);
void overwrite_with_spaces(char *start, int len);
void delete(char *start, int len);
void insert(char *destination, char *new_text);

int is_register(char *name);
int is_assignment(void);
void push_prog(void);
void pop_prog(void);


char is_space(char c);

char is_constant(char *varname);
void dbg(char *s);
int function_has_variable_arguments(int func_id);


char token_not_a_const(void);
uint8_t type_is_32bit(t_type type);
int8_t type_detected(void);
t_type get_type();


char is_delimiter(char c);
char is_hex_digit(char c);
char is_digit(char c);
char is_identifier_char(char c);
char is_space(char c);


void build_referenced_func_list(void);
void expand_all_included_files(void);


int insert_var_name(char *name, char array[32][ID_LEN]);

char *find_next_func_header();
char* basename(char* path);
int optimize_asm();
void search_and_add_func();
t_function_endpoints locate_function(char *location, char *name);
void fetch_included_functions(char *func_loc);
void declare_all_defines();
void declare_union_global_vars(int union_id);
void parse_union_initialization_data(int union_id, int array_size);
int get_union_elements_count(int struct_enum_union_id);
int get_union_element_offset(int union_id, char *name);
t_type get_union_element_type(int union_id, char *name);
void add_included_function_to_list(char *name);
t_included_function_list_item find_included_function(char *name);
uint8_t is_function_declaration();
void add_library_type_declarations();
int get_num_struct_elements(int struct_id);
int undeclare_local(char *name);
char *find_next(char *first, char *second);
char *find_between(char *first, char *second, char *begin, char *end);
int count_total_lines(char *text);