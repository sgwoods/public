/* Print powers of 2 forwards from 0 through FINISH followed by
   the total.  That is, for FINISH = 7,  output should be: 
   1 2 4 8 16 32 64 128 = 255 */ 

#include <stdio.h>

#define FINISH 7

main()
{
  int count;                             /* all variables should be ints */
  int p;
  int total;

  total = 0;                             
  count = 0;

  p = 1;
  while (count <= FINISH)               /* actually we should check count */
  {                                     /* also &lt;&lt;= should be &lt;= */ 
    printf("%i ", p);
    total = total + p;
    p = p * 2;                         /* powers means multiply by 2 not add */
    count = count + 1;
  }

  printf(" = %i\n", total);           /* hey - print out the total not count */
  return 0;
}



