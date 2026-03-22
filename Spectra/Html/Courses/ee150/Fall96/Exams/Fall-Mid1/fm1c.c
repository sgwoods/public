main()
{
  int i;
  double b;
  int c;  int j;
  int change (int);
  
  b = (int) (13.4 + 12.54);
  c = b * 0.5;  
  j = c - 5;

  printf("b=%4.2f, c=%i, j=%i\n", b,c,j);

  b = change( j );

  printf("b=%4.2f, j=%i\n", b,j);

  for (i = c; i >= 0; i = i - j)
    printf("lp i=%i\n", i);

  printf("dn i=%i\n", i);
}

int change ( int j )
{ 
  j = j * 2; 
  return (int) (j * 2.0); 
}
