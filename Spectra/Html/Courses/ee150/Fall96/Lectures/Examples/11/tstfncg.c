/*
 * Keep a count of times function is called (using globals).
 */
#include <stdio.h>

int main()
{
  void testfunc(void);

  testfunc(); testfunc(); testfunc();
  return 0;
}

int cnt = 0;    

void testfunc(void)
{
  printf("testfunc call #%i\n", ++cnt);
}
