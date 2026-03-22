//
// Template array class.
//
// Array element must have
//    1) No-argument constructor
//    2) Assignment operator
//    3) == operator

#if !defined(CLASS_ARRAY_TEMPLATE)
#define CLASS_ARRAY_TEMPLATE

#include <iostream.h>
#include <stdlib.h>

template<class T>
class Array
{
  public:
    Array(int n);
    Array(const Array<T>& other);
    ~Array();
    Array& operator=(const Array<T>&);

    T Get(int index) const;
    int Length() const;
    int operator==(const Array<T>& other) const;
    int operator!=(const Array<T>& other) const;

    void Put(int index, T value);

  private:
    void InitFromCopy(const Array<T>& other);
    void CleanUp();
    int IsValidIndex(int i) const;

    T *elements;
    int size;
};

template<class T>
inline Array<T>::Array(int n)
  { elements = new T[size = n]; }  // T must have default constructor 

template<class T>
void Array<T>::InitFromCopy(const Array<T>& other)
{
  elements = new T[size = other.size];
  for (int i = 0; i < size; i++)
    elements[i] = other.elements[i];  // use T operator= (not memcpy!)
}

template<class T>
inline Array<T>::Array(const Array<T>& other)
  { InitFromCopy(other); }

template<class T>
inline void Array<T>::CleanUp()
  { delete [] elements; }

template<class T>
inline Array<T>::~Array()
  { CleanUp(); }

template<class T>
Array<T>& Array<T>::operator=(const Array<T>& other)
{ 
   if (this != &other)
   {
     InitFromCopy(other);
     CleanUp();
   }
   return *this;
}

template<class T>
inline int Array<T>::IsValidIndex(int index) const
  { return index >=0 && index < size; }
  
template<class T>
inline T Array<T>::Get(int index) const
{
  if (!IsValidIndex(index))
  {
    cerr << "Warning (Array<T>::Get) illegal index " << index << endl;
    exit(1);
  }
  return elements[index];    
}

template<class T>
inline void Array<T>::Put(int index, T value)
{
  if (!IsValidIndex(index))
    cerr << "Warning (Array<T>::Put) illegal index " << index << endl;
  else
     elements[index] = value;
}

template<class T>
inline int Array<T>::Length() const
  { return size; }

template<class T>
int Array<T>::operator==(const Array<T>& other) const
{
  if (size != other.size) return 0;

  for (int i = 0; i < size; i++)
    if (elements[i] != other.elements[i])
      return 0;
  return 1;
}

template<class T>
inline int Array<T>::operator!=(const Array<T>& other) const
  { return !operator==(other); }
  
#endif

/* Local Variables: */
/* compile-command: "gcc -ansi -c array-template.cc" */
/* End: */
