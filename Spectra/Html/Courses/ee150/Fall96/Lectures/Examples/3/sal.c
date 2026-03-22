/*
 * Adding the taxes column to the salary table.
 */
#include <stdio.h>

#define WAGE      8.50       
#define TAX_RATE   .18        

#define MIN_HOURS    5
#define MAX_HOURS   40
#define INCR_HOURS   5

main()
{
  int hours;     
  double salary;
  double taxes;
  double take_home;

  printf("Hourly pay: %.2f\n", WAGE);
  printf("Tax rate: %.2f%%\n\n", TAX_RATE);

  printf("Hours\tGross Pay\t  Taxes\t\tTake Home\n");

  hours = MIN_HOURS;
  while (hours <= MAX_HOURS)
  {
    salary = hours * WAGE;
    taxes = salary * TAX_RATE;
    take_home = salary - taxes;
    printf("%i\t%7.2f\t\t%7.2f\t\t%7.2f\n", hours, salary, taxes, take_home);
    hours = hours + INCR_HOURS;
  }
  return 0;
}
