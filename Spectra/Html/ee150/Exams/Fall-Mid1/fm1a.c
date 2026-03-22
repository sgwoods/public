main()
{
  int a;  int b;   int c;   int p;
  int dostuff(int,int,int);

  a = 1;  b = a * 3;  c = b - a + 5;  p = dostuff(a, b, c);
  printf("xx: %i\n", p);
  a = b + p;
  printf("xx: %i\n", a);
  printf("xx: %i\n", b);
}

int dostuff(int c, int a, int b)
{
  printf("yy: %i,%i,%i\n", a, b, c);
  return a + b * c;
}
