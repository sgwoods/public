// Steve1.h
/*
   VERSION 2 : Note this version ensures that << is a regular function,
   not a class member function.

   The Steve class is designed as an example of using operator overload. It
   shows how == is overloaded for use with Steve object instances.  

   Note that this example is approximately what was shown in class on
   September 23rd's video and followed-up on September 25 class discussion.
*/

#include <iostream.h>

class Steve
{
 private:

 int Steve_x; 

 public:

 Steve(int new_x);
 ~Steve();

 // Accessors
   int getx();

 // Member Functions
   int operator==(const Steve &steve2);

};


// Inlines

inline int Steve::getx()
{ return Steve_x; }

inline int Steve::operator==(const Steve &steve2)
{  return Steve_x == steve2.Steve_x; }


// Related Functions (not Member Functions)

inline ostream& operator<<(ostream& str, Steve& s)
{
	str << "Sval =" << s.getx() << " ";
  	return str;
}
