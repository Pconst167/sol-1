#include <stdio.h>
int mem[8192];
int n_atoms;
int hash_table[23];
int sp;
int freelist;
int maxcons;
int a0, a1, a2, a3, a4;

int aflag = 0;
int bflag = 0;
int cflag = 0;
int dflag = 0;

char read_buf[128];
int pos_read_buf;

int cyca;
int cycb;
char alia[256][32];

void numprint(int num) {
   prints(num);
}

char *p_names[256] = {
   "nil", "undefined", "t", "quote", "car", "cdr", "add1", "sub1", "lambda",
   "defun", "print", "setq", "eq", "if", "times", "oblist", "plus",
   "difference", "lt", "gt", "le", "ge", "cond", "cons", "null", "exit",
   "dumpat", "dumpcons", "gc", "nbfree", "rplaca", "rplacd", "quotient",
   "remainder", "read", "numberp", "atom", "listp", "not", "list", "dumppile",
   "progn", "load",
   0 };


int readchr() {
  char c = 0;
  int i;
  for (i = 0; i < 128; i++) {
    read_buf[i] = 0;
  }
  read_buf[127] = 0;
  i = 0;
  while (c != '\n') {

    c = getchar();
    if (c == '#') {
      read_buf[i] = 0;
      printf("exit(0);\n");
      return(0);
    }

    if  (((c == ' ')  || (c == '\n')   || (c == '\t')  || (c == '\v')  ||
          (c == '\f') || (c == '\r')   || (c == '\'')  ||
          (c == '0')  || (c == '1')    || (c == '2')   || (c == '3')  ||
          (c == '4')  || (c == '5')    || (c == '6')   || (c == '7')  ||
          (c == '8')  || (c == '9')    || (c == '(')   || (c == ')')   ||
          ((c >= 'a') && (c <= 'z'))   || ((c >= 'A') && (c <= 'Z')))) {
      read_buf[i] = c;
      i++;
      if (i == 127) {
        read_buf[127] = 0;
        return(127);
      }
    }

  }
  return(i);
}

char read_char()
{
char ch;

   if (pos_read_buf >= 80)
   {
      if (readchr() == 0)
      {
            printf("Bye ... exit(0);\n");
      }
      pos_read_buf = 0;
   }

   ch = read_buf[pos_read_buf++];
   if (ch == '\n') {
      pos_read_buf = 80; }
   return (ch);
}


int iint_read(char ch)
{
int val = 0;

   do
   {
      val = (val * 10) + (ch - '0');
      ch = read_char();
   }
   while ((ch == '0') || (ch == '1') || (ch == '2') || (ch == '3')
                      || (ch == '4') || (ch == '5') || (ch == '6')
                      || (ch == '7') || (ch == '8') || (ch == '9'));

   unread_char(ch);
   return ((val+8092));
}

int atom_read(char ch)
{
int res;
int n_hash;
char atbuf[128];
int i;

   i = 0;
   do
   {
      atbuf[i++] = ch;
      ch = read_char();
   }
   while (((ch >= 'a') && (ch <= 'z')) || ((ch >= 'A') && (ch <= 'Z')) || ((ch >= '0') && (ch <= '9')));

   atbuf[i] = '\0';
   unread_char(ch);



   n_hash = hashname(atbuf);
   for (i=hash_table[n_hash] ; i!=0 ; i=mem[i+1] )
   {
 if (!strcmp(atbuf,(char *)p_names[mem[i]]) )
 {
    res = mem[i];
    return(res);
 }
   }

   res = creatom(atbuf);
   hash_table[n_hash] = cons (res, hash_table[n_hash]);

   return(res);
}

void lisp_read()
{
   a0 = obj_read();
}

int obj_read()
{
int res;
char ch;

   do
   {
      ch = read_char();
   }
   while ((ch == ' ') || (ch == '\n') || (ch == '\t') || (ch == '\v') || (ch == '\f') || (ch == '\r') || (ch == ')'));

   if (ch == '\'')
   {
      res = obj_read();
      res = cons(3, cons(res, 0));
      return (res);
   }






   if ((ch == '0') || (ch == '1') || (ch == '2') || (ch == '3')
                   || (ch == '4') || (ch == '5') || (ch == '6')
                   || (ch == '7') || (ch == '8') || (ch == '9')) {
      res = iint_read(ch); }
   else
   if (ch == '(') {
      res = cons_read(); }
   else
   if (((ch >= 'a') && (ch <= 'z')) || ((ch >= 'A') && (ch <= 'Z'))) {
      res = atom_read(ch);
   }
   else
   {
      err ("ERREUR: Lecture de caractere inconnu", ch);
   }

   return (res);
}


