
#include <stdio.h>
main()
{
  int  i = 2;  int j = 3; int k;     /*                                   */
  int  *ptr1, *ptr2, *ptr3;          /*                                   */

  ptr1 = &j, ptr2 = &i;              /*                                   */
                                     /*                                   */
  printf("*ptr1 = %i,  *ptr2 = %i\n", *ptr1, *ptr2);

  k = *ptr1 * *ptr2;                 /*                                   */
  printf("k = %i\n", k);            

  ptr3 = &k;                         /*                                   */
  printf("*ptr3 = %i\n", *ptr3);    

  k += 5;                            /*                                   */
  printf("Now k = %i\n", k);         
  printf("Now *ptr3 = %i\n", *ptr3); 

  *ptr3 = 15;       /*                                                     */
  ptr2 = ptr1;      /*                                                     */
  k = *ptr2;        /*                                                     */
  printf("Finally k = %i\n", k);
  printf("Finally *ptr3 = %i\n", *ptr3);
}

