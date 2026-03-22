main()
{
  int i, a = 0;
  int A[5] = { 4, 3, 2, 1, 0};
  for (i = 0; i < 5; i = (a += 1))
    switch( i )
      {
      case 1: A[i]= 5;  break;
      case 2: 
      case 3: A[i] = A[ (int) i/2 ];   break;
      case 4: A[i] = 7; break;
      default: A[i] = A[i + 3]; break;
      }
  for (i = 0; i < 5; i++)
    printf("Array A element %i is %i\n", i, A[i]); 

  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -ansi -o fm2-1c fm2-1c.c -lm" */
/* End: */
