#include <stdio.h>

struct s1{
    char c;
    int i;
    int a[10];
    char b[10];
    struct{
        char cc;
        int ii;
        char cc2[10];
        int ii2[10];
    } s2[5];
    char cc2;
};

static void main(){
    int pass = 1;
    struct s1 ss[5];

    printf("\nassigning values...\n");

    ss[0].c = 'a';
    ss[0].i = 123;
    ss[0].a[0] = 555;
    ss[0].a[1] = 666;
    ss[0].a[2] = 777;

    ss[0].b[0] = 100;
    ss[0].b[1] = 200;
    ss[0].b[2] = 30;

    ss[3].s2[3].cc = 'z';
    ss[3].s2[3].ii = 999;
    ss[3].s2[3].cc2[0] = 255;
    ss[3].s2[3].cc2[1] = 128;
    ss[3].s2[3].cc2[2] = 100;

    ss[3].s2[3].ii2[0] = 65535;
    ss[3].s2[3].ii2[1] = 50000;
    ss[3].s2[3].ii2[2] = 20000;

    ss[3].cc2 = 'b';


    printf("printing assignments...\n");

    printf("%c\n", ss[0].c);
    printf("%d\n", ss[0].i);
    printf("%d\n", ss[0].a[0]);
    printf("%d\n", ss[0].a[1]);
    printf("%d\n", ss[0].a[2]);

    printf("%d\n", ss[0].b[0]);
    printf("%d\n", ss[0].b[1]);
    printf("%d\n", ss[0].b[2]);

    printf("%c\n", ss[3].s2[3].cc);
    printf("%d\n", ss[3].s2[3].ii);
    printf("%u\n", ss[3].s2[3].cc2[0]);
    printf("%u\n", ss[3].s2[3].cc2[1]);
    printf("%u\n", ss[3].s2[3].cc2[2]);

    printf("%u\n", ss[3].s2[3].ii2[0]);
    printf("%u\n", ss[3].s2[3].ii2[1]);
    printf("%u\n", ss[3].s2[3].ii2[2]);

    printf("%c\n", ss[3].cc2);


    printf("checking results...\n");    

    pass = pass && ss[0].c == 'a';
    pass = pass && ss[0].i == 123;
    pass = pass && ss[0].a[0] == 555;
    pass = pass && ss[0].a[1] == 666;
    pass = pass && ss[0].a[2] == 777;

    pass = pass && ss[0].b[0] == 100;
    pass = pass && ss[0].b[1] == 200;
    pass = pass && ss[0].b[2] == 30;

    pass = pass && ss[3].s2[3].cc == 'z';
    pass = pass && ss[3].s2[3].ii == 999;
    pass = pass && ss[3].s2[3].cc2[0] == 255;
    pass = pass && ss[3].s2[3].cc2[1] == 128;
    pass = pass && ss[3].s2[3].cc2[2] == 100;

    pass = pass && ss[3].s2[3].ii2[0] == 65535;
    pass = pass && ss[3].s2[3].ii2[1] == 50000;
    pass = pass && ss[3].s2[3].ii2[2] == 20000;

    pass = pass && ss[3].cc2 == 'b';

    printf("final test result: %s\n", pass ? "passed" : "failed");
}
