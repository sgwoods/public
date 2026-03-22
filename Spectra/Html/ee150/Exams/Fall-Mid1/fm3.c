#include <stdio.h>

main()
{
  int count_a;
  int count_all;
  int percent_a;
  double score;
  int classify_got_A( double grade );

  count_a = count_all = 0;
  while (scanf("%lf", &score) == 1)
  {
    count_all = count_all + 1;
    if ( classify_got_A(score) )
      count_a = count_a + 1;
  }
  percent_a = (count_a * 100) / count_all; 
  printf("%i%% of the students (%i out of %i) got A's", 
         percent_a, count_a, count_all);

  return 0;
}

int classify_got_A( double grade )
{
   if (grade >= 90)
     return 1;
   else return 0;
}
