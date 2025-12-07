struct{
  char *as_str;
  t_tok token;
} token_to_str[] = {
  {"&",         AMPERSAND}, 
  {"asm",       ASM},
  {"_system",   SYSTEM},
  {"=",         ASSIGNMENT},
  {"@",         AT}, 
  {"auto",      AUTO},
  {"~",         BITWISE_NOT}, 
  {"|",         BITWISE_OR}, 
  {"<<",        BITWISE_SHL},
  {">>",        BITWISE_SHR},
  {"^",         BITWISE_XOR}, 
  {"break",     BREAK},
  {"^",         CARET}, 
  {"case",      CASE},
  {"char",      CHAR},
  {"}",         CLOSING_BRACE},
  {"]",         CLOSING_BRACKET},
  {")",         CLOSING_PAREN},
  {":",         COLON},
  {",",         COMMA},
  {"const",     CONST},
  {"continue",  CONTINUE},
  {"--",        DECREMENT},
  {"default",   DEFAULT},
  {"define",    DEFINE},
  {"ifdef",     DEF_IFDEF},
  {"endif",     DEF_ENDIF},
  {"directive", DIRECTIVE}, 
  {"do",        DO},
  {"$",         DOLLAR}, 
  {"double",    DOUBLE},
  {"else",      ELSE},
  {"enum",      ENUM},
  {"==",        EQUAL}, 
  {"extern",    EXTERN},
  {"float",     FLOAT},
  {"for",       FOR},
  {"/",         FSLASH},
  {"goto",      GOTO},
  {">",         GREATER_THAN}, 
  {">=",        GREATER_THAN_OR_EQUAL}, 
  {"if",        IF},
  {"include",   INCLUDE}, 
  {"++",        INCREMENT},
  {"int",       INT},
  {"<",         LESS_THAN}, 
  {"<=",        LESS_THAN_OR_EQUAL}, 
  {"&&",        LOGICAL_AND}, 
  {"!",         LOGICAL_NOT}, 
  {"||",        LOGICAL_OR}, 
  {"long",      LONG},
  {"-",         MINUS},
  {"%",         MOD},
  {"!=",        NOT_EQUAL}, 
  {"{",         OPENING_BRACE},
  {"[",         OPENING_BRACKET},
  {"(",         OPENING_PAREN},
  {"+",         PLUS},
  {"pragma",    PRAGMA}, 
  {"register",  REGISTER},
  {"return",    RETURN},
  {";",         SEMICOLON},
  {"short",     SHORT},
  {"signed",    SIGNED},
  {"sizeof",    SIZEOF},
  {"*",         STAR},
  {"static",    STATIC},
  {"struct",    STRUCT},
  {"->",        STRUCT_ARROW},
  {".",         STRUCT_DOT},
  {"switch",    SWITCH},
  {"?",         TERNARY_OP}, 
  {"tok_undef", TOK_UNDEF},                 
  {"typedef",   TYPEDEF},
  {"union",     UNION},
  {"unsigned",  UNSIGNED},
  {"void",      VOID},
  {"volatile",  VOLATILE},
  {"while",     WHILE},
  {"undefined", TOK_UNDEF},
};

char *primitive_type_to_str_table[] = {
  "unused",
  "void",
  "char",
  "int",
  "float",
  "double",
  "struct"
};

keyword_table_t keyword_table[] = {
  {"include" , INCLUDE  },
  {"pragma"  , PRAGMA   },
  {"define"  , DEFINE   },
  {"ifdef"   , DEF_IFDEF},
  {"endif"   , DEF_ENDIF},
  {"asm"     , ASM      },
  {"_system" , SYSTEM   },

  {"register", REGISTER },
  {"auto"    , AUTO     },
  {"volatile", VOLATILE },
  {"extern"  , EXTERN   },
  {"typedef" , TYPEDEF  },
  {"static"  , STATIC   },
  {"const"   , CONST    },
  {"signed"  , SIGNED   },
  {"unsigned", UNSIGNED },
  {"long"    , LONG     },

  {"void"    , VOID     },
  {"char"    , CHAR     },
  {"int"     , INT      },
  {"float"   , FLOAT    },
  {"double"  , DOUBLE   },
  {"enum"    , ENUM     },
  {"union"   , UNION    },
  {"struct"  , STRUCT   },
  {"sizeof"  , SIZEOF   },

  {"if"      , IF       },
  {"else"    , ELSE     },
  {"for"     , FOR      },
  {"do"      , DO       },
  {"break"   , BREAK    },
  {"continue", CONTINUE },
  {"while"   , WHILE    },
  {"switch"  , SWITCH   },
  {"case"    , CASE     },
  {"default" , DEFAULT  },
  {"goto"    , GOTO     },
  {"return"  , RETURN   },
  {""        , 0        }
};

struct{
  char *as_str;
  t_tok_type tok_type;
} tok_type_to_str[] = {
  {"char constant",     CHAR_CONST   },
  {"delimiter",         DELIMITER    },
  {"double constant",   DOUBLE_CONST },
  {"end",               END          },
  {"float constant",    FLOAT_CONST  }, 
  {"identifier",        IDENTIFIER   }, 
  {"integer constant",  INTEGER_CONST}, 
  {"reserved",          RESERVED     }, 
  {"string constant",   STRING_CONST }, 
  {"undefined",         TYPE_UNDEF   }
};
/*
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
*/