void subrs_0()
{
   int i;
   int n;
   int cpt;

      if (a4 == 15) {
         a0 = 0;
         for (a1 = n_atoms-1 ; a1 >= 0 ; a1 --) {
            a0 = cons(a1 , a0); }
         return; }

      if (a4 == 26) {
         a0 = 0;
         {
         cpt = 0;
            for (i=0 ; i<n_atoms; i++)
            {
              numprint(i);
              printf(p_names[i]);
              printf("  CVAL:");
              numprint(mem[i]);
              printf(" - ");
              obj_print(mem[i]);
              putchar ('\n' );
              if (++cpt == 18)
              {
                 if (getchar() != '\n') {
                    break; }
                 cpt = 0;
              }
            }
         }
         return; }

      if (a4 == 27) {
         a0 = 0;
         printf("Freelist : ");
         numprint(freelist);
         printf("\n");
         {
         cpt = 1;
            for (i=6998 ; i>=256 ; i = i - 2)
            {
              numprint(i);
              printf("  CAR:");
              numprint(mem[i]);
              printf("  CDR:");
              numprint(mem[i+1]);
              printf("\n");
              if (++cpt == 18)
              {
                 if ( getchar() != '\n') {
                    break; }
                 cpt = 0;
              }
            }
         }
         return; }

      if (a4 == 28) {
         a0 = 0;
         gc();
         return; }

      if (a4 == 29) {
         {
            n = 1;
            for (i=freelist; i!=0 ; i=mem[i+1]); {
              a0 = (n+8092);
              n++;
            }
         }
         return; }

      if (a4 == 40) {
         a0 = 0;
         {
            cpt = 1;
            printf ("sp = ");
            numprint(sp);
            printf("\n");
            for (i=7000 ; i<=sp ; i++)
            {
               numprint(i);
               printf ("  ");
               if (mem[i] >= 0) {
                  obj_print (mem[i]); }
               else
                  numprint(mem[i]);
               putchar('\n');
               if (++cpt == 18)
               {
                  if (getchar() != '\n') {
                     break; }
                  cpt = 0;
               }
            }
         }
         return; }

      if (a4 == 34) {
         lisp_read();
         return; }
}

void subrs_1()
{
char buf[256];

      if (a4 == 4) {
         if (!((a0 >= 256) && (a0 < 6998 +2)))
         {
            obj_print(a0);
            err ("\n*** car : l'arg doit etre une liste\n", 0);
         }
         a0 = mem[a0]; return; }

      if (a4 == 5) {
         if (!(a0 >= 256 && a0 < 6998 +2))
         {
            obj_print(a0);
            err ("\n*** cdr : l'arg doit etre une liste\n", 0);
         }
         a0 = mem[a0+1]; return; }

      if (a4 == 6) {
         if (!((a0 >= 8092) && (a0 <= 8092 +24000)))
         {
            obj_print(a0);
            err ("\n*** add1 : l'arg doit etre un entier\n", 0);
         }
         a0 = ((a0-8092) + 1 +8092); return; }

      if (a4 == 7) {
         if (!((a0 >= 8092) && (a0 <= 8092 +24000)))
         {
            obj_print(a0);
            err ("\n*** sub1 : l'arg doit etre un entier\n", 0);
         }
         a0 = ((a0-8092) - 1 +8092); return; }

      if (a4 == 10) {
         obj_print(a0); putchar('\n'); return; }

      if ((a4 == 24) || (a4 == 38)) {
         if (a0 == 0) { a0 = 2; } else { a0 = 0; }
         return; }

      if (a4 == 35) {
         if (((a0 >= 8092) && (a0 <= 8092 +24000))) { a0 = 2; } else { a0 = 0; }
         return; }

      if (a4 == 36) {
         if (((a0 >= 0) && (a0 < 256)) || ((a0 >= 8092) && (a0 <= 8092 +24000))) { a0 = 2; } else { a0 = 0; }
         return; }

      if (a4 == 37) {
         if ((a0 >= 256) && (a0 < 6998 +2)) { a0 = 2; } else { a0 = 0; }
         return; }

      if (a4 == 42) {
         a0 = 2; return; }
}

