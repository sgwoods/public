
main()
{
  int a;  int b;   int c;  int d;  double dd;

  int    dostuff(int,int,int);
  double dostuff2(int,int,int);

  a = 2;  b = a * 3 - 4;  c = b - a + 5 * 1.2;  d = dostuff(c, b, a);
  printf("xx d = %i\n", d);  printf("xx b = %i\n", b);
  a = b - d;
  printf("xx a = %i\n", a);  printf("xx b = %i\n", b);
  dd = dostuff2(c,b,a);      printf("xx dd : %5.2f\n", dd);
  dd = (int) dd / 2;         printf("xx dd : %5.1f\n", dd);
}

int dostuff(int c, int a, int b)
{ 
  int i;
  for (i = c; i < a + 3; i = i + 1) 
      b = b + i;
  printf("y0: a b c = %i,%i,%i\n", a, b, c);
  return a + b + c;
}

double dostuff2(int c, int a, int b)
{
  a = a * b;
  printf("y1: a b c = %5.1f,%i,%i\n", (double) a, b, c);
  return (double) a + c * b;
}

