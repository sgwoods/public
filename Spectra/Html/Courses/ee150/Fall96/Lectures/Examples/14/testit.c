/*
 * Test function/program for strcmp.
 */
#include <stdio.h>

main()
{
  void teststrcmp(char s1[], char s2[], int expres);

  teststrcmp("anthony", "alex", 1);
  teststrcmp("alex", "anthony", 1);
  teststrcmp("whatever", "something", 1);
  teststrcmp("something", "whatever", 1);
  teststrcmp("alex", "alex", 0);
  teststrcmp("", "", 0);
  teststrcmp("a", "at", 1);
  teststrcmp("at", "a", 1);
}

void teststrcmp(char s1[], char s2[], int expres)
{
  int res = strcmp(s1, s2);

  if (res != expres)
    printf("strcmp(\"%s\",\"%s\") failed with result %i (expected: %i)\n",
           s1, s2, res, expres);
}
