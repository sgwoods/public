#include <stdio.h>
main()
{
int a, b;
int c; float d, f;
int *p1, *p2;  
int e = 10; 
double t[3] = {2.0,2.1,2.2};
double *p3;
b = 2, a = b++;
printf("Question 1 a is: [ %i ]\n", a); 
d = 2.5, c = ++d;
printf("Question 2 c is : [ %i ]\n", c); 
printf("Question 3 expr is : [ %5.2f ]\n", ((int) (6.55 + 4.44)) * 3.1 );
printf("Question 4 expr is : [ %5.2f ]\n", ( (double) (6.55 + 4.44) * (int) 3.1 ) );
p1 = &e; p2 = p1, *p2 += 3;  *p1 = 11; a = *p1, *p2;  
printf("Question 5 a is: [ %i ]\n", a);
*(&a) = *t, p3 = t + 2, d = a + *p3;
printf("Question 6 d is : [ %5.2f ]\n", d);
printf("Question 7 a is : [ %i ]\n", a);
*(&(*(&d))) = *(t + 2), *(t + 2) = 3; f = t[2];
printf("Question 8: d is [ %5.2f ]\n", d);
printf("Question 9: f is [ %5.2f ]\n", f);
a = 5; b = 3; c = 1; c = (a == b) + (a > b) * (c < a) - (c < a > b);
printf("Question 10: c is [ %5.2f ]\n", c);
}

/* Local Variables: */
/* compile-command: "gcc -ansi -o quiz8 quiz8.c -lm" */
/* End: */
