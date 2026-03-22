#include <stdio.h>
#define ASIZE 13

main()
{
  int  A[ASIZE] = {2, 7, 1, 3, 4, 9, 5, 6, 8, 10, 55, -19, -9999};
  int *minimum;  /* ptr to element of A */ 
  int *maximum;  /* ptr to element of A */ 
  int *median;   /* ptr to element of A */ 
  double average;  

  double processArray(int *, int **, int **, int **);

  average = processArray(A, &minimum, &maximum, &median);

  printf("The value of A[8]  is   8, and the address is %p\n", &A[8]);
  printf("The value of A[10] is -19, and the address is %p\n", &A[10]);
  printf("The value of A[11] is  55, and the address is %p\n\n", &A[11]);

  printf("Array Average = %5.2f\n", average);
  printf("Array Minimum = %i at addr %p\n", *minimum, minimum);
  printf("Array Maximum = %i  at addr %p\n", *maximum, maximum);
  printf("Array Median  = %i   at addr %p\n", *median,  median);
  return 0;
}

/*
   Sample Solution to Final part I, Question 1
*/

double processArray(int *A, int **minimum, int **maximum, int **median)
{ 
  /* Assumes no value of -9999 is valid in the array A */
  int *ptr;

  int    loc_min =   999999999;
  int    loc_max =  -999999999;
  double best_diff = 999999999;

  double loc_avg, loc_diff;
  int best_val, run_total, count  = 0;

  double absValue(double);

  /* Loop 1:  calc min, max, number of elements, sum of elements */
  ptr = A;
  while (*ptr != -9999)
    {
      if (*ptr < loc_min) { 
	loc_min = *ptr;  
	*minimum = ptr;
      }
      if (*ptr > loc_max) { 
	loc_max = *ptr;  
	*maximum = ptr;
      }

      run_total += *ptr;      
      count++;
      ptr++;
    }

  loc_avg = (double) run_total / count; 

  /* Loop 2: find closest value in A to avg */
  ptr = A;
  while (*ptr != -9999)
    {
      loc_diff = absValue(*ptr - loc_avg);

      if (loc_diff < best_diff)
	{
	  best_diff = loc_diff;  best_val = *ptr;   
	  *median = ptr;
	}
      ptr++; 
    }

  /* return the average  */
  return( loc_avg );
}

double absValue( double  a ){ return( (a < 0) ? a * -1 : a );  }  

/* Local Variables: */
/* compile-command: "gcc -ansi -o final1a final1a.c -lm" */
/* End: */


