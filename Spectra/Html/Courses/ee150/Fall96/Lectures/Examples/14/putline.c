/*
 * A function to print a string on a line by itself (the equivalent
 * of printf("%s", string);
 */
#include <stdio.h>

main()
{  
  void printline(char s[]);

  printline("alex");
  printline("was");
  printline("here");
}

void printline(char s[])
{
  int i;

  for (i = 0; s[i] != '\0'; i++)
    putchar(s[i]);
  putchar('\n');
}
