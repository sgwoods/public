main()
{
  double n;
  int m; int p;

  n = 96;
  while (n > 13)
  {
    n = n / 2;
    if (n < 35)
      printf("Okay %4.2f\n",  n);
    else
      printf("No way %4.1f\n", n);
  }
m = n + 1 + 0.51;
printf("O vay %i\n", m);
}
