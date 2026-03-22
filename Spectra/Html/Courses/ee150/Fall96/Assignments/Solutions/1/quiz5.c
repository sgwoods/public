/*
 * 
 */
#include <stdio.h>

main()
{
int a; int b; int c; int d;

a = 1;        /* 1 */
b = a++;      /* 2 */
c = 2 + --a;  /* 3 */

b * c;

d = 10;
d /= b;      /* 5 */

for(;d > 0;)
  {
    printf("D is ... %i\n", d);
    d -= 2;
  }

a = (a += b);   /* 3 */
printf("A is ... %i\n", a);

d = (a == 3) ? 99 : 33;
printf("D is ... %i\n", d);   /* 99 */

if ( (d == 99), (d != 99) )
  printf("Stupid Commas\n");
else
  printf("Commas are fun\n");

a = 6, b = 10;

d = (c = a + b) + (a == b) + (9 == 1);
printf("C is tricky, but D is ... %i\n", d);
}

/* Local Variables: */
/* compile-command: "gcc -ansi -o quiz5 quiz5.c -lm" */
/* End: */
