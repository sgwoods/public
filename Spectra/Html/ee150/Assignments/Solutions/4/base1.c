   /* This program will read in a binary number and print the result of
      converting this number into decimal number   */

#include<stdio.h>

 main()
  {
    int value=0; /* set the variable for the value of decimal number */
    char c=' ' ; /* set the variable for the present reading character */

  /* read in the digit character and display one by one */ 
    while((c=getchar())!='\n')
        {
         putchar(c);
         if((c -'0')<=1&& (c-'0')>=0) value= 2*value + (c-'0');
 
         }
 /* output result */
    printf(" is %i\n ",value);
   }

