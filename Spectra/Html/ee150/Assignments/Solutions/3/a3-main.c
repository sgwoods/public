/* 
   A program to play with strange cubes!
*/

#include <stdio.h>

#define  VAL1 10.0
#define  VAL2  3.0
#define  VAL3 15.0

main()
{

  /* Local variables */

  double test1, test2;

  /* Function Prototypes */

  double strange_cube ( double parameter1 );   
  /* 
     Function strange_cube always returns the cube of a given value - 
     except if the passed parameter is 10.0 in which case the function
     returns 10.0 !! 
     */

  void display_cube ( double parameter1 );
  /* 
     Function display_cube simply prints out the following sentence
     if the passed parameter is N ... and the strange_cube of N is C

     "Strange Cube of N is C!"

     Note that an unfortunate requirement of display_cube is that one
     may not use arithmetic statements such as "*, -, / or +" 
     inside the function!
     */

  
  /* main program starts .... */

  test1 = strange_cube( VAL1 );
  test2 = strange_cube( VAL2 );
  if ( (test1 == 10.0) && (test2 == 27.0) )
    printf("All is well with main - strange_cube!\n");
  else
    printf("Oh oh - problems with main - strange_cube!\n");

  printf("\n Let's call display_cube once with VAL3!  We expect 3375.\n");
  display_cube( VAL3 );

  printf("\n That's all folks! \n\n");

  return 0;
}
