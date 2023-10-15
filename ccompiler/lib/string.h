void strcpy(char *dest, char *src) {
  char *psrc;
  char *pdest;
  psrc = src;
  pdest = dest;

  while(*psrc) *pdest++ = *psrc++;
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