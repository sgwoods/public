main()
{
  int t, v = 0;
  for (v = 10; t < 6, t > 5; v++)
    {
      printf(" In Loop: t= %i v= %i\n", t, v);  
      t += 2;
      v -= 3;
    }
  printf("Done: v = %i, t = %i\n", v, t);
  return 0;
}

/* Local Variables: */
/* compile-command: "gcc -ansi -o fm2-1a fm2-1a.c -lm" */
/* End: */
