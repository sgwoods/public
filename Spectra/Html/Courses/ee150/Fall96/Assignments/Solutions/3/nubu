/* 
   Sample Mini-Assignment 3 Functions
*/


/*
 The strange_cube function returns the cube of any floating point
 number (within the range of a "double"), EXCEPT for the value 10.0
 which is treated specially and has a strange_cube value of 10.0.
*/
double strange_cube ( double parameter1 )
{
  double temp = 0.0;

  if (parameter1 == 10.0)                            /* spectial case 10.0 */
    temp = 10.0;
  else                                               /* normal case, cube */ 
    temp = parameter1 * parameter1 * parameter1;

  return temp;
}

/*
 The display_cube function prints out a statement of a parameter and
 a strange_cube value.  A special requirement is that display_cube not
 include arithmetic functions - this requirment is met by calling 
 strange_cube directly from display_cube and thus making use of our already
 existing function.  Note that a prototype is required for this use of 
 strange_cube as well.  
*/
void display_cube ( double parameter1 )
{
  /* Need a prototype for used function since may be compiled separately */
  double strange_cube( double );

  printf("Strange Cube of %7.2lf is %7.2lf !", 
	 parameter1, strange_cube(parameter1) );
}
