/*
 * A program to calculate the cost of purchasing a range of textbooks.
 */
#include <stdio.h>

#define MAX_TEXTBOOKS   18
#define LIST_PRICE      49.95
#define DISCOUNT_RATE     .15
#define HAWAII_TAX_RATE    .040
#define FEDERAL_TAX_RATE  .080

main()
{
  double discount_price;           /* discounted price of textbook */
  double total_price;              /* total price of all textbooks */
  double hawaii_tax;               /* amount of state sales tax */
  double federal_tax;              /* amount of federal sales tax */
  double final_cost;               /* cost including sales tax */
  int    textbooks;                /* # of textbooks working with */

  /* Print out the repetitive table values once only */
  printf("List price per textbook:\t%7.2f\n", LIST_PRICE);
  printf("Discount rate:\t\t\t%6.1f%%\n", DISCOUNT_RATE * 100);
  printf("Hawaii tax rate:\t\t%6.1f%%\n", HAWAII_TAX_RATE * 100);
  printf("Federal tax rate:\t\t%6.1f%%\n\n", FEDERAL_TAX_RATE * 100);

  /* print out the table headers */
  printf("Texts\t   List\t\tDiscount\t  Total\t\t  Final\n");
  printf("Bought\t  Price\t\t   Price\t    Tax\t\t  Price\n");

  /* Print out a table of values for textbooks */
  for (textbooks = 1; textbooks <= MAX_TEXTBOOKS; textbooks = textbooks + 1)
  {
    /* calculate the total standard price of the texts we are buying */
    total_price = textbooks * LIST_PRICE;

    /* calculate the discount for a volume of textbooks */
    discount_price = total_price - total_price * DISCOUNT_RATE;

    /* calculate the hawaii/state tax we must pay */
    hawaii_tax = discount_price * HAWAII_TAX_RATE;

    /* calculate the federal tax we must pay */
    federal_tax = discount_price * FEDERAL_TAX_RATE;

    /* calculate the final cost of the texts */
    final_cost = discount_price + hawaii_tax + federal_tax;

    /* print out the table line item */
    printf("%2d\t%7.2f\t\t%8.2f\t%7.2f\t\t%7.2f\n",
           textbooks, total_price, discount_price, hawaii_tax + federal_tax,
	   final_cost);
  }
  return 0;
}
