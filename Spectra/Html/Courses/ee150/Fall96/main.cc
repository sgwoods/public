// main.cc

#include "Steve.h"
#include <iostream.h>

main()
{

Steve S(10), T(15), U(10);

// demonstrate operator overloading use of "=="

cout << "S == T is " << (S == T) << endl;
cout << "S == U is " << (S == U) << endl;
cout << "U == S is " << (U == S) << endl;
cout << "T == U is " << (T == U) << endl;

// demonstrate stream use of overloaded "<<"

cout << "The S object has a value of " << S << endl;
cout << "The T object has a value of " << T << endl;
cout << "The U object has a value of " << U << endl;

}
