/*
   Big Hint #3 For Exam 1, Question 1
   
   This program demonstrates the passing back from a function an
   address for use in a main program.
*/

#include <stdio.h>

main()
{
  int  A[6] = {2,7,1,6,7,8};
  int *third;
  void findThird(int *, int **);

  printf("The value of the third element of A = %i, at addr = %p\n", 
	 A[2], &A[2]);

  findThird(A, &third);

  printf("The value of the third element of A = %i, at addr = %p\n", 
	 *third, third);
}

void findThird(int *A, int **t){ *t = &A[2]; }

/* Local Variables: */
/* compile-command: "gcc -ansi -o final1a-2 final1a-2.c -lm" */
/* End: */


