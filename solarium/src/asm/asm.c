#define DEFAULT_ORG 1024
#define ID_LEN 32
#define MAX_LABELS 16

/*
  TODO:

COPY UPDATES FROM AS2.C

    add option for general 2byte opcodes (not only FD prefix). FD prefix is sol-1 specific.
    i.e. remove opcode type, and add opcode length field to struct.
*/

enum t_token{
  TOK_UNDEF, ORG, INCLUDE, DATA, TEXT, SEGMENT_END,
  DB, DW,
  PLUS, MINUS, 
  DOLLAR, 
  OPENING_BRACKET, CLOSING_BRACKET,
  COLON, SEMICOLON, COMMA, DOT
};

enum t_token_type{
  TYPE_UNDEF, KEYWORD, DELIMITER,
  CHAR_CONST, STRING_CONST, INTEGER_CONST,
  IDENTIFIER, END
};

struct t_opcode{
  char name[24];
  char opcode;
  char opcode_type;
};

struct t_keyword{
  char *keyword;
  char tok;
} keywords[8] = {
  "org",      ORG,
  "include",  INCLUDE,
  "data",     DATA,
  "text",     TEXT,
  "db",       DB,
  "dw",       DW,
  "end",      SEGMENT_END,
  "",         0
};

struct t_label{
  char name[16];
  int address;
};
struct t_label label_table[MAX_LABELS];

int _org = DEFAULT_ORG;
int pc;
char print_information = 1;
int tok;
int toktype;
char *prog;
char token[64];
char string_const[256];
int int_const;
char *program;
char *bin_out;
char *bin_p;
char *opcode_table;
char *prog_stack[10];
int prog_tos;
int prog_size;
char *symbols[8] = {
  "@", "#", 
  "#", "@", 
  "@", "@", 
  "#", "#"
};

int main(){
  char *p;
  print("\n");

  program = alloc(16384);
  bin_out = alloc(16384);
  opcode_table = alloc(12310);

  loadfile(0x0000, program);
  loadfile("./config.d/op_tbl", opcode_table);

  // remove space at end of file
  p = program;
  while(*p) p++;
  while(is_space(*p)) p--;
  p++;
  *p = '\0';

  prog = program;
  bin_p = bin_out + _org;
  pc = _org;
  prog_size = 0;
  label_directive_scan();
  prog_size = 0;
  parse_text();
  parse_data();
  display_output();
}


void parse_data(){
  print("Parsing DATA section...");

  for(;;){
    get();
    if(toktype == END) error("Data segment not found.");
    if(tok == DOT){
      get();
      if(tok == DATA) break;
    }
  }

  for(;;){
    get();
    if(tok == SEGMENT_END) break;
    if(tok == DB){
      print(".db: ");
      for(;;){
        get();
        if(toktype == CHAR_CONST){
          emit_byte(string_const[0], 0);
          printx8(string_const[0]);
        }
        else if(toktype == INTEGER_CONST){
          emit_byte(int_const, 0);
          printx8(int_const);
        }
        get();
        if(tok != COMMA){
          back();
          break;
        }
        print(", ");
      }
      print("\n");
    }
    else if(tok == DW){
      print(".dw: ");
      for(;;){
        get();
        if(toktype == CHAR_CONST){
          emit_byte(string_const[0], 0);
          emit_byte(0, 0);
          printx8(string_const[0]);
        }
        else if(toktype == INTEGER_CONST){
          emit_word(int_const, 0);
          printx16(int_const);
        }
        get();
        if(tok != COMMA){
          back();
          break;
        }
        print(", ");
      }
      print("\n");
    }
  }

  print("Done.\n");
}

void parse_directive(char emit_override){
  get();
  if(tok == ORG){
    get();
    if(toktype != INTEGER_CONST) error("Integer constant expected in .org directive.");
    _org = int_const;
  }
  else if(tok == DB){
    //print("\n.db: ");
    for(;;){
      get();
      if(toktype == CHAR_CONST){
        emit_byte(string_const[0], emit_override);
        //printx8(string_const[0]);
      }
      else if(toktype == INTEGER_CONST){
        emit_byte(int_const, emit_override);
        //printx8(int_const);
      }
      get();
      if(tok != COMMA){
        back();
        break;
      }
    }
  }
  else if(tok == DW){
    //print("\n.dw: ");
    for(;;){
      get();
      if(toktype == CHAR_CONST){
        emit_byte(string_const[0], emit_override);
        emit_byte(0, emit_override);
        //printx8(string_const[0]);
      }
      else if(toktype == INTEGER_CONST){
        emit_word(int_const, 0);
        //printx16(int_const);
      }
      get();
      if(tok != COMMA){
        back();
        break;
      }
    }
  }
}

