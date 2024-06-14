#define CONST_LEN                  128
#define ID_LEN                     128
#define MAX_DEFINES                128
#define MAX_ENUM_DECLARATIONS      128
#define MAX_ENUM_ELEMENTS          128
#define MAX_ERRORS                 4
#define MAX_GLOBAL_VARS            128
#define MAX_GOTO_LABELS_PER_FUNC   32
#define MAX_LOCAL_VARS             128
#define MAX_MATRIX_DIMS            10
#define MAX_STRUCT_DECLARATIONS    128
#define MAX_STRUCT_ELEMENTS        32
#define MAX_TYPEDEFS               128
#define MAX_USER_FUNC              128
#define PROG_SIZE                  1024 * 1024
#define STRING_CONST_SIZE          512
#define STRING_TABLE_SIZE          256

#define MAX_CLASS_DECLARATIONS     64
#define MAX_CLASS_PROPERTIES       64
#define MAX_CLASS_METHODS          64

#define true 1
#define false 0

typedef enum {
  TOK_UNDEF = 0, 
  END_OF_PROG,

  AMPERSAND,
  ASM,
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
  INLINE,
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
  REGISTER,
  RETURN,
  SEMICOLON,
  SHORT,
  SIGNED,
  SIZEOF,
  STAR,
  STATIC,
  CLASS,
  PRIVATE,
  PUBLIC,
  PROTECTED,
  CONSTRUCTOR,
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
  VOLATILE,
  WHILE
} t_token; // internal token representation

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
} t_token_type;

struct{
  char *as_str;
  t_token token;
} token_to_str[] = {
  "undefined",               TOK_UNDEF,
  "ampersand = bitwise_and", AMPERSAND, 
  "asm",                     ASM,
  "assignment",              ASSIGNMENT,
  "at",                      AT, 
  "auto",                    AUTO,
  "bitwise_not",             BITWISE_NOT, 
  "bitwise_or",              BITWISE_OR, 
  "bitwise_shl",             BITWISE_SHL,
  "bitwise_shr",             BITWISE_SHR,
  "bitwise_xor",             BITWISE_XOR, 
  "break",                   BREAK,
  "caret",                   CARET, 
  "case",                    CASE,
  "char",                    CHAR,
  "closing_brace",           CLOSING_BRACE,
  "closing_bracket",         CLOSING_BRACKET,
  "closing_paren",           CLOSING_PAREN,
  "colon",                   COLON,
  "comma",                   COMMA,
  "const",                   CONST,
  "continue",                CONTINUE,
  "decrement",               DECREMENT,
  "default",                 DEFAULT,
  "define",                  DEFINE,
  "ifdef",                   DEF_IFDEF,
  "endif",                   DEF_ENDIF,
  "directive",               DIRECTIVE, 
  "do",                      DO,
  "dollar",                  DOLLAR, 
  "double",                  DOUBLE,
  "else",                    ELSE,
  "enum",                    ENUM,
  "equal",                   EQUAL, 
  "extern",                  EXTERN,
  "float",                   FLOAT,
  "for",                     FOR,
  "fslash",                  FSLASH,
  "goto",                    GOTO,
  "greater_than",            GREATER_THAN, 
  "greater_than_or_equal",   GREATER_THAN_OR_EQUAL, 
  "if",                      IF,
  "include",                 INCLUDE, 
  "increment",               INCREMENT,
  "inline",                  INLINE,
  "int",                     INT,
  "less_than",               LESS_THAN, 
  "less_than_or_equal",      LESS_THAN_OR_EQUAL, 
  "logical_and",             LOGICAL_AND, 
  "logical_not",             LOGICAL_NOT, 
  "logical_or",              LOGICAL_OR, 
  "long",                    LONG,
  "minus",                   MINUS,
  "mod",                     MOD,
  "not_equal",               NOT_EQUAL, 
  "opening_brace",           OPENING_BRACE,
  "opening_bracket",         OPENING_BRACKET,
  "opening_paren",           OPENING_PAREN,
  "plus",                    PLUS,
  "pragma",                  PRAGMA, 
  "register",                REGISTER,
  "return",                  RETURN,
  "semicolon",               SEMICOLON,
  "short",                   SHORT,
  "signed",                  SIGNED,
  "sizeof",                  SIZEOF,
  "star",                    STAR,
  "static",                  STATIC,
  "class",                   CLASS,
  "private",                 PRIVATE,
  "public",                  PUBLIC,
  "protected",               PROTECTED,
  "constructor",             CONSTRUCTOR,
  "struct",                  STRUCT,
  "struct_arrow",            STRUCT_ARROW,
  "struct_dot",              STRUCT_DOT,
  "switch",                  SWITCH,
  "ternary_op",              TERNARY_OP, 
  "tok_undef",               TOK_UNDEF,                                            
  "typedef",                 TYPEDEF,
  "union",                   UNION,
  "unsigned",                UNSIGNED,
  "void",                    VOID,
  "volatile",                VOLATILE,
  "while",                   WHILE
};