void subrs_2()
{
      if (a4 == 12) {
         if (a1 == a0) { a0 = 2; } else { a0 = 0; }
         return; }

      if (a4 == 14) {
         aflag = 0; bflag = 0;
         if (a0 >= 8092 && a0 <= 8092 +24000) { aflag = 0; } else { aflag = 1; }
         if ((a1 >= 8092) && (a1 <= 8092 +24000)) { bflag = 0; } else { bflag = 1; }
         if (  aflag + bflag > 0  )
         {
            obj_print(a0);
            putchar('\n');
            obj_print(a1);
            err ("\n*** times : les args doivent etre des nombres\n", 0);
         }
         a0 = ((a0-8092) * (a1-8092)+8092); return; }

      if (a4 == 16) {
         aflag = 0; bflag = 0;
         if ((a0 >= 8092) && (a0 <= 8092 +24000)) { aflag = 0; } else { aflag = 1; }
         if ((a1 >= 8092) && (a1 <= 8092 +24000)) { bflag = 0; } else { bflag = 1; }
         if (  aflag + bflag > 0  )
         {
            obj_print(a0);
            putchar('\n');
            obj_print(a1);
            err ("\n*** plus : les args doivent etre des nombres\n", 0);
         }
         a0 = ((a0-8092) + (a1-8092)+8092); return; }

      if (a4 == 17) {
         aflag = 0; bflag = 0;
         if ((a0 >= 8092) && (a0 <= 8092 +24000)) { aflag = 0; } else { aflag = 1; }
         if ((a1 >= 8092) && (a1 <= 8092 +24000)) { bflag = 0; } else { bflag = 1; }
         if (  aflag + bflag > 0  )
         {
            obj_print(a0);
            putchar('\n');
            obj_print(a1);
            err ("\n*** difference : les args doivent etre des nombres\n", 0);
         }
         a0 = ((a0-8092) - (a1-8092)+8092); return; }

      if (a4 == 18) {
         aflag = 0; bflag = 0;
         if ((a0 >= 8092) && (a0 <= 8092 +24000)) { aflag = 0; } else { aflag = 1; }
         if ((a1 >= 8092) && (a1 <= 8092 +24000)) { bflag = 0; } else { bflag = 1; }
         if (  aflag + bflag > 0  )
         {
            obj_print(a0);
            putchar('\n');
            obj_print(a1);
            err ("\n*** lt : les args doivent etre des nombres\n", 0);
         }
         if ((a0-8092) < (a1-8092)) { a0 = 2; } else { a0 = 0; } ; return; }

      if (a4 == 19) {
         aflag = 0; bflag = 0;
         if ((a0 >= 8092) && (a0 <= 8092 +24000)) { aflag = 0; } else { aflag = 1; }
         if ((a1 >= 8092) && (a1 <= 8092 +24000)) { bflag = 0; } else { bflag = 1; }
         if (  aflag + bflag > 0  )
         {
            obj_print(a0);
            putchar('\n');
            obj_print(a1);
            err ("\n*** gt : les args doivent etre des nombres\n", 0);
         }
         if ((a0-8092) > (a1-8092)) { a0 = 2; } else { a0 = 0; }
         return; }

      if (a4 == 20) {
         aflag = 0; bflag = 0;
         if ((a0 >= 8092) && (a0 <= 8092 +24000)) { aflag = 0; } else { aflag = 1; }
         if ((a1 >= 8092) && (a1 <= 8092 +24000)) { bflag = 0; } else { bflag = 1; }
         if (  aflag + bflag > 0  )
         {
            obj_print(a0);
            putchar('\n');
            obj_print(a1);
            err ("\n*** le : les args doivent etre des nombres\n", 0);
         }
         if ((a0-8092) <= (a1-8092)) { a0 = 2; } else { a0 = 0; } ; return; }

      if (a4 == 21) {
         aflag = 0; bflag = 0;
         if ((a0 >= 8092) && (a0 <= 8092 +24000)) { aflag = 0; } else { aflag = 1; }
         if ((a1 >= 8092) && (a1 <= 8092 +24000)) { bflag = 0; } else { bflag = 1; }
         if (  aflag + bflag > 0  )
         {
            obj_print(a0);
            putchar('\n');
            obj_print(a1);
            err ("\n*** ge : les args doivent etre des nombres\n", 0);
         }
         if ((a0-8092) >= (a1-8092)) { a0 = 2; } else { a0 = 0; } ; return; }

      if (a4 == 23) {
         if ( !((a1 >= 256) && (a1 < 6998 +2)) && (a1 != 0) )
         {
            obj_print(a1);
            err ("\n*** cons : le 2eme arg doit etre une liste\n", 0);
         }
         a0 = cons (a0, a1); return; }

      if (a4 == 32) {
         aflag = 0; bflag = 0;
         if ((a0 >= 8092) && (a0 <= 8092 +24000)) { aflag = 0; } else { aflag = 1; }
         if ((a1 >= 8092) && (a1 <= 8092 +24000)) { bflag = 0; } else { bflag = 1; }
         if (  aflag + bflag > 0  )
         {
            obj_print(a0);
            putchar('\n');
            obj_print(a1);
            err ("\n*** times : les args doivent etre des nombres\n", 0);
         }
         a0 = ((int) ((a0-8092) / (a1-8092))+8092); return; }

      if (a4 == 33) {
         aflag = 0; bflag = 0;
         if ((a0 >= 8092) && (a0 <= 8092 +24000)) { aflag = 0; } else { aflag = 1; }
         if ((a1 >= 8092) && (a1 <= 8092 +24000)) { bflag = 0; } else { bflag = 1; }
         if (  aflag + bflag > 0  )
         {
            obj_print(a0);
            putchar('\n');
            obj_print(a1);
            err ("\n*** times : les args doivent etre des nombres\n", 0);
         }
         a0 = ((a0-8092) % (a1-8092)+8092); return; }

      if (a4 == 30) {
         if ( !(a0 >= 256 && a0 < 6998 +2) )
         {
            obj_print(a0);
            err ("\n*** rplaca : le 1er arg doit etre une liste\n", 0);
         }
         mem[a0] = a1;
         return;}

      if (a4 == 31) {
         if ( !((a0 >= 256) && (a0 < 6998 +2)) || !((a1 >= 256) && (a1 < 6998 +2)) )
         {
            obj_print(a0);
            putchar('\n');
            obj_print(a1);
            err ("\n*** rplacd : les args doivent etre des listes\n", 0);
         }
         mem[a0+1] = a1;
         return; }
}

