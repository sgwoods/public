/* 
   Minimal Mini-Assignment 3 Functions
*/

double strange_cube ( double p1 )
{
  if (p1 == 10.0) return 10.0;  
  else return p1 * p1 * p1; 
}

void display_cube ( double p1 )
{
  double strange_cube( double );
  printf("Strange Cube of %7.2lf is %7.2lf !", p1, strange_cube(p1) );
}
