#include <stdio.h>

main()
{
  void inputValues();
  
  inputValues();

  return 0;
}

void inputValues()
{
  int result; int i; int val;
  int Fbig(int);

  while (scanf("%i", &val) == 1)
  {
    result = Fbig(val);
    printf("Fbig of %i is %i.\n", val, result);
  }  
}

int Fbig1(int i)
{
  if (i <= 1)
    return 1;
  else return i * Fbig(i - 1); 
}

/* alternative solution */
int Fbig(int i)              /* function definition */
{ 
  int j;
  int sofar;

  sofar = 1; 
  for (j = i; j > 1; j = j - 1)
  {
    sofar = sofar * j;
  }
 return sofar;
}

