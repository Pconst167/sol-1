#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

char is_delimiter(char c);
char is_hex_digit(char c);
char is_digit(char c);
char is_identifier_char(char c);
char is_space(char c);
char* replace_substring(const char* str, const char* old_sub, const char* new_sub);