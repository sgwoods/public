#include<stdio.h>
main()
{
  int *L;  int *p;
  int s, i,j, ror, rand; 

  scanf("%i",&s);
  if((L = (int *) malloc(s * s * sizeof(int))) == NULL) return -1;
  p = L;
  for(i=0;i<s;i++) 
    for(j=0;j<s;j++) {
      scanf("%i",p);
      if ( (*p < 0) || (*p > 1) ) return -2;
      p++; }
  
  p = L;
  for(i=0;i<s;i++) {
      for(j=0;j<s;j++) 
	printf("%i",*p++);
      printf("\n"); }

  p = L;
  for(i=0;i<s;i++) {
    ror  = 0;  rand = 1;
    for(j=0;j<s;j++) {
      ror  = ror  || *p;
      rand = rand && *p++; }
    printf("Row %i:  ROR = %i, RAND = %i\n", i, ror, rand); }
}

/* Local Variables: */
/* compile-command: "gcc -ansi -o final1b final1b.c -lm" */
/* End: */
