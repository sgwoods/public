/*
 * An improved version of our cost-computing program.
 */
#include <stdio.h>

#define ITEMS           23
#define LIST_PRICE      13.95
#define DISCOUNT_RATE     .18
#define SALES_TAX_RATE    .075

main()
{
  double discount_price;           /* discounted price of item */
  double total_price;              /* total price of all items */
  double sales_tax;                /* amount of sales tax */
  double final_cost;               /* cost including sales tax */

  total_price = ITEMS * LIST_PRICE;
  discount_price = total_price - total_price * DISCOUNT_RATE;
  sales_tax = discount_price * SALES_TAX_RATE;
  final_cost = discount_price + sales_tax;

  printf("List price per item:\t\t%7.2f\n", LIST_PRICE);
  printf("List price of %i items:\t\t%7.2f\n", ITEMS, total_price);
  printf("Price after %.1f%% discount:\t%7.2f\n",
         DISCOUNT_RATE * 100, discount_price);
  printf("Sales tax at %.1f%%:\t\t%7.2f\n",
         SALES_TAX_RATE * 100, sales_tax);
  printf("Total cost:\t\t\t%7.2f\n", final_cost);

  return 0;
}
