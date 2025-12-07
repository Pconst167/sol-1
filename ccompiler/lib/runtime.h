char argv[16][64];
int argc;

void get_inline_arguments(){
  char *argv_p, *arg_line_p;

  argc = 0;
  arg_line_p = 0;
  for(;;){
    argv_p = argv[argc];
    while(*arg_line_p == ' ' || *arg_line_p == '\t') arg_line_p++;
    if(!*arg_line_p) break;
    while(*arg_line_p != ' ' && *arg_line_p != ';' && *arg_line_p){
      if(*arg_line_p == '\\') arg_line_p++;
      *argv_p++ = *arg_line_p++;
    }
    *argv_p = '\0';
    argc++;
  }
}