void lisp_print()
{
   obj_print(a0);
}

void obj_print(int obj)
{
   if (((obj >= 0) && (obj < 256)))
   {
      printf(p_names[obj]);
      return;
   }
   if (((obj >= 8092) && (obj <= 8092 +24000)))
   {
      numprint(obj-8092);
      return;
   }
   if (((obj >= 256) && (obj < 6998 +2)))
   {
      list_print(obj);
      return;
   }
   err ("Objet a imprimer inconnu:", obj);
}

void list_print (int obj)
{
   putchar( '(' );
   for ( ;; )
   {
      obj_print (mem[obj]);
      if ( (obj = mem[obj+1]) == 0) {
         break; }
      putchar ( ' ' );
   }
   putchar ( ')' );
}

void init_read()
{
   pos_read_buf = 80;
}

void unread_char(char ch)
{
   read_buf[--pos_read_buf] = ch;
}

int creatom(char *nom_at)
{
int res;

   if (n_atoms >= 256) {
      err ("Trop d'atomes\n", 0); }

   for (cycb = 0; cycb < 32; cycb++) {
     alia[cyca][cycb] = nom_at[cycb];
     if (nom_at[cycb] == 0) {
       break;
     }
   }
   alia[cyca][31] = 0;
   res = n_atoms;
   mem[res] = 1;
   p_names[n_atoms++] = alia[cyca];
   cyca++;
   return (res);
}

