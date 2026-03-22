#include <iostream.h>
#include "array-template.cc"

main()
{
  Array<int> t(100);
  Array<int> s(100);

  t.Put(20, 99);
  t.Put(40, 199);
  s = t;
  
  cout << "t 20th position value is " << t.Get(20) << endl;
  cout << "t length is " << t.Length() << endl;
  cout << "s 20th position value is " << s.Get(20) << endl;
  cout << "s length is " << s.Length() << endl;

  Array<double> d1(15);

  d1.Put(8, 3.141529);
  cout << "d1 length is " << d1.Length() << endl;
  cout << "d1 9th position is " << d1.Get(8) << endl;
  cout << "d1 12th position is " << d1.Get(12) << endl;
  cout << "d1 15th position is " << d1.Get(15) << endl;

}

/* Local Variables: */
/* compile-command: "g++ -Wall -g -o main-array array-template.o main-array.cc" */
/* End: */
