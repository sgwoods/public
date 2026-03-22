
#include <stdio.h>
main()
{
int a, b;
int c; float d, f;
int *p1, *p2;  
int e = 10; 
double t[3] = {2.0,2.1,2.2};
double *p3;
double dd = 1.5;
int fizbin(int *, int *);

printf("Initialize:  a, b, c   ints   unset\n");
printf("Initialize:  d, f      floats unset\n");
printf("Initialize:  *p1, *p2  ptr to ints unset\n");
printf("Initialize:  table t   with 3 values 2.0, 2.1, 2.2");
printf("Initialize:  *p3       ptr to double unset\n");
printf("Initialize:  dd        double set to 1.5\n");

b = 2, a = b++;

printf("Set b = 2, a = 3\n");

d = 2.5, c = ++d;
printf("Set d = 2.5, c = %i\n", c);

dd = (double) (6.55 + 4.44) * (int) 3.1;
printf("Set dd = %5.2f\n", dd);

p1 = &e; p2 = p1, *p2 += 3;  *p1 = 11; a = *p1, *p2;  
printf("Set p1 to point at e at addr = %p\n", &e);
printf("Set p2 to point where p1 does : at addr = %p\n", p1);
printf("Increment *p2 by 3 to %i\n", *p2);
printf("Set *p1 to 11\n");
printf("Set a to %i\n", *p2);

*(&a) = *t, p3 = t + 2, d = a + *p3;

printf("Set d to %5.2f\n", d);
printf("Set p3 to %p\n", p3);
printf("Set a to %i\n", a);

*(&(*(&d))) = *(t + 2), *(t + 2) = 3; f = t[2];
printf("Set d to %5.2f\n", d);
printf("Set *(t + 2) at %p to %5.2f\n", t+2, 3);
printf("Set f %5.2f\n", f);

a = 5; b = 3; c = 1; c = (a == b) + (a > b) * (c < a) - (c < a > b);
printf("Set a to %i\n", a);
printf("Set b to %i\n", b);
printf("Set c to %i\n", 1);
printf("Set c to %i\n", c);

for(c=1;c<3;c++) c = fizbin(&a,&b);
printf("Set c to %i\n", c);
printf("Set a to %i\n", a);
printf("Set b to %i\n", b);
}


int fizbin(int *i,int *j) {
     printf("Fizbin Call:  *i = %i, i addr = %p\n", *i, i);     
     printf("Fizbin Call:  *j = %i, j addr = %p\n", *j, j);
     *i = *i * *j;
     printf("  Fizbin Sets *i = %i, at addr = %p\n", *i, i);
     *j = *i - *j;
     printf("  Fizbin Sets *j = %i, at addr = %p\n", *j, j);
     printf("Fizbin Returns = %i\n", *i - *j);
     return *i - *j; 
   }

/* Local Variables: */
/* compile-command: "gcc -ansi -o final2-2 final2-2.c -lm" */
/* End: */