int cons_read()
{
char ch;
int res;
int x;

   res = x = cons (0, 0);
   for ( ;; )
   {
      do
      {
         ch = read_char();
      }
      while ((ch == ' ') || (ch == '\n') || (ch == '\t') || (ch == '\v') || (ch == '\f') || (ch == '\r'));

      if (ch == ')') {
      x = mem[res+1];
      uncons(res);
      return (x); }
      unread_char (ch);
      mem[x+1] = cons(obj_read(), 0);
      x = mem[x+1];
   }

      x = mem[res+1];
      uncons(res);
      return (x);

      return (mem[res+1]);
}

void init_stack()
{
   sp = 7000;
}

void init_atomes()
{
int i, n_hash;

   init_hash();


   for (i=0 ; i<3 ; i++)
   {
      mem[i] = i;
      n_hash = hashname(p_names[i]);
      hash_table[n_hash] = cons (i, hash_table[n_hash]);
   }


   for ( ; i<43 ; i++)
   {
      mem[i] = 1;
      n_hash = hashname(p_names[i]);
      hash_table[n_hash] = cons (i, hash_table[n_hash]);
   }

   for ( ; i<256 ; i++)
   {
      mem[i] = 1;
   }


   n_atoms = 43;
}

void init_listes()
{
int i;

   maxcons = (6998 - 256 + 2);
   freelist = 0;
   for (i=256 ; i<=6998 ; i = i + 2)
   {
      mem[i+1] = freelist;
      freelist = i;
   }
}

int cons_r0, cons_r1;

int cons(int x, int y)
{
int res;

   if(freelist == 0)
   {
      cons_r0 = x;
      cons_r1 = y;
      gc();
   }
   mem[freelist] = x;
   res = freelist;
   freelist = mem[freelist+1];
   mem[res+1] = y;
   return(res);
}

void uncons (int x)
{
   mem[x+1] = freelist;
   freelist = x;
}

void push(int x)
{
   if (sp == 8092 -1)
   {

      err("Pile debordee\n", 0);
   }
   mem[++sp] = x;
}

char freebits[1024];
int maxbits;

void gc()
{
int n, i;
char *s;

   printf("GC Commence\n");


   if (!freebits)
   {
      err("GC impossible : plus de memoire disponible\n", 0);
   }

   s = freebits;
   for (n=0; n<maxbits ; n++ )
   {
      s[n] = 0;
   }

   for (i=0 ; i<n_atoms ; i++) {
      marquer (mem[i]); }

   marquer (a0);
   marquer (a1);
   marquer (a2);
   marquer (a3);
   marquer (a4);
   marquer (cons_r0);
   marquer (cons_r1);

   for (i=7000 ; i<=sp ; i++) {
      marquer (mem[i]); }

   for (i=0 ; i<23 ; i++) {
      marquer(hash_table[i]); }

   n = balayer();

   if ( !n ) {
      err("GC: plus de doublets", 0); }
   else {
      printf("GC: doublets libres: ");
      numprint(n);
      printf("\n"); }

}

void marquer (int x)
{
   if ( (x >= 256 && x < 6998 +2) )
   {
      if ((freebits[(x-256) >> 4] & (1 << (((x) >> 1) & 7)) )) {
         return; }
      freebits[(x-256) >> 4] = freebits[(x-256) >> 4] | (1 << (((x) >> 1) & 7));
      marquer (mem[x]);
      marquer (mem[x+1]);
   }
}

int balayer ()
{
int i, nbcons;

   nbcons = 0;
   freelist = 0;

   for (i=256 ; i<=6998 ; i = i + 2)
   {
      if ( !(freebits[(i-256) >> 4] & (1 << (((i) >> 1) & 7)) ) )
      {
         mem[i+1] = freelist;
         freelist = i;
         nbcons++;
      }
   }
   return (nbcons);
}


void init_hash()
{
int i;

   for (i=0 ; i<23 ; i++) {
      hash_table[i] = 0; }
}

int hashname (char *nom)
{
int n;

   for (n=0 ; *nom ; ++nom) {
      n = n + *nom; }
   if (n < 0) {
      n = -n; }
   return (n % 23);
}

