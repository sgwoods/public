/*
 * Keep a count of times function is called (buggy version).
 */
#include <stdio.h>

int main()
{
  void testfunc(void);

  testfunc(); testfunc(); testfunc();
  return 0;
}

void testfunc(void)
{
  int cnt = 0;

  printf("testfunc call #%i\n", ++cnt);
}