void label_directive_scan(){
  char *temp_prog;
  int i;

  prog = program;
  bin_p = bin_out + _org;
  pc = _org;

  print("Parsing labels and directives...\n");
  for(;;){
    get(); back();
    temp_prog = prog;
    get();
    if(toktype == END) break;
    if(tok == DOT){
      get();
      if(is_directive(token)){
        back();
        parse_directive(1);
      }
    }
    else if(toktype == IDENTIFIER){
      get();
      if(tok == COLON){
        prog = temp_prog;
        parse_label();
        print(".");
      }
      else{
        prog = temp_prog;
        parse_instr(1);      
        print(".");
      }
    }
  }
  print("\nDone.\n");
  print_info2("Org: ", _org, "\n");
  print("\nLabels list:\n");
  for(i = 0; label_table[i].name[0]; i++){
    print(label_table[i].name);
    print(": ");
    printx16(label_table[i].address);
    print("\n");
  }
  print("\n");
}

void label_parse_instr(){
  char opcode[32];
  char code_line[64];
  struct t_opcode op;
  int num_operands, num_operandsexp;
  int i, j;
  char operand_types[3]; // operand types and locations
  int old_pc;
  char has_operands;

  old_pc = pc;
  get_line();
  push_prog();
  strcpy(code_line, string_const);

  has_operands = 0;
  prog = code_line;
  get(); // get main opcode
  for(;;){
    get();
    if(toktype == END) break;
    if(toktype == INTEGER_CONST || toktype == IDENTIFIER && !is_reserved(token)){
      has_operands = 1;
      break;
    }
  }

  opcode[0] = '\0';
  prog = code_line;
  if(!has_operands){
    get();
    strcpy(opcode, token);
    get(); 
    if(toktype == END){
      strcat(opcode, " .");
    }
    else{
      strcat(opcode, " ");
      strcat(opcode, token);
      for(;;){
        get();
        if(toktype == END) break;
        strcat(opcode, token);
      }
    }
    op = search_opcode(opcode);
    if(op.opcode_type){
      forwards(1);
    }
    forwards(1);
  } 
  else{
    num_operands = 0;
    for(;;){
      get();
      if(toktype == END) break;
      if(toktype == INTEGER_CONST || toktype == IDENTIFIER && !is_reserved(token)){
        num_operands++;
      }
    }
    if(num_operands > 2) error("Maximum number of operands per instruction is 2.");
    num_operandsexp = exp(2, num_operands);
    for(i = 0; i < num_operandsexp; i++){
      prog = code_line;
      get();
      strcpy(opcode, token);
      strcat(opcode, " ");
      j = 0;
      for(;;){
        get();
        if(toktype == END) break;
        if(toktype == INTEGER_CONST || toktype == IDENTIFIER && !is_reserved(token)){
          strcat(opcode, symbols[i*2+j]);
          operand_types[j] = *symbols[i*2+j];
          j++;
        }    
        else{
          strcat(opcode, token);
        }
      }

      op = search_opcode(opcode);
      if(op.name[0] == '\0') continue;
      if(op.opcode_type){
        forwards(1);
      }
      forwards(1);
      prog = code_line;
      j = 0;
      get();
      for(;;){
        get();
        if(toktype == END) break;
        if(toktype == IDENTIFIER && !is_reserved(token)){
          if(operand_types[j] == '#'){
            error("8bit operand expected but 16bit label given.");
          }
          else if(operand_types[j] == '@'){
            forwards(2);
          }
          j++;
        }
        else if(toktype == INTEGER_CONST){
          if(operand_types[j] == '#'){
            forwards(1);
          }
          else if(operand_types[j] == '@'){
            forwards(2);
          }
          j++;
        }
      }
      break;
    }
  }
  pop_prog();
}