void eval()
{
debut_eval:
   if ((a0 >= 8092 && a0 <= 8092 +24000)) {
      return; }
   if ((a0 >= 0 && a0 < 256))
   {
      if ( mem[a0] == 1 ) {
         err_s ("Atome valeur indefinie:", p_names[a4]); }
      a0 = mem[a0];
      return;
   }
   if (!(a0 >= 256 && a0 < 6998 +2)) {
      err("Objet a evaluer inconnu", a0); }

   a4 = mem[a0];
evalcar:
   if ((a4 >= 8092 && a4 <= 8092 +24000)) {
      err ("Nombre en position fonctionnelle", (a4-8092) ); }
   if ((a4 >= 0 && a4 < 256))
   {
      if ((a4 == 15) || (a4 == 26) || (a4 == 27) || (a4 == 28) ||
          (a4 == 29) || (a4 == 34) || (a4 == 40)) {
         if (mem[a0+1] != 0) {
            err_s ("Nb d'arguments incorrect: ", p_names[a4]); return; }
         subrs_0();
         return; }

      if ((a4 == 25)) {
         printf ("Bye ... exit(0);\n"); return; }

      if ((a4 == 4)  || (a4 == 5)  || (a4 == 6)  || (a4 == 7)  ||
          (a4 == 10) || (a4 == 24) || (a4 == 35) || (a4 == 36) || 
          (a4 == 37) || (a4 == 38) || (a4 == 42)) {
         a0 = (mem[mem[a0+1]]);
         a4 = mem[sp--];
         subrs_1();
         return; }

      if ((a4 == 12) || (a4 == 14) || (a4 == 16) || (a4 == 17) ||
          (a4 == 18) || (a4 == 19) || (a4 == 20) || (a4 == 21) ||
          (a4 == 23) || (a4 == 30) || (a4 == 31) || (a4 == 32) ||
          (a4 == 33)) {

         if (mem[(mem[mem[a0+1]+1])+1] != 0) {
            err_s ("Nb d'arguments incorrect: ", p_names[a4]); return; }
         push (a4);
         a0 = mem[a0+1];
         push ((mem[mem[a0+1]]));
         a0 = mem[a0];
         eval();
         a1 = a0;
         a0 = mem[sp--];
         push (a1);
         eval();
         a1 = a0;
         a0 = mem[sp--];
         a4 = mem[sp--];
         subrs_2();
         return; }

      if (a4 == 3) {
         a0 = (mem[mem[a0+1]]);
         return; }

      if (a4 == 39) {
         a0 = mem[a0+1];
         evlis();
         return; }

      if (a4 == 41) {
         a0 = mem[a0+1];
         progn();
         return; }

      if (a4 == 9) {
         a0 = mem[a0+1];
         a1 = mem[a0];
         if (!(a1 >= 0 && a1 < 256))
         {
            obj_print (a1);
            err ("*** Le nom de fonction doit etre un atome\n", 0);
         }
         a2 = (mem[mem[a0+1]]);
         if (!((a2 >= 256) && (a2 < 6998 +2)))
         {
            obj_print(a2);
            err ("*** Les parametres doivent etre en liste\n", 0);
         }
         a3 = (mem[mem[a0+1]+1]);
         a4 = cons (8, cons(a2, a3));
         mem[a1] = a4;
         a0 = a1;
         return; }

      if (a4 == 11) {
         a0 = mem[a0+1];
         if (!((mem[a0] >= 0) && (mem[a0] < 256)))
         {
            obj_print (mem[a0]);
            err ("*** La variable doit etre un atome\n", 0);
         }
         push(mem[a0]);
         a0 = (mem[mem[a0+1]]);
         eval();
         a1 = mem[sp--];
         mem[a1] = a0;
         return; }

      if (a4 == 13) {
         if ((mem[mem[(mem[mem[a0+1]+1])+1]+1]) != 0) {
            err_s ("Nb d'arguments incorrect:", p_names[a4]); return; }
         a0 = mem[a0+1];
         push(mem[a0+1]);
         a0 = mem[a0];
         eval();
         a1 = mem[sp--];
         if (a0 == 0) { a0 = (mem[mem[a1+1]]); } else { a0 = mem[a1];}
         goto debut_eval; }

      if (a4 == 22) {
         a0 = mem[a0+1];
         for ( ;; )
         {
            if (a0 == 0) {
                 return; }
            push (a0);
            if ( !((a0 >= 256) && (a0 < 6998 +2)) || !((mem[a0] >= 256) && (mem[a0] < 6998 +2)) )
            {
             obj_print (a0);
             putchar('\n');
             obj_print (mem[a0]);
             putchar('\n');
             err ("*** Les clauses doivent etre en listes\n", 0);
            }
            a0 = (mem[mem[a0]]);
            eval();
            a1 = mem[sp--];
            if (a0 != 0)
            {
              a1 = (mem[mem[a1]+1]);

              if (a1 == 0) {
                   return; }
              a0 = a1;
              progn();
              return;
            }
            a0 = mem[a1+1];
         }}

         if (mem[a4] == 1) {
            err_s ("Fonction standard inconnue:", p_names[a4]);
            return; }
         a4 = mem[a4];
         goto evalcar;
   }

   if (!(a4 >= 256 && a4 < 6998 +2)) {
      err ("Elt inconnu en position fonctionnelle", a4); }

   if (mem[a4] == 8)
   {

      push(a4);
      push(a2);
      push(a0);
      a0 = mem[a0+1];
      evlis();
      a1 = a0;
      a0 = mem[sp--];
      a2 = mem[sp--];
      a4 = mem[sp--];
      bind((mem[mem[a4+1]]), a1);


      push(-2);
      a0 = (mem[mem[a4+1]+1]);
      progn();
      a1 = mem[sp--];
      unbind();
      return;
   }

   err ("Liste non lambda en position fonctionnelle", a4);

}

