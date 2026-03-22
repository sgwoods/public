//
// Class declaration for provided String class.
//
#if !defined(CLASS_STRING)
#define CLASS_STRING


#include <iostream.h>

typedef int bool;
#define true 1
#define false 0

class String
{
  public:
    String(char *init_value = 0);        // constructor from C string
    String(int n);                       // constructor: n+1 '\0's in string
    String(const String& s);             // copy constructor
    ~String();                           // destructor
  
    String& operator=(const String& s);  // assignment
   
    int Length() const;                  // # of chars in string
    char Get(int i) const;               // return ith char in string
    void Put(int i, char c);             // modify ith char in string

    bool operator==(const String& s) const;  // string equality
    bool operator!=(const String& s) const;  // string inequality
    bool operator<(const String& s) const;   // string less than
    bool operator>(const String& s) const;   // string greater than
    bool operator>=(const String& s) const;  // string greater than or equal
    bool operator<=(const String& s) const;  // string less than or equal
 
  private:
    char *data;           // the allocated data
    int size;             // actual allocated size
    int len;              // number of non-\0 chars before \0
 
    void InitFromCopy(const String& s);
    void CleanUp();
    bool ValidIndex(int i) const;
    void Append(char c);  // add char past end of string (unsafe)
    void MakeNull();      // make string a null string
    void MakeValid();     // ensure string is valid

  // The I/O operations, with a smart input

  friend ostream& operator<<(ostream& o, const String &s);
  friend istream& operator>>(istream& i, String &s);
};

#include "str_inl.h"

#endif
