/*
 * Print the average of the input scores.
 */
#include <stdio.h>

main()
{
   int values;
   double sum;
   int n;
   int score;
   double avg;

   values = 0;
   sum = 0;
   n = scanf("%i", &score);
   while (n == 1)
   { 
     values = values + 1;
     sum = sum + score;
     n = scanf("%i", &score);
   }
   if (values != 0)
     avg = sum / values;
   else
     avg = 0;
   printf("The average is %.1f\n", avg);
   return 0;
}
