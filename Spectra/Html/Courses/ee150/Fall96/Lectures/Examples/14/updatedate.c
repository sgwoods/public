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
  void update_date(struct date *dptr);
  struct date today = { 4, 30, 1996 };

  printf("Today is:    "); print_date(today);
  update_date(&today);
  printf("Tomorrow is: "); print_date(today);
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

void update_date(struct date *dptr)
{
  int lastDayOfMonth(int month, int day);

  if (dptr->month == 12 && dptr->day == 31)
  {
    dptr->year++;
    dptr->month = dptr->day = 1;
  }
  else if (lastDayOfMonth(dptr->month, dptr->day))
  {
    dptr->month++;
    dptr->day = 1;
  }
  else
    dptr->day++;
}

/* Is it last day of month?  Doesn't handle leap years! */

int lastDayOfMonth(int month, int day)
{ 
  int days[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

  return day == days[month - 1];
}
