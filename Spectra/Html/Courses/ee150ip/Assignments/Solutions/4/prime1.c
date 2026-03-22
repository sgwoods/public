/*
 * Solution to assignment #4, part #3.
 */
#include <stdio.h>
#include <math.h>

#define YES 1
#define NO  0

int main()
{
  void printPrimes(long start, long finish);

  long start;
  long finish;

  scanf("%li %li", &start, &finish);
  printPrimes(start, finish);
  return 0;
}

/*
 * Print all the primes between start and finish.
 */
void printPrimes(long start, long finish)
{
  int prime(long x);

  long i;

  for (i = start; i <= finish; i++)
    if (prime(i))
      printf("%li\n", i);
}

/*
 * Determine if X is prime.
 */
int prime(long x)
{
  int i;

  if (x >= 0 && x <= 2)               /* 0, 1 and 2 are prime */
    return YES;
  if (x % 2 == 0)                     /* even numbers aren't */
    return NO;
  for (i = 3; i <= sqrt(x); i+= 2)    /* otherwise try dividing */
    if (x % i == 0)
      return NO;
  return YES;
}
