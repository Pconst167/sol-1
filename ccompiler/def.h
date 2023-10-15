#define STRING_TABLE_SIZE          256
#define STRING_CONST_SIZE          512
#define MAX_USER_FUNC              128
#define MAX_GLOBAL_VARS            128
#define MAX_LOCAL_VARS             128
#define ID_LEN                     128
#define CONST_LEN                  128
#define PROG_SIZE                  1024 * 1024
#define MAX_MATRIX_DIMS            10
#define MAX_ENUM_ELEMENTS          128
#define MAX_TYPEDEFS               128
#define MAX_ENUM_DECLARATIONS      128
#define MAX_STRUCT_DECLARATIONS    128
#define MAX_STRUCT_ELEMENTS        32
#define MAX_DEFINES                128
#define MAX_GOTO_LABELS_PER_FUNC   32
#define MAX_ERRORS                 4

#define true 1
#define false 0

typedef enum {
  TOK_UNDEF = 0, 
  DIRECTIVE, 
  PRAGMA, 
  INCLUDE, 
  DEFINE,

  VAR_ARGS,
  TYPEDEF,
  STATIC,
  VOID,
  CHAR,
  INT,
  FLOAT,
  DOUBLE,
  SHORT,
  LONG,
  SIGNED,
  UNSIGNED,
  STRUCT,
  STRUCT_DOT,
  STRUCT_ARROW,
  ENUM,
  IF,
  ELSE,
  FOR,
  DO,
  WHILE,
  BREAK,
  CONTINUE,
  SWITCH,
  CASE,
  DEFAULT,
  RETURN,
  CONST,
  SIZEOF,
  GOTO,
  PLUS,
  MINUS,
  STAR,
  FSLASH,
  INCREMENT,
  DECREMENT,
  MOD,
  EQUAL,
  NOT_EQUAL,
  LESS_THAN,
  LESS_THAN_OR_EQUAL,
  GREATER_THAN,
  GREATER_THAN_OR_EQUAL,
  LOGICAL_AND,
  LOGICAL_OR,
  LOGICAL_NOT,
  ASSIGNMENT,
  DOLLAR,
  CARET,
  AT,
  TERNARY_OP,
  BITWISE_AND,
  AMPERSAND = BITWISE_AND,
  BITWISE_XOR,
  BITWISE_OR,
  BITWISE_NOT,
  BITWISE_SHL,
  BITWISE_SHR,
  OPENING_PAREN,
  CLOSING_PAREN,
  OPENING_BRACE,
  CLOSING_BRACE,
  OPENING_BRACKET,
  CLOSING_BRACKET,
  COLON,
  SEMICOLON,
  COMMA,
  ASM
} t_token; // internal token representation

typedef enum {
  TYPE_UNDEF, 
  DELIMITER,
  CHAR_CONST, 
  STRING_CONST, 
  INTEGER_CONST,
  FLOAT_CONST,
  DOUBLE_CONST,
  IDENTIFIER, 
  RESERVED, 
  END
} t_token_type;