void parse_instr(char emit_override){
  char opcode[32];
  char code_line[64];
  struct t_opcode op;
  int instr_len;
  int num_operands, num_operandsexp;
  int i, j;
  char operand_types[3]; // operand types and locations
  int old_pc;
  char has_operands;

  old_pc = pc;
  get_line();
  push_prog();
  strcpy(code_line, string_const);

  has_operands = 0;
  prog = code_line;
  get();
  for(;;){
    get();
    if(toktype == END) break;
    //if(toktype == IDENTIFIER && !is_reserved(token) && label_exists(token) == -1) error_s("Undeclared label: ", token);
    if(toktype == INTEGER_CONST || label_exists(token) != -1){
      has_operands = 1;
      break;
    }
  }

  opcode[0] = '\0';
  prog = code_line;
  if(!has_operands){
    get();
    strcpy(opcode, token);
    get(); 
    if(toktype == END){
      strcat(opcode, " .");
    }
    else{
      strcat(opcode, " ");
      strcat(opcode, token);
      for(;;){
        get();
        if(toktype == END) break;
        strcat(opcode, token);
      }
    }
    op = search_opcode(opcode);
    instr_len = 1;
    if(op.opcode_type){
      instr_len++;
      emit_byte(0xFD, emit_override);
    }
    emit_byte(op.opcode, emit_override);
    if(!emit_override){
      printx16(old_pc); print(" ("); printu(instr_len); print(") : ");
      print(code_line); putchar('\n');
    }
  } 
  else{
    num_operands = 0;
    for(;;){
      get();
      if(toktype == END) break;
      if(toktype == INTEGER_CONST || label_exists(token) != -1) num_operands++;
    }
    if(num_operands > 2) error("Maximum number of operands per instruction is 2.");
    num_operandsexp = exp(2, num_operands);
    for(i = 0; i < num_operandsexp; i++){
      prog = code_line;
      get();
      strcpy(opcode, token);
      strcat(opcode, " ");
      j = 0;
      for(;;){
        get();
        if(toktype == END) break;
        if(toktype == INTEGER_CONST || label_exists(token) != -1){
          strcat(opcode, symbols[i*2+j]);
          operand_types[j] = *symbols[i*2+j];
          j++;
        }    
        else{
          strcat(opcode, token);
        }
      }

      op = search_opcode(opcode);
      if(op.name[0] == '\0') continue;
      instr_len = 1;
      if(op.opcode_type){
        emit_byte(0xFD, emit_override);
        instr_len++;
      }
      emit_byte(op.opcode, emit_override);
      prog = code_line;
      j = 0;
      get();
      for(;;){
        get();
        if(toktype == END) break;
        if(toktype == IDENTIFIER){
          if(label_exists(token) != -1){
            if(operand_types[j] == '#'){
              error("8bit operand expected but 16bit label given.");
            }
            else if(operand_types[j] == '@'){
              emit_word(get_label_addr(token), emit_override);
              instr_len = instr_len + 2;
            }
            j++;
          }
          else{
            if(!is_reserved(token)){
              error_s("Undeclared label: ", token);
            }
          }
        }
        else if(toktype == INTEGER_CONST){
          if(operand_types[j] == '#'){
            emit_byte(int_const, emit_override);
            instr_len++;
          }
          else if(operand_types[j] == '@'){
            emit_word(int_const, emit_override);
            instr_len = instr_len + 2;
          }
          j++;
        }
      }
      if(!emit_override){
        printx16(old_pc); print(" ("); printu(instr_len); print(") : ");
        print(code_line); putchar('\n');
      }
      break;
    }
  }
  pop_prog();
}

void parse_text(){
  char *temp_prog;

  print("Parsing TEXT section...\n");
  prog = program;
  bin_p = bin_out + _org;
  pc = _org;

  for(;;){
    get();
    if(toktype == END) error("TEXT section not found.");
    if(tok == TEXT){
      break;
    }
  }

  for(;;){
    get(); back();
    temp_prog = prog;
    get();
    if(toktype == END) error("TEXT section end not found.");
    if(tok == DOT){
      get();
      if(tok == SEGMENT_END) break;
      else{
        error("Unexpected directive.");
      }
    }
    else if(toktype == IDENTIFIER){
      get();
      if(tok != COLON){
        prog = temp_prog;
        parse_instr(0);
      }
    }
  }

  print("Done.\n\n");
}

void debug(){
  print("\n");
  print("Prog Offset: "); printx16(prog-program); print(", ");
  print("Prog value : "); putchar(*prog); print("\n");
  print("Token       : "); print(token); print(", ");
  print("Tok: "); printu(tok); print(", ");
  print("Toktype: "); printu(toktype); print("\n");
  print("StringConst : "); print(string_const); print("\n");
  print("PC          : "); printx16(pc);
  print("\n");
}