void progn()
{
   a1 = a0;
   for ( ;; )
   {
      if (a1 == 0) { return; }
      push(a1);
      a0 = mem[a1];
      eval();
      a1 = mem[sp--];
      a1 = mem[a1+1];
   }
}

void evlis()
{
   a4 = a2 = cons(0, 0);
   push(a4);
   for ( ;; )
   {
      if (a0 == 0) { break; }
      push(a0);
      push(a2);
      a0 = mem[a0];
      eval();
      a2 = mem[sp--];
      mem[a2+1] = cons(a0,0);
      a2 = mem[a2+1];
      a0 = mem[sp--];
      a0 = mem[a0+1];
   }
   a4 = mem[sp--];
   a0 = mem[a4+1];
   uncons (a4);
}

void bind(int x, int y)
{
int z;
   z = x;

   push(-1);
   while (z != 0)
   {
      push (mem[mem[z]]);
      push (mem[z]);
      z = (mem[z+1]);
   }

   while (x != 0)
   {
      mem[mem[x]] = mem[y];
      x = mem[x+1];
      y = mem[y+1];
   }
}

void unbind()
{
int x, y;

   for( ;; )
   {
      x = mem[sp--];
      if (x == -1) { return; }
      y = mem[sp--];
      mem[x] = y;
   }
}

void toplevel()
{
   for ( ;; )
   {
      printf ("? ");
      lisp_read();
      eval();
      printf ("= ");
      lisp_print();
      putchar ('\n');
   }
}


void err(char *fmt, int obj)
{
int i;
   printf(fmt);
   printf(" ");
   numprint(obj);
   printf("\n");
   while (sp > 7000) {
      if (i = mem[sp--] == -2) {
         unbind(); }}
   toplevel();
}


void err_s(char *fmt, char *cobj)
{
int i;
   printf(fmt);
   printf(" ");
   printf(cobj);
   printf("\n");
   while (sp > 7000) {
      if (i = mem[sp--] == -2) {
         unbind(); }}
}


void debug(char *s, int x)
{
   printf(s);
   obj_print (x);
   putchar ('\n');
}

int main()
{
int nbtop = 0;

for (cyca = 0; cyca < 256; cyca++) {
  for (cycb = 0; cycb < 32; cycb++) {
    alia[cyca][cycb] = 0;
  }
}
cyca = 0;
cycb = 0;

   init_listes();
   init_atomes();
   init_read();
   init_stack();
   toplevel();

exxit:
   return 0;
}