struct{
  char *as_str;
  t_token token;
} token_to_str[] = {
  "tok_undef",               TOK_UNDEF,                                            
  "directive",               DIRECTIVE, 
  "pragma",                  PRAGMA, 
  "include",                 INCLUDE, 
  "define",                  DEFINE,
  "typedef",                 TYPEDEF,
  "static",                  STATIC,
  "void",                    VOID,
  "char",                    CHAR,
  "int",                     INT,
  "float",                   FLOAT,
  "double",                  DOUBLE,
  "short",                   SHORT,
  "long",                    LONG,
  "signed",                  SIGNED,
  "unsigned",                UNSIGNED,
  "struct",                  STRUCT,
  "struct_dot",              STRUCT_DOT,
  "struct_arrow",            STRUCT_ARROW,
  "enum",                    ENUM,
  "if",                      IF,
  "else",                    ELSE,
  "for",                     FOR,
  "do",                      DO,
  "while",                   WHILE,
  "break",                   BREAK,
  "continue",                CONTINUE,
  "switch",                  SWITCH,
  "case",                    CASE,
  "default",                 DEFAULT,
  "return",                  RETURN,
  "const",                   CONST,
  "sizeof",                  SIZEOF,
  "goto",                    GOTO,
  "plus",                    PLUS,
  "minus",                   MINUS,
  "star",                    STAR,
  "fslash",                  FSLASH,
  "increment",               INCREMENT,
  "decrement",               DECREMENT,
  "mod",                     MOD,
  "equal",                   EQUAL, 
  "not_equal",               NOT_EQUAL, 
  "less_than",               LESS_THAN, 
  "less_than_or_equal",      LESS_THAN_OR_EQUAL, 
  "greater_than",            GREATER_THAN, 
  "greater_than_or_equal",   GREATER_THAN_OR_EQUAL, 
  "logical_and",             LOGICAL_AND, 
  "logical_or",              LOGICAL_OR, 
  "logical_not",             LOGICAL_NOT, 
  "assignment",              ASSIGNMENT,
  "dollar",                  DOLLAR, 
  "caret",                   CARET, 
  "at",                      AT, 
  "ternary_op",              TERNARY_OP, 
  "bitwise_and",             BITWISE_AND, 
  "ampersand = bitwise_and", AMPERSAND, 
  "bitwise_xor",             BITWISE_XOR, 
  "bitwise_or",              BITWISE_OR, 
  "bitwise_not",             BITWISE_NOT, 
  "bitwise_shl",             BITWISE_SHL,
  "bitwise_shr",             BITWISE_SHR,
  "opening_paren",           OPENING_PAREN,
  "closing_paren",           CLOSING_PAREN,
  "opening_brace",           OPENING_BRACE,
  "closing_brace",           CLOSING_BRACE,
  "opening_bracket",         OPENING_BRACKET,
  "closing_bracket",         CLOSING_BRACKET,
  "colon",                   COLON,
  "semicolon",               SEMICOLON,
  "comma",                   COMMA,
  "asm",                     ASM
};

typedef unsigned char bool;

struct{
  char *as_str;
  t_token_type toktype;
} toktype_to_str[] = {
  "undefined", TYPE_UNDEF, 
  "delimiter", DELIMITER,
  "char constant", CHAR_CONST, 
  "string constant", STRING_CONST, 
  "integer constant", INTEGER_CONST, 
  "float constant", FLOAT_CONST, 
  "double constant", DOUBLE_CONST,
  "identifier", IDENTIFIER, 
  "reserved", RESERVED, 
  "end", END
};

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
  DT_VOID = 1, DT_CHAR, DT_INT, DT_FLOAT, DT_DOUBLE, DT_STRUCT
} t_basic_type;

typedef enum {
  LNESS_NORMAL, LNESS_LONG
} t_longness;

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
  t_basic_type basic_type;
  t_signedness signedness;
  t_longness longness;
  char is_constant; // is it a constant?
  int ind_level; // holds the pointer indirection level
  int struct_id; // struct ID if var is a struct
  int dims[MAX_MATRIX_DIMS];
} t_type;

typedef struct{
  char type_name[ID_LEN];
  t_type type;
} t_typedef;
t_typedef typedef_table[MAX_TYPEDEFS];

typedef struct{
  char name[ID_LEN];
  struct{
    char name[ID_LEN];
    t_type type;
  } elements[MAX_STRUCT_ELEMENTS];
} t_struct;


typedef struct {
  char name[ID_LEN];
  t_type type; // holds the type of data and the value itself
  bool is_parameter;
  bool is_var_args;
  char is_static;
  int bp_offset; // if var is local, this holds the offset of the var from BP.
  int function_id; // the function does var belong to? (if it is a local var)
} t_var;

struct{
  char name[ID_LEN];
  char content[256];
} defines_table[MAX_DEFINES];

typedef struct {
  char name[ID_LEN];
  t_type return_type;
  char *code_location;
  t_var local_vars[MAX_LOCAL_VARS];
  int local_var_tos;
  int total_parameter_size;
  char goto_labels_table[MAX_GOTO_LABELS_PER_FUNC][ID_LEN];
  int goto_labels_table_tos;
  char num_arguments;
} t_user_func;

