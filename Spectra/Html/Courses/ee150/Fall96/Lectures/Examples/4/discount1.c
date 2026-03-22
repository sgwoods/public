/*
 * A version of our cost-computing program that allows the items
 * and list price to be read in, and the discount rate computed
 * automatically.
 */
#include <stdio.h>

main()
{
  int    items;
  double list_price;
  double total_price;          
  double discount_rate;      
  double discount_price;      

  scanf("%i %lf", &items, &list_price);

  if (items >= 10)   /* bigger discount for 10 or more items */
    discount_rate = .20;
  else
    discount_rate = .10;

  total_price = items * list_price;
  discount_price = total_price - total_price * discount_rate;

  printf("List price per item:\t\t%7.2f\n", list_price);
  printf("List price of %i items:\t\t%7.2f\n", items, total_price);
  printf("Price after %.1f%% discount:\t%7.2f\n",
         discount_rate * 100, discount_price);

  return 0;
}
