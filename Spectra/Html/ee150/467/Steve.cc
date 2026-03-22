// Steve.cc

#include "Steve.h"

// Constructor

Steve::Steve(int new_x)
{
  Steve_x = new_x;
}

// Destructor (default)

 Steve::~Steve(){}


// Member Functions

// Special (friend) Member Functions

ostream& operator<<(ostream& str, const Steve& s)
{
	str << "Sval =" << s.Steve_x << " ";
  	return str;
}