char *basic_type_to_str_table[] = {
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
  "asm",      ASM,

  "typedef",  TYPEDEF,
  "void",     VOID,
  "char",     CHAR,
  "int",      INT,
  "float",    FLOAT,
  "double",   DOUBLE,

  "static",   STATIC,
  "const",    CONST,
  "signed",   SIGNED,
  "unsigned", UNSIGNED,
  "long",     LONG,

  "enum",     ENUM,
  "struct",   STRUCT,
  "sizeof",   SIZEOF,

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

t_user_func function_table[MAX_USER_FUNC];
t_enum enum_table[MAX_ENUM_DECLARATIONS];
t_struct struct_table[MAX_STRUCT_DECLARATIONS];
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
int defines_tos;
int typedef_table_tos;

char *prog_stack[10];
int prog_tos;

int errors_in_a_row;

char include_kernel_exp = 1;
char org[64] = "TEXT_ORG";
int include_files_total_lines;
char included_functions_table[512][ID_LEN];

t_token_type toktype;
t_token tok;
char token[CONST_LEN];            // string token representation
char string_const[STRING_CONST_SIZE];  // holds string and char constants without quotes and with escape sequences converted into the correct bytes
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
void error(const char* format, ...);
void expect(t_token _tok, char *message);

void declare_enum(void);
void declare_typedef(void);
int declare_struct(void);
void declare_func(void);
void declare_global(void);
int declare_local(void);
void declare_struct_global_vars(int struct_id);
void parse_struct_initialization_data(int struct_id, int array_size);
void declare_goto_label();
void declare_define(void);

int search_global_var(char *var_name);
int search_struct(char *name);
int search_string(char *str);
int search_define(char *name);
int search_function(char *func_name);
int search_function_parameter(int function_id, char *param_name);
int enum_element_exists(char *element_name);

void emit_c_line();
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
void skip_array_bracket(void);

int count_cases(void);

t_type parse_expr();
t_type parse_assignment();
t_type parse_ternary_op(void);
t_type parse_logical(void);
t_type parse_logical_and(void);
t_type parse_logical_or(void);
t_type parse_bitwise_and(void);
t_type parse_bitwise_or(void);
t_type parse_bitwise_xor(void);
t_type parse_relational(void);
t_type parse_bitwise_shift(void);
t_type parse_terms();
t_type parse_factors();
t_type parse_atomic();

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
void parse_function_call(int func_id);
void parse_goto(void);

t_type cast(t_type t1, t_type t2);

t_basic_type get_var_type(char *var_name);
int get_num_array_elements(t_type type);
int get_array_offset(char dim, t_type array);
int get_data_size_for_indexing(t_type type);
int get_enum_val(char *element_name);
int get_total_func_param_size(void);
t_var get_internal_var_ptr(char *var_name);
int get_total_type_size(t_type type);
char *get_var_base_addr(char *dest, char *var_name);
int get_param_size(void);
int get_pointer_unit(t_type type);
int get_basic_type_size(t_type type);
int get_struct_size(int id);
int get_struct_elements_count(int struct_id);
int get_struct_element_offset(int struct_id, char *name);
t_type get_struct_element_type(int struct_id, char *name);
t_basic_type get_basic_type_from_tok();
int is_struct(t_type type);

int find_array_initialization_size(void);
int is_array(t_type type);
int array_dim_count(t_type type);


char is_hex_digit(char c);
char is_digit(char c);


void dbg_print_var_info(t_var *var);
void dbg_print_type_info(t_type *type);


void insert_runtime();
void declare_heap();
void delete(char *start, int len);
void insert(char *text, char *new_text);

void optimize1();
void optimize2();
int is_register(char *name);
int is_assignment();
void push_prog();
void pop_prog();


char is_space(char c);

char is_constant(char *varname);
void optimize();
void dbg(char *s);
int has_var_args(int func_id);