/*
 * 
 */
#include <stdio.h>

main()
{
int n;
int m;
int o;
int x = 10;

n = (x == 10) ? 5 : 13;

if (x == 10) m = 5; else m = 13;

o = (if (x == 10) 5; else 13);

printf("N is ... %i\n", n);
printf("M is ... %i\n", m);
printf("O is ... %i\n", o);
}
