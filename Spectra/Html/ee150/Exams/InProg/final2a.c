#include <stdio.h>

main()
{
int n;
int table[] = {31, 17, 26, 9, 6, 17, 19, 17, 21, 17, 96, 108, 61, 19, 17};
void  printT(char *c, int x[], int n );

printT("Table Before",table,15);

n =  replace(table, 17, 40, 9);

printT("Table After", table,15);
printf("Final n value = %i\n", n); 

}

void  printT(char *c, int x[], int n ) {
  int i;
  printf("%s:\n",c);
  for (i = 0; i < n; i++) {
    printf("Table at %i is %i\n", i, x[i]);
  }
}

int replace(int x[], int old, int new, int stop)  {
  int i;
  printf("Replace Call: old = %i, new = %i, stop = %i\n", old, new, stop);
  for (i = 1; x[i] >= stop; i++)
    {
      printf("Replace Loop: i = %i, x[i] = %i\n", i, x[i]);
      if (x[i] != old)
	{
	  x[i] = new;
	  printf("Replace New : i = %i, x[i] = %i\n", i, x[i]);
	}
    }
  printf("Replace Return value is i = %i\n", i);
  return i;
}

/* Local Variables: */
/* compile-command: "gcc -ansi -o final2a final2a.c -lm" */
/* End: */


