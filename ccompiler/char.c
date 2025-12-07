#include "char.h"

char is_delimiter(char c){
  return c == '$'
      || c == '#'
      || c == '+'
      || c == '-'
      || c == '*'
      || c == '/'
      || c == '%'
      || c == '['
      || c == ']'
      || c == '{'
      || c == '}'
      || c == '('
      || c == ')'
      || c == ':'
      || c == ';'
      || c == ','
      || c == '.'
      || c == '<'
      || c == '>'
      || c == '='
      || c == '!'
      || c == '^'
      || c == '&'
      || c == '|'
      || c == '~'
      || c == '?'
      || c == '@';
}

char is_hex_digit(char c){
  return c >= '0' && c <= '9' || c >= 'a' && c <= 'f' || c >= 'A' && c <= 'F';
}

char is_digit(char c){
  return c >= '0' && c <= '9';
}

char is_identifier_char(char c){
  return isalpha(c) || c == '_';
}

char is_space(char c){
  return c == ' ' || c == '\t' || c == '\n' || c == '\r';
}

char* replace_substring(const char* str, const char* old_sub, const char* new_sub) {
    if (str == NULL || old_sub == NULL || new_sub == NULL) {
        return NULL; // Handle NULL input strings
    }
    
    if (strlen(old_sub) == 0) {
        return NULL; // Avoid infinite loop with empty old_sub
    }

    // Counting the number of times old_sub occurs in str
    int count = 0;
    const char* tmp = str;
    while ((tmp = strstr(tmp, old_sub)) != NULL) {
        count++;
        tmp += strlen(old_sub);
    }

    // Allocate memory for the new string
    size_t new_str_len = strlen(str) + count * (strlen(new_sub) - strlen(old_sub));
    char* new_str = malloc(new_str_len + 1); // +1 for the null terminator
    if (new_str == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }

    // Replace occurrences of old_sub with new_sub
    const char* current_pos = str;
    char* new_pos = new_str;
    while ((tmp = strstr(current_pos, old_sub)) != NULL) {
        // Copy characters from the current position to the position of old_sub
        size_t len = tmp - current_pos;
        memcpy(new_pos, current_pos, len);
        new_pos += len;

        // Copy new_sub to new_str
        memcpy(new_pos, new_sub, strlen(new_sub));
        new_pos += strlen(new_sub);

        // Move the current position forward
        current_pos = tmp + strlen(old_sub);
    }

    // Copy the remaining part of the original string
    strcpy(new_pos, current_pos);

    return new_str;
}