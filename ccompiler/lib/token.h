#include "lib/ctype.h"
#include "lib/stdio.h"

enum t_token{
  TOK_UNDEF, 
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
  HASH,
  AMPERSAND,
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
  DOT
};

enum t_token_type{
  TYPE_UNDEF, 
  DELIMITER,
  CHAR_CONST, 
  STRING_CONST, 
  INTEGER_CONST,
  IDENTIFIER, 
  END
};

int tok;
int toktype;
char *prog;
char token[256];
char string_const[256];

void back(void){
  char *t;
  t = token;

  while(*t++) prog--;
  tok = TOK_UNDEF;
  toktype = TYPE_UNDEF;
  token[0] = '\0';
}

void get_path(){
  char *t;
  *token = '\0';
  t = token;
  
/* Skip whitespaces */
  while(is_space(*prog)) prog++;
  if(*prog == '\0'){
    return;
  }
  while(
    (*prog >= 'a' && *prog <= 'z') ||
    (*prog >= 'A' && *prog <= 'Z') ||
    (*prog >= '0' && *prog <= '9') ||
    *prog == '/' || 
    *prog == '_' ||
    *prog == '-' ||
    *prog == '.'
  ){
    *t++ = *prog++;
  }
  *t = '\0';
}

void get(){
  char *t;
  // skip blank spaces

  *token = '\0';
  tok = 0;
  toktype = 0;
  t = token;
  
/* Skip whitespaces */
  while(is_space(*prog)) prog++;

  if(*prog == '\0'){
    toktype = END;
    return;
  }
  
  if(is_digit(*prog)){
    while(is_digit(*prog)){
      *t++ = *prog++;
    }
    *t = '\0';
    toktype = INTEGER_CONST;
    return; // return to avoid *t = '\0' line at the end of function
  }
  else if(is_alpha(*prog)){
    while(is_alpha(*prog) || is_digit(*prog)){
      *t++ = *prog++;
    }
    *t = '\0';
    toktype = IDENTIFIER;
  }
  else if(*prog == '\"'){
    *t++ = '\"';
    prog++;
    while(*prog != '\"' && *prog){
      *t++ = *prog++;
    }
    if(*prog != '\"') error("Double quotes expected");
    *t++ = '\"';
    prog++;
    toktype = STRING_CONST;
    *t = '\0';
    convert_constant(); // converts this string token qith quotation marks to a non quotation marks string, and also converts escape sequences to their real bytes
  }
  else if(*prog == '#'){
    *t++ = *prog++;
    tok = HASH;
    toktype = DELIMITER;  
  }
  else if(*prog == '{'){
    *t++ = *prog++;
    tok = OPENING_BRACE;
    toktype = DELIMITER;  
  }
  else if(*prog == '}'){
    *t++ = *prog++;
    tok = CLOSING_BRACE;
    toktype = DELIMITER;  
  }
  else if(*prog == '['){
    *t++ = *prog++;
    tok = OPENING_BRACKET;
    toktype = DELIMITER;  
  }
  else if(*prog == ']'){
    *t++ = *prog++;
    tok = CLOSING_BRACKET;
    toktype = DELIMITER;  
  }
  else if(*prog == '='){
    *t++ = *prog++;
    if (*prog == '='){
      *t++ = *prog++;
      tok = EQUAL;
    }
    else 
      tok = ASSIGNMENT;
    toktype = DELIMITER;  
  }
  else if(*prog == '&'){
    *t++ = *prog++;
    if(*prog == '&'){
      *t++ = *prog++;
      tok = LOGICAL_AND;
    }
    else
      tok = AMPERSAND;
    toktype = DELIMITER;  
  }
  else if(*prog == '|'){
    *t++ = *prog++;
    if (*prog == '|'){
      *t++ = *prog++;
      tok = LOGICAL_OR;
    }
    else 
      tok = BITWISE_OR;
    toktype = DELIMITER;  
  }
  else if(*prog == '~'){
    *t++ = *prog++;
    tok = BITWISE_NOT;
    toktype = DELIMITER;  
  }
  else if(*prog == '<'){
    *t++ = *prog++;
    if (*prog == '='){
      *t++ = *prog++;
      tok = LESS_THAN_OR_EQUAL;
    }
    else if (*prog == '<'){
      *t++ = *prog++;
      tok = BITWISE_SHL;
    }
    else
      tok = LESS_THAN;
    toktype = DELIMITER;  
  }
  else if(*prog == '>'){
    *t++ = *prog++;
    if (*prog == '='){
      *t++ = *prog++;
      tok = GREATER_THAN_OR_EQUAL;
    }
    else if (*prog == '>'){
      *t++ = *prog++;
      tok = BITWISE_SHR;
    }
    else 
      tok = GREATER_THAN;
    toktype = DELIMITER;  
  }
  else if(*prog == '!'){
    *t++ = *prog++;
    if(*prog == '='){
      *t++ = *prog++;
      tok = NOT_EQUAL;
    }
    else 
      tok = LOGICAL_NOT;
    toktype = DELIMITER;  
  }
  else if(*prog == '+'){
    *t++ = *prog++;
    if(*prog == '+'){
      *t++ = *prog++;
      tok = INCREMENT;
    }
    else 
      tok = PLUS;
    toktype = DELIMITER;  
  }
  else if(*prog == '-'){
    *t++ = *prog++;
    if(*prog == '-'){
      *t++ = *prog++;
      tok = DECREMENT;
    }
    else 
      tok = MINUS;
    toktype = DELIMITER;  
  }
  else if(*prog == '$'){
    *t++ = *prog++;
    tok = DOLLAR;
    toktype = DELIMITER;  
  }
  else if(*prog == '^'){
    *t++ = *prog++;
    tok = BITWISE_XOR;
    toktype = DELIMITER;  
  }
  else if(*prog == '@'){
    *t++ = *prog++;
    tok = AT;
    toktype = DELIMITER;  
  }
  else if(*prog == '*'){
    *t++ = *prog++;
    tok = STAR;
    toktype = DELIMITER;  
  }
  else if(*prog == '/'){
    *t++ = *prog++;
    tok = FSLASH;
    toktype = DELIMITER;  
  }
  else if(*prog == '%'){
    *t++ = *prog++;
    tok = MOD;
    toktype = DELIMITER;  
  }
  else if(*prog == '('){
    *t++ = *prog++;
    tok = OPENING_PAREN;
    toktype = DELIMITER;  
  }
  else if(*prog == ')'){
    *t++ = *prog++;
    tok = CLOSING_PAREN;
    toktype = DELIMITER;  
  }
  else if(*prog == ';'){
    *t++ = *prog++;
    tok = SEMICOLON;
    toktype = DELIMITER;  
  }
  else if(*prog == ':'){
    *t++ = *prog++;
    tok = COLON;
    toktype = DELIMITER;  
  }
  else if(*prog == ','){
    *t++ = *prog++;
    tok = COMMA;
    toktype = DELIMITER;  
  }
  else if(*prog == '.'){
    *t++ = *prog++;
    tok = DOT;
    toktype = DELIMITER;  
  }

  *t = '\0';
}

// converts a literal string or char constant into constants with true escape sequences
void convert_constant(){
  char *s;
  char *t;
  
  t = token;
  s = string_const;
  if(toktype == CHAR_CONST){
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
  else if(toktype == STRING_CONST){
    t++;
    while(*t != '\"' && *t){
      *s++ = *t++;
    }
  }
  
  *s = '\0';
}

void error(char *msg){
  printf("\nError: ");
  printf(msg);
  printf("\n");

}