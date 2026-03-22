/*
 * A program to calculate the cost of purchasing textbooks.
 */
#include <stdio.h>

#define TEXTBOOKS       18
#define LIST_PRICE      49.95
#define DISCOUNT_RATE     .15
#define SALES_TAX_RATE    .040

main()
{
  double discount_price;           /* discounted price of texts */
  double total_price;              /* total price of all texts */
  double sales_tax;                /* amount of sales tax */
  double final_cost;               /* cost including sales tax */

  total_price = TEXTBOOKS * LIST_PRICE;
  discount_price = total_price - total_price * DISCOUNT_RATE;
  sales_tax = discount_price * SALES_TAX_RATE;
  final_cost = discount_price + sales_tax;

  printf("List price per textbook:\t%7.2f\n", LIST_PRICE);
  printf("List price of %i textbooks:\t%7.2f\n", TEXTBOOKS, total_price);
  printf("Price after %.1f%% discount:\t%7.2f\n",
         DISCOUNT_RATE * 100, discount_price);
  printf("Hawaii sales tax at %.1f%%:\t%7.2f\n",
         SALES_TAX_RATE * 100, sales_tax);
  printf("Total cost of textbooks:\t%7.2f\n", final_cost);

  return 0;
}
