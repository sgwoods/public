/*
 * A program to compute gas milage (reading info from the input)
 */
#include <stdio.h>

#define COST_PER_GALLON    1.739
#define TANK_CAPACITY     14.00

main()
{
  int    miles_driven;             /* miles_driven (input) */
  double gallons_bought;           /* gallons_bought (input) */

  double total_cost;               /* total cost (computed) */
  double miles_per_gallon;         /* miles per gallon (computed) */
  double cost_per_mile;            /* cost per mile (computed) */
  double unused_gas;               /* gas left over (computed) */
  double miles_remaining;          /* miles left on tank (computed) */
  double maximum_capacity;         /* miles possible on tank (computed) */

  int    n;                        /* inputs read (from scanf) */

  while ((n = scanf("%i %lf", &miles_driven, &gallons_bought)) == 2)
  {
    total_cost = gallons_bought * COST_PER_GALLON;
    miles_per_gallon = miles_driven / gallons_bought;
    cost_per_mile = COST_PER_GALLON / miles_per_gallon;
    unused_gas = TANK_CAPACITY - gallons_bought;
    miles_remaining = unused_gas * miles_per_gallon;
    maximum_capacity = miles_driven + miles_remaining;
    
    printf("Miles driven:     \t%4i\n", miles_driven);
    printf("Gallons purchased:\t%7.2f\n", gallons_bought);
    printf("Miles per gallon: \t%7.2f\n\n", miles_per_gallon);
  
    printf("Cost per gallon:  \t$%7.3f\n", COST_PER_GALLON);
    printf("Total cost:       \t$%6.2f\n", total_cost);
    printf("Cost per mile:    \t$%7.3f\n\n", cost_per_mile);
  
    printf("Unused gas:       \t%7.2f\n", unused_gas);
    printf("Miles remaining:  \t%7.2f\n", miles_remaining);
    printf("Maximum distance: \t%7.2f\n", maximum_capacity);
  }
  return 0;
}
