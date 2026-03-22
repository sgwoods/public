/* 
   Sum the two times each of the even numbers between START and FINISH together
   with three times each of the odd numbers between START and FINISH

   Important Hint: <TT>#define A B</tt> results in a replacement of any A
   with B before the program is compiled.
*/

#include <stdio.h>

#define START  5
#define FINISH 8
#define T1 thrice                          /* defined T1 and T2 backwards */
#define T2 twice

int main()
{
  int i;  
  int sum_even;  
  int sum_odd;
  int total;                               /* forgot to define total */

  int even(int x);
  int twice(int x);                       
  int thrice(int x);                       /* forgot thrice prototype */

  sum_even = 0;   sum_odd = 0;             /* forgot to initialize sums */

  for (i = START; i <= FINISH; i = i + 1)
    {
      if (even(i))
	{
	  sum_even = sum_even + T2(i);
          printf("%i is EVEN\n", i);
	}
      else
	{
	  sum_odd  = sum_odd  + T1(i);
          printf("%i is ODD\n", i);
	}
    }
  total = sum_even + sum_odd;
  printf("%i\n", total);
}

int odd(int x)
{
  /* A simpler way to determine even/odd */
  int val = ((x % 2) == 1);
  printf(" in odd ... val of %i is %i\n", x, val);

  return val;
} 

int even(int x)
{ int odd(int);
  return !(odd(x));
}

int even2(int x)
{
  /* This function determines whether a number is odd or even
     by dividing by two - if there is a remainder, the number
     must be odd */

  double ck;
  ck =  (double) (x / 2.0) - (int) (x / 2);
  if (ck > 0.0) 
    return 0;
  else return 1;
} 

int twice ( int x )
{ 
  return 2 * x; 
}

int thrice ( int x )
{ 
  int twice(int x);
  return twice(x) + x;
}