void display_output(){
  int i;
  unsigned char *p;
  print("\nAssembly complete.\n");
  print_info2("Program size: ", prog_size, "\n");


  print("Listing: \n");
  p = bin_out + _org;
  for(;;){
    if(p == bin_p) break;
    printx8(*p); 
    p++;
  }

  print("\n");
}

char is_reserved(char *name){
  return !strcmp(name, "a")
      || !strcmp(name, "al")
      || !strcmp(name, "ah")
      || !strcmp(name, "b")
      || !strcmp(name, "bl")
      || !strcmp(name, "bh")
      || !strcmp(name, "c")
      || !strcmp(name, "cl")
      || !strcmp(name, "ch")
      || !strcmp(name, "d")
      || !strcmp(name, "dl")
      || !strcmp(name, "dh")
      || !strcmp(name, "g")
      || !strcmp(name, "gl")
      || !strcmp(name, "gh")
      || !strcmp(name, "pc")
      || !strcmp(name, "sp")
      || !strcmp(name, "bp")
      || !strcmp(name, "si")
      || !strcmp(name, "di")
      || !strcmp(name, "word")
      || !strcmp(name, "byte")
      || !strcmp(name, "cmpsb")
      || !strcmp(name, "movsb")
      || !strcmp(name, "stosb");
}
char is_directive(char *name){
  return !strcmp(name, "org") 
      || !strcmp(name, "define");
}
void parse_label(){
  char label_name[ID_LEN];
  get();
  strcpy(label_name, token);
  declare_label(label_name, pc);
  get(); // get ':'
}

int declare_label(char *name, int address){
  int i;
  for(i = 0; i < MAX_LABELS; i++){
    if(!label_table[i].name[0]){
      strcpy(label_table[i].name, name);
      label_table[i].address = address;
      return i;
    }
  }
}

int get_label_addr(char *name){
  int i;
  for(i = 0; i < MAX_LABELS; i++){
    if(!strcmp(label_table[i].name, name)){
      return label_table[i].address;
    }
  }
  error_s("Label does not exist: ", name);
}

int label_exists(char *name){
  int i;
  for(i = 0; i < MAX_LABELS; i++){
    if(!strcmp(label_table[i].name, name)){
      return i;
    }
  }
  return -1;
}

void print_info(char *s1, char *s2, char *s3){
  if(print_information){
    print(s1);
    print(s2);
    print(s3);
  }
}

void print_info2(char *s1, unsigned int n, char *s2){
  if(print_information){
    print(s1);
    printu(n);
    print(s2);
  }
}


struct t_opcode search_opcode(char *what_opcode){
  char opcode_str[24];
  char opcode_hex[5];
  char *hex_p;
  char *op_p;
  char *tbl_p;
  struct t_opcode return_opcode;

  tbl_p = opcode_table;
  for(;;){
    op_p = opcode_str;
    hex_p = opcode_hex;
    while(*tbl_p != ' ') *op_p++ = *tbl_p++;
    *op_p++ = *tbl_p++;
    while(*tbl_p != ' ') *op_p++ = *tbl_p++;
    *op_p = '\0';
    if(!strcmp(opcode_str, what_opcode)){
      strcpy(return_opcode.name, what_opcode);
      while(*tbl_p == ' ') tbl_p++;
      while(is_hex_digit(*tbl_p)) *hex_p++ = *tbl_p++; // Copy hex opcode
      *hex_p = '\0';
      if(strlen(opcode_hex) == 4){
        return_opcode.opcode_type = 1;
        *(opcode_hex + 2) = '\0';
        return_opcode.opcode = hex_to_int(opcode_hex);
      }
      else{
        return_opcode.opcode_type = 0;
        return_opcode.opcode = hex_to_int(opcode_hex);
      }
      return return_opcode;
    }
    else{
      while(*tbl_p != '\n') tbl_p++;
      while(*tbl_p == '\n') tbl_p++;
      if(!*tbl_p) break;
    }
  }
  return_opcode.name[0] = '\0';
  return return_opcode;
}

void forwards(char amount){
  bin_p = bin_p + amount;
  prog_size = prog_size + amount;
  pc = pc + amount;
}

void emit_byte(char byte, char emit_override){
  if(!emit_override){
    *bin_p = byte;
  }
  forwards(1);
}

