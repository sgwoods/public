/*
 * A program to compute gas mileage and more!
 */

#include <stdio.h>

#define COST_PER_GALLON    1.739
#define BUS_COST_PER_100   1.00
#define EXTRA_MILE_COST    0.05

main()
{
  double miles_driven;             /* miles_driven (input) */
  double gallons_bought;           /* gallons_bought (input) */

  double total_cost;               /* total cost (computed) */
  double miles_per_gallon;         /* miles per gallon (computed) */
  double cost_per_mile;            /* cost per mile (computed) */
  double unused_gas;               /* gas left over (computed) */
  double miles_remaining;          /* miles left on tank (computed) */
  double maximum_capacity;         /* miles possible on tank (computed) */

  double bus_cost_this_trip;       /* bus cost this trip (computed) */
  double bus_cost_per_mile;        /* bus cost per mile (computed) */
  double bus_savings;              /* total possible bus saving (computed) */

  int    n;                        /* inputs read (from scanf) */

  /* Iterate for series of input trips: miles and gallons */

  while ((n = scanf("%lf %lf", &miles_driven, &gallons_bought)) == 2)
  {

    /* Calculate the total cost of driving the car this trip  */
    total_cost = gallons_bought * COST_PER_GALLON + 
      EXTRA_MILE_COST * miles_driven;

    /*  Calculate the mileage for the car this trip */
    miles_per_gallon = miles_driven / gallons_bought;
    cost_per_mile = COST_PER_GALLON / miles_per_gallon
      + EXTRA_MILE_COST;

    /* Calculate the cost of using the bus, this trip, and  per mile */
    bus_cost_this_trip = BUS_COST_PER_100 * ( miles_driven / 100 );
    bus_cost_per_mile  = bus_cost_this_trip / miles_driven;

    /* How much do we save using the bus ? */
    bus_savings  = total_cost - bus_cost_this_trip;

    /* Print out the requested table of results ... */

    printf("Miles driven:\t\t %4.1f\n", miles_driven);
    printf("Gas gallons purchased:\t%7.2f\n", gallons_bought);
    printf("Car miles per gallon:\t%7.2f\n\n", miles_per_gallon);

    printf("Gas cost per gallon:  \t$%7.3f\n", COST_PER_GALLON);
    printf("Car total cost:       \t$%6.2f\n", total_cost);
    printf("Car cost per mile:    \t$%7.3f\n\n", cost_per_mile);

    printf("Total trip bus cost: \t$%6.2f\n", bus_cost_this_trip);
    printf("Bus cost per mile: \t$%8.4f\n", bus_cost_per_mile);
    printf("Bus over car saving: \t$%6.2f\n\n", bus_savings);
  } 

  return 0;
}
