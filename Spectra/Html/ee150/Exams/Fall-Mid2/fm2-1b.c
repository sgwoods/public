main()
{
  int f1 (int);
  int j = 12;
  int y = 15;
  do
    {
      int y = 10;
      y = f1 ( y );
      printf("In Loop: y = %i, j = %i \n", y, j), --j;
    }
  while( y > 0 && j != 10 );
  return 0;
}

int f1 ( int y )
{
  return y -= y;
}

/* Local Variables: */
/* compile-command: "gcc -ansi -o fm2-1b fm2-1b.c -lm" */
/* End: */
