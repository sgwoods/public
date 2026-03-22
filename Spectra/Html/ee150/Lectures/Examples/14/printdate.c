/*
 * Example of passing a structure as a paramter.
 */
#include <stdio.h>

struct date
{
  int month;
  int day;
  int year;
};

main()
{
  void print_date(struct date d);
  struct date today = { 4, 19, 1996 };

  print_date(today);
  return 0;
}

void print_date(struct date d)
{
  if (d.month < 10)
    printf(" ");
  printf("%i/", d.month);
  if (d.day < 10)             /* so dates are always xx/xx/year */
    printf("0");
  printf("%i/", d.day);
  printf("%2i\n", d.year - 1900);
}
