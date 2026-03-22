/*
 * A program to compute gas milage.
 */
#include <stdio.h>

#define MILES_DRIVEN     310
#define GALLONS_BOUGHT    13.25
#define COST_PER_GALLON    1.739
#define TANK_CAPACITY     14.00

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
  unused_gas = TANK_CAPACITY - GALLONS_BOUGHT;
  miles_remaining = unused_gas * miles_per_gallon;
  maximum_capacity = MILES_DRIVEN + miles_remaining;
  
  printf("Miles driven:     \t%4i\n", MILES_DRIVEN);
  printf("Gallons purchased:\t%7.2f\n", GALLONS_BOUGHT);
  printf("Miles per gallon: \t%7.2f\n\n", miles_per_gallon);

  printf("Cost per gallon:  \t$%7.3f\n", COST_PER_GALLON);
  printf("Total cost:       \t$%6.2f\n", total_cost);
  printf("Cost per mile:    \t$%7.3f\n\n", cost_per_mile);

  printf("Unused gas:       \t%7.2f\n", unused_gas);
  printf("Miles remaining:  \t%7.2f\n", miles_remaining);
  printf("Maximum distance: \t%7.2f\n", maximum_capacity);

  return 0;
}
