/*
 * A program to compute gas milage and more!
 */
#include <stdio.h>

#define MILES_DRIVEN     400.4
#define GALLONS_BOUGHT    17.2
#define COST_PER_GALLON    1.739

main()
{
  double total_cost;               /* total cost (computed) */
  double miles_per_gallon;         /* miles per gallon (computed) */
  double cost_per_mile;            /* cost per mile (computed) */
  double unused_gas;               /* gas left over (computed) */
  double miles_remaining;          /* miles left on tank (computed) */
  double maximum_capacity;         /* miles possible on tank (computed) */

  total_cost = GALLONS_BOUGHT * COST_PER_GALLON;
  miles_per_gallon = MILES_DRIVEN / GALLONS_BOUGHT;
  cost_per_mile = COST_PER_GALLON / miles_per_gallon;

  printf("Miles driven:\t\t %4.1f\n", MILES_DRIVEN);
  printf("Gas gallons purchased:\t%7.2f\n", GALLONS_BOUGHT);
  printf("Car miles per gallon:\t%7.2f\n\n", miles_per_gallon);

  printf("Gas cost per gallon:  \t$%7.3f\n", COST_PER_GALLON);
  printf("Car total cost:       \t$%6.2f\n", total_cost);
  printf("Car cost per mile:    \t$%7.3f\n\n", cost_per_mile);

  return 0;
}
