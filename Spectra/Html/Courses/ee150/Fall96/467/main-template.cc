#include <iostream.h>
#include "template-function.cc"

main()
{
  int x = 10;  int y = 15;  int t = 99;

  cout << "The min of " << x << " and " << y << " is " << min(x,y) << "." << endl;
  cout << "The minRef of " << x << " and " << y << " is " << *minRef(&x, &y) << "." << endl;

}

/* Local Variables: */
/* compile-command: "g++ -Wall -g -o main-template template-function.o main-template.cc" */
/* End: */
