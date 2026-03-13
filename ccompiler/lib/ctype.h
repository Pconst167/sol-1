char is_space(char c){
  return c == ' ' || c == '\t' || c == '\n' || c == '\r';
}

char is_digit(char c){
  return c >= '0' && c <= '9';
}

char is_alpha(char c){
  return(c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c == '_');
}

char tolower(char ch) {
  if (ch >= 'A' && ch <= 'Z') 
    return ch - 'A' + 'a';
  else 
    return ch;
}

char toupper(char ch) {
  if (ch >= 'a' && ch <= 'z') 
    return ch - 'a' + 'A';
  else 
    return ch;
}

char is_delimiter(char c){
  if(
    c == '@' ||
    c == '#' ||
    c == '$' ||
    c == '+' ||
    c == '-' ||
    c == '*' ||
    c == '/' ||
    c == '%' ||
    c == '[' ||
    c == ']' ||
    c == '(' ||
    c == ')' ||
    c == '{' ||
    c == '}' ||
    c == ':' ||
    c == ';' ||
    c == '<' ||
    c == '>' ||
    c == '=' ||
    c == '!' ||
    c == '^' ||
    c == '&' ||
    c == '|' ||
    c == '~' ||
    c == '.'
  ) 
    return 1;
  else 
    return 0;
}