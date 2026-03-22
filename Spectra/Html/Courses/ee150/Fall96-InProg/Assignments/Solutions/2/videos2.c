/*
 * A program to calculate the cost of purchasing a range of videos.
 */
#include <stdio.h>

#define MAX_VIDEOS      12
#define LIST_PRICE       8.95
#define DISCOUNT_RATE     .12
#define SALES_TAX_RATE    .040

main()
{
  double discount_price;           /* discounted price of cd */
  double total_price;              /* total price of all cds */
  double sales_tax;                /* amount of sales tax */
  double final_cost;               /* cost including sales tax */
  int    videos;                   /* # of videos working with */

  printf("List price per video:\t%7.2f\n", LIST_PRICE);
  printf("Discount rate:\t\t%6.1f%%\n", DISCOUNT_RATE * 100);
  printf("Sales tax rate:\t\t%6.1f%%\n\n", SALES_TAX_RATE * 100);

  printf("Videos\t   List\t\tDiscount\t  Sales\t\t  Final\n");
  printf("Bought\t  Price\t\t   Price\t    Tax\t\t  Price\n");

  for (videos = 1; videos <= MAX_VIDEOS; videos = videos + 1)
  {
    total_price = videos * LIST_PRICE;
    discount_price = total_price - total_price * DISCOUNT_RATE;
    sales_tax = discount_price * SALES_TAX_RATE;
    final_cost = discount_price + sales_tax;

    printf("%2d\t%7.2f\t\t%8.2f\t%7.2f\t\t%7.2f\n",
           videos, total_price, discount_price, sales_tax, final_cost);
  }
  return 0;
}
