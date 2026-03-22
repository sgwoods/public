// Steve.h
/*
   The Steve class is designed as an example of using operator overload. It
   shows how == is overloaded for use with Steve object instances.  

   Note that this example is approximately what was shown in class on
   September 23rd's video and followed-up on September 25 class discussion.

   Note also that an ostream operator is also included as an example.  
   Unfortunately I could only get it to work using the "friend" category
   I discussed in class.  Perhaps  we can get Alex to clear this up later.
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

   friend ostream& operator<<(ostream& str, const Steve& s);

};


// Inlines

inline int Steve::getx()
{ return Steve_x; }

inline int Steve::operator==(const Steve &steve2)
{  return Steve_x == steve2.Steve_x; }