typedef struct{
  t_token_type type;
  t_token tok;
  char token[ID_LEN]; 
  char *addr;
  int int_const;
  char string_const[STRING_CONST_SIZE];
  char c;
} t_Token;

typedef unsigned char _bool;

typedef enum{
  LOCAL = 0, GLOBAL
} t_var_scope;

typedef enum{
  FOR_LOOP, WHILE_LOOP, DO_LOOP, SWITCH_CONSTRUCT
} t_loop_type;

typedef union {
  char c;
  short int i;
  short int p; // pointer value. 2 bytes since Sol-1 integers/pointers are 2 bytes long
  float f;
  double d;
} t_value;

// basic data types
typedef enum {
  DT_VOID = 1, DT_CHAR, DT_INT, DT_FLOAT, DT_DOUBLE, DT_STRUCT, DT_CLASS
} t_primitive_type;

typedef enum {
  MOD_NORMAL, MOD_SHORT, MOD_LONG
} t_modifier;

typedef enum {
  SNESS_SIGNED = 0, SNESS_UNSIGNED
} t_signedness;

typedef struct{
  char name[ID_LEN]; // enum name
  struct{
    char name[ID_LEN];
    int value;
  } elements[MAX_ENUM_ELEMENTS];
} t_enum;

typedef struct {
  t_primitive_type primitive_type;
  t_signedness signedness;
  t_modifier modifier;
  char is_constant; // is it a constant?
  int ind_level; // holds the pointer indirection level
  int struct_id; // struct ID if var is a struct
  int class_id;
  int dims[MAX_MATRIX_DIMS];
} t_type;

typedef struct{
  char name[ID_LEN];
  t_type type;
} t_typedef;

typedef struct{
  char name[ID_LEN];
  int elements_tos; // work this into the code so that the last element in structs is given by this, rather than relying on a null element name.
  struct{
    char name[ID_LEN];
    t_type type;
  } elements[MAX_STRUCT_ELEMENTS];
} t_struct;

typedef struct {
  char name[ID_LEN];
  t_type type; // holds the type of data and the value itself
  _bool is_parameter;
  char is_static;
  int bp_offset; // if var is local, this holds the offset of the var from BP.
  int function_id; // the function does var belong to? (if it is a local var)
} t_var;

typedef struct {
  char name[ID_LEN];
  t_type return_type;
  char *code_location;
  t_var local_vars[MAX_LOCAL_VARS];
  int local_var_tos;
  int total_parameter_size;
  char goto_labels_table[MAX_GOTO_LABELS_PER_FUNC][ID_LEN];
  int goto_labels_table_tos;
  char _inline;
  char has_var_args;
  char num_fixed_args;
} t_function;

typedef enum {AS_PRIVATE, AS_PUBLIC, AS_PROTECTED} t_access_specifier ;

typedef struct{
  char name[ID_LEN];
  unsigned int constructor_index;
  int properties_tos;
  int methods_tos;
  struct{
    char name[ID_LEN];
    t_type type;
    t_access_specifier access_specifier;
  } properties[MAX_CLASS_PROPERTIES];
  struct{
    t_function method;
    t_access_specifier access_specifier;
  } methods[MAX_CLASS_METHODS];
} t_class;

char *primitive_type_to_str_table[] = {
  "unused",
  "void",
  "char",
  "int",
  "float",
  "double",
  "struct"
};

struct _keyword_table{
  char *keyword;
  t_token key;
} keyword_table[] = {
  "include",  INCLUDE,
  "pragma",   PRAGMA,
  "define",   DEFINE,
  "ifdef",    DEF_IFDEF,
  "endif",    DEF_ENDIF,
  "asm",      ASM,
  "inline",   INLINE,

  "register", REGISTER,
  "auto",     AUTO,
  "volatile", VOLATILE,
  "extern",   EXTERN,
  "typedef",  TYPEDEF,
  "static",   STATIC,
  "const",    CONST,
  "signed",   SIGNED,
  "unsigned", UNSIGNED,
  "long",     LONG,

  "void",     VOID,
  "char",     CHAR,
  "int",      INT,
  "float",    FLOAT,
  "double",   DOUBLE,
  "enum",     ENUM,
  "union",    UNION,
  "struct",   STRUCT,
  "sizeof",   SIZEOF,
  
  "class",       CLASS,
  "private",     PRIVATE,
  "public",      PUBLIC,
  "protected",   PROTECTED,
  "constructor", CONSTRUCTOR,

  "if",       IF,
  "else",     ELSE,
  "for",      FOR,
  "do",       DO,
  "break",    BREAK,
  "continue", CONTINUE,
  "while",    WHILE,
  "switch",   SWITCH,
  "case",     CASE,
  "default",  DEFAULT,
  "goto",     GOTO,
  "return",   RETURN,
  "",         0
};


