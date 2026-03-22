/*
 * An example of arrays of structures.
 */
#include <stdio.h>

struct employee
{
  int empno;
  double payrate;
};

main()
{
  int lookup(struct employee t[], int n, int targetno);

  struct employee emptable[5] =
    { {23, 10.50}, {51, 4.75}, {74, 8.75}, {85, 12.40}, {26, 18.10} };
  int nextemp, nexthours;
  int pos;

  while (scanf("%i %i", &nextemp, &nexthours) == 2)
  {
    pos = lookup(emptable, 5, nextemp);
    if (pos != -1) 
      printf("%i: %.2f\n", nextemp, nexthours * emptable[pos].payrate);
    else
      printf("%i: not found\n", nextemp);
  }
  return 0;
}

int lookup(struct employee t[], int n, int targetno)
{
  int i;

  for (i = 0; i < n; i++)
    if (t[i].empno == targetno)
      return i;
  return -1;
}