void emit_word(int word, char emit_override){
  if(!emit_override){
    *((int*)bin_p) = word;
  }
  forwards(2);
}

void back(void){
  char *t;
  t = token;

  while(*t){
    prog--;
    t++;
  }
}

void get_path(){
  char *t;
  *token = '\0';
  tok = 0;
  toktype = 0;
  t = token;
  
// Skip whitespaces 
  while(is_space(*prog)) prog++;

  if(*prog == '\0'){
    toktype = END;
    return;
  }
  while(*prog == '/' || is_alpha(*prog) || is_digit(*prog) || *prog == '_' || *prog == '-' || *prog == '.') {
    *t++ = *prog++;
  }
  *t = '\0';
}

char is_hex_digit(char c){
  return c >= '0' && c <= '9' || c >= 'A' && c <= 'F' || c >= 'a' && c <= 'f';
}

void get_line(void){
  char *t;

  t = string_const;
  *t = '\0';
  
  while(*prog != 0x0A && *prog != '\0'){
    if(*prog == ';'){
      while(*prog != 0x0A && *prog != '\0') prog++;
      break;
    }
    else *t++ = *prog++;
  }
  *t = '\0';
}

void get(){
  char *t;
  char temp_hex[64];
  char *p;
  // skip blank spaces

  *token = '\0';
  tok = TOK_UNDEF;
  toktype = TYPE_UNDEF;
  t = token;
  
// Skip whitespaces
  do{
    while(is_space(*prog)) prog++;
    if(*prog == ';'){
      while(*prog != '\n') prog++;
      if(*prog == '\n') prog++;
    }
  } while(is_space(*prog) || *prog == ';');

  if(*prog == '\0'){
    toktype = END;
    return;
  }
  
  if(is_alpha(*prog)){
    while(is_alpha(*prog) || is_digit(*prog)){
      *t++ = *prog++;
    }
    *t = '\0';
    if((tok = search_keyword(token)) != -1) 
      toktype = KEYWORD;
    else 
      toktype = IDENTIFIER;
  }
  else if(is_digit(*prog) || (*prog == '$' && is_hex_digit(*(prog+1)))){
    if(*prog == '$' && is_hex_digit(*(prog+1))){
      *t++ = *prog++;
      p = temp_hex;
      *t++ = *p++ = *prog++;
      while(is_hex_digit(*prog)){
        *t++ = *p++ = *prog++;
      }
      *t = *p = '\0';
      int_const = hex_to_int(temp_hex);
    }
    else{
      while(is_digit(*prog)){
        *t++ = *prog++;
      }
      *t = '\0';
      int_const = atoi(token);
    }
    toktype = INTEGER_CONST;
  }
  else if(*prog == '\''){
    *t++ = '\'';
    prog++;
    if(*prog == '\\'){
      *t++ = '\\';
      prog++;
      *t++ = *prog++;
    }
    else{
      *t++ = *prog++;
    }
    if(*prog != '\''){
      error("Closing single quotes expected.");
    }
    *t++ = '\'';
    prog++;
    toktype = CHAR_CONST;
    *t = '\0';
    convert_constant(); // converts this string token with quotation marks to a non quotation marks string, and also converts escape sequences to their real bytes
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
    convert_constant(); // converts this string token with quotation marks to a non quotation marks string, and also converts escape sequences to their real bytes
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
  else if(*prog == '+'){
    *t++ = *prog++;
    tok = PLUS;
    toktype = DELIMITER;  
  }
  else if(*prog == '-'){
    *t++ = *prog++;
    tok = MINUS;
    toktype = DELIMITER;  
  }
  else if(*prog == '$'){
    *t++ = *prog++;
    tok = DOLLAR;
    toktype = DELIMITER;  
  }
  else if(*prog == ':'){
    *t++ = *prog++;
    tok = COLON;
    toktype = DELIMITER;  
  }
  else if(*prog == ';'){
    *t++ = *prog++;
    tok = SEMICOLON;
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

  if(toktype == TYPE_UNDEF){
    print("TOKEN ERROR. Prog: "); printx16((int)(prog-program)); 
    print(", ProgVal: "); putchar(*prog); 
    print("\n Text after prog: \n");
    print(prog);
    exit();
  }
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
  print("\nError: ");
  print(msg);
  print("\n");
  exit();
}

void error_s(char *msg, char *param){
  print("\nError: ");
  print(msg);
  print(param);
  print("\n");
  exit();
}

void push_prog(){
  if(prog_tos == 10) error("Cannot push prog. Stack overflow.");
  prog_stack[prog_tos] = prog;
  prog_tos++;
}

void pop_prog(){
  if(prog_tos == 0) error("Cannot pop prog. Stack overflow.");
  prog_tos--;
  prog = prog_stack[prog_tos];
}

int search_keyword(char *keyword){
  int i;
  
  for(i = 0; keywords[i].keyword[0]; i++)
    if (!strcmp(keywords[i].keyword, keyword)) return keywords[i].tok;
  
  return -1;
}

void printx16(int hex) {
  asm{
    meta mov d, hex
    mov b, [d]
    call print_u16x
  }
}

void printx8(char hex) {
  asm{
    meta mov d, hex
    mov bl, [d]
    call print_u8x
  }
}

int hex_to_int(char *hex_string) {
  int value = 0;
  int i;
  char hex_char;
  int len;

  len = strlen(hex_string);
  for (i = 0; i < len; i++) {
    hex_char = hex_string[i];
    if (hex_char >= 'a' && hex_char <= 'f') 
      value = (value * 16) + (hex_char - 'a' + 10);
    else if (hex_char >= 'A' && hex_char <= 'F') 
      value = (value * 16) + (hex_char - 'A' + 10);
    else 
      value = (value * 16) + (hex_char - '0');
  }
  return value;
}

int atoi(char *str) {
    int result = 0;  // Initialize result
    int sign = 1;    // Initialize sign as positive

    // Skip leading whitespaces
    while (*str == ' ') str++;

    // Check for optional sign
    if (*str == '-' || *str == '+') {
        if (*str == '-') sign = -1;
        str++;
    }

    // Loop through all digits of input string
    while (*str >= '0' && *str <= '9') {
        result = result * 10 + (*str - '0');
        str++;
    }

    return sign * result;
}

void printu(unsigned int num) {
  char digits[5];
  int i;
  i = 0;
  if(num == 0){
    putchar('0');
    return;
  }
  while (num > 0) {
      digits[i] = '0' + (num % 10);
      num = num / 10;
      i++;
  }
  // Print the digits in reverse order using putchar()
  while (i > 0) {
      i--;
      putchar(digits[i]);
  }
}


void putchar(char c){
  asm{
    meta mov d, c
    mov al, [d]
    mov ah, al
    call _putchar
  }
}


void print(char *s){
  asm{
    meta mov d, s
    mov a, [d]
    mov d, a
    call _puts
  }
}


int loadfile(char *filename, char *destination){
  asm{
    meta mov d, destination
    mov a, [d]
    mov di, a
    meta mov d, filename
    mov d, [d]
    mov al, 20
    syscall sys_filesystem
  }
}

// heap and heap_top are defined internally by the compiler
// so that 'heap' is the last variable in memory and therefore can grow upwards
// towards the stack
char *alloc(int bytes){
  heap_top = heap_top + bytes;
  return heap_top - bytes;
}

char *free(int bytes){
  return heap_top = heap_top - bytes;
}

void exit(){
  asm{
    syscall sys_terminate_proc
  }
}


int exp(int base, int exp){
  int i;
  int result = 1;
  for(i = 0; i < exp; i++){
    result = result * base;
  }
  return result;
}

void strcpy(char *dest, char *src) {
  char *psrc;
  char *pdest;
  psrc = src;
  pdest = dest;

  while(*psrc){
    *pdest = *psrc;
    pdest++;
    psrc++;
  }
  *pdest = '\0';
}

int strcmp(char *s1, char *s2) {
  while (*s1 && (*s1 == *s2)) {
    s1++;
    s2++;
  }
  return *s1 - *s2;
}

char *strcat(char *dest, char *src) {
    int dest_len;
    int i;
    dest_len = strlen(dest);
    
    for (i = 0; src[i] != 0; i=i+1) {
        dest[dest_len + i] = src[i];
    }
    dest[dest_len + i] = 0;
    
    return dest;
}

int strlen(char *str) {
    int length;
    length = 0;
    
    while (str[length] != 0) {
        length++;
    }
    
    return length;
}

char is_space(char c){
  return c == ' ' || c == '\t' || c == '\n' || c == '\r';
}

char is_digit(char c){
  return c >= '0' && c <= '9';
}

char is_alpha(char c){
  return(c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c == '_');
}

void include_stdio_asm(){
  asm{
    .include "lib/stdio.asm"
  }
}