char *runtime_argc_argv_getter = "\n\n\
  char *arg_p, *arg_line_p;\n\
  char *psrc, *pdest;\n\
  char arg[64];\n\
  int arg_len;\n\
\n\
  argc = 0;\n\
  arg_line_p = 0;\n\
  for(;;){\n\
    arg_p = arg;\n\
    arg_len = 0;\n\
    while(*arg_line_p == ' ' || *arg_line_p == '\\t') arg_line_p++;\n\
    if(!*arg_line_p) break;\n\
    while(*arg_line_p != ' ' && *arg_line_p != ';' && *arg_line_p){\n\
      if(*arg_line_p == '\\\\') arg_line_p++;\n\
      *arg_p++ = *arg_line_p++;\n\
      arg_len++;\n\
    }\n\
    *arg_p = '\\0';\n\
    argv[argc] = heap_top;\n\
    heap_top = heap_top + arg_len + 1;\n\
    psrc = arg;\n\
    pdest = argv[argc];\n\
    while(*psrc) *pdest++ = *psrc++;\n\
    *pdest = '\\0';\n\
    argc++;\n\
  }\n";

char libc_directory[] = "./lib/";

char debug;

struct{
  char name[ID_LEN];
  char content[256];
} defines_table[MAX_DEFINES];

struct{
  char *as_str;
  t_token_type toktype;
} toktype_to_str[] = {
  "char constant", CHAR_CONST, 
  "delimiter", DELIMITER,
  "double constant", DOUBLE_CONST,
  "end", END,
  "float constant", FLOAT_CONST, 
  "identifier", IDENTIFIER, 
  "integer constant", INTEGER_CONST, 
  "reserved", RESERVED, 
  "string constant", STRING_CONST, 
  "undefined", TYPE_UNDEF
};

t_typedef typedef_table[MAX_TYPEDEFS];
t_function function_table[MAX_USER_FUNC];
t_enum enum_table[MAX_ENUM_DECLARATIONS];
t_struct struct_table[MAX_STRUCT_DECLARATIONS];
t_class class_table[MAX_CLASS_DECLARATIONS];
t_var global_var_table[MAX_GLOBAL_VARS];
char string_table[STRING_TABLE_SIZE][STRING_CONST_SIZE];

int override_return_is_last_statement; // used to indicate a return statement was found while executing an IF.
                // i.e if a return is found but is inside an IF, then it is not a true final
                // return statement inside a function.
int current_function_var_bp_offset;  // this is used to position local variables correctly relative to BP.
int current_func_id;
int function_table_tos;
int global_var_tos;
int enum_table_tos;
int struct_table_tos;
int class_table_tos;
int defines_tos;
int typedef_table_tos;

char *prog_stack[256];
int prog_tos;

char include_kernel_exp = 1;
char org[64] = "text_org";
int include_files_total_lines;
char included_functions_table[512][ID_LEN];

t_token_type toktype;
t_token tok;
char token[CONST_LEN];            // string token representation
char string_const[STRING_CONST_SIZE];  // holds string and char constants without quotes and with escape sequences converted into the correct bytes
t_modifier const_modifier;
int int_const;
char *prog;                           // pointer to the current program position
char c_in[PROG_SIZE];               // C program-in buffer
char include_file_buffer[PROG_SIZE];     // buffer for reading in include files
char asm_out[PROG_SIZE];             // ASM output
char *asm_p;
char *data_p;
char asm_line[2048];
char includes_list_asm[1024];         // keeps a list of all included files
char data_block_asm[PROG_SIZE];
char *data_block_p;
char tempbuffer[PROG_SIZE];
char *prog_before_error;

t_token return_is_last_statement;
t_loop_type current_loop_type;      // is it a for, while, do, or switch?
t_loop_type loop_type_stack[64];
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


// functions
char is_delimiter(char c);
char is_identifier_char(char c);
int search_keyword(char *keyword);
int local_var_exists(char *var_name);
int global_var_exists(char *var_name);
void load_program(char *filename);
void pre_scan(void);
void generate_file(char *filename);
void pre_processor(void);
void include_asm_lib(char *lib_name);
unsigned int add_string_data(char *str);

void get(void);
void get_line(void);
void back(void);
void print_info(const char* format, ...);
void warning(const char* format, ...);
void error(const char* format, ...);
void expect(t_token _tok, char *message);

void declare_enum(void);
void declare_typedef(void);
int declare_class(void);
int declare_struct(void);
void declare_func(void);
void declare_global(void);
int declare_local(void);
void declare_all_locals(int function_id);
void declare_struct_global_vars(int struct_id);
void parse_struct_initialization_data(int struct_id, int array_size);
void declare_goto_label(void);
void declare_define(void);


int declare_class();

int search_global_var(char *var_name);
int search_class(char *name);
int search_struct(char *name);
int search_string(char *str);
int search_define(char *name);
int search_function(char *func_name);
int search_function_parameter(int function_id, char *param_name);
int enum_element_exists(char *element_name);

void emit_c_line(void);
void emit(const char* format, ...);
void emitln(const char* format, ...);
void emit_data(const char* format, ...);
void emit_data_dbdw(t_type type);
void emit_string_table_data(void);
t_type emit_array_arithmetic(t_type type);
void emit_global_var_initialization(t_var *var);
void emit_static_var_initialization(t_var *var);
void emit_var_assignment__addr_in_d(t_type type);
t_type emit_var_addr_into_d(char *var_name);

void skip_statements(void);
void skip_block(void);
void skip_case(void);

int count_cases(void);

t_type parse_expr(void);
t_type parse_assignment(void);
t_type parse_ternary_op(void);
t_type parse_logical(void);
t_type parse_logical_and(void);
t_type parse_logical_or(void);
t_type parse_bitwise_and(void);
t_type parse_bitwise_or(void);
t_type parse_bitwise_xor(void);
t_type parse_relational(void);
t_type parse_bitwise_shift(void);
t_type parse_terms(void);
t_type parse_factors(void);
t_type parse_atomic(void);

t_type parse_sizeof();
t_type parse_string_const();
t_type parse_integer_const();
t_type parse_unary_logical_not();
t_type parse_bitwise_not();
t_type parse_unary_minus();
t_type parse_char_const();
t_type parse_post_decrementing(t_type expr_in, char *temp_name);
t_type parse_post_incrementing(t_type expr_in, char *temp_name);
t_type parse_pre_decrementing();
t_type parse_pre_incrementing();
t_type parse_referencing();
t_type parse_dereferencing(void);

void parse_case(void);
void parse_block(void);
void parse_functions(void);
void parse_return(void);
void parse_for(void);
void parse_if(void);
void parse_switch(void);
void parse_while(void);
void parse_do(void);
void parse_continue(void);
void parse_break(void);
void parse_asm(void);
void parse_directive(void);
int parse_variable_args(void);
void parse_function_call(int func_id);
void parse_goto(void);

t_type cast(t_type t1, t_type t2);

int get_num_array_elements(t_type type);
int get_array_offset(char dim, t_type array);
int get_data_size_for_indexing(t_type type);
int get_enum_val(char *element_name);
int get_total_func_fixed_param_size(void);
t_var get_internal_var_ptr(char *var_name);
int get_total_type_size(t_type type);
char *get_var_base_addr(char *dest, char *var_name);
int get_param_size(void);
int get_pointer_unit(t_type type);
int get_primitive_type_size(t_type type);
int get_type_size_for_func_arg_parsing(t_type type);
int get_struct_size(int id);
int get_struct_elements_count(int struct_id);
int get_struct_element_offset(int struct_id, char *name);
t_type get_struct_element_type(int struct_id, char *name);
t_primitive_type get_primitive_type_from_tok(void);
int is_struct(t_type type);

int find_array_initialization_size(t_modifier modifier);
int is_array(t_type type);
int array_dim_count(t_type type);


char is_hex_digit(char c);
char is_digit(char c);


void dbg_print_var_info(t_var *var);
void dbg_print_type_info(t_type *type);
void dbg_print_function_info(t_function *function);

void print_typedef_table(void);
void print_function_table(void);
char find_cmdline_switch(int argc, char **argv, char *_switch);


void insert_runtime(void);
void declare_heap(void);
void delete(char *start, int len);
void insert(char *text, char *new_text);

int is_register(char *name);
int is_assignment(void);
void push_prog(void);
void pop_prog(void);


char is_space(char c);

char is_constant(char *varname);
void dbg(char *s);
int function_has_variable_arguments(int func_id);



char token_not_a_const(void);