/*
 * Solution to assignment #4, part #4.
 */
#include <stdio.h>
#include <math.h>

#define YES 1
#define NO  0

int main()
{
  void printAscending(int start, int finish);
  void printDescending(int start, int finish);
  int yesorno();

  long start;
  long finish;
  int answer;
  int c;

  printf("Do you want me to find some primes? ");
  while ( yesorno() == YES )
  {
    printf("Enter range: ");
    if (scanf("%li %li", &start, &finish) != 2)
      break;        /* Quit loop - bad input */
    while ((c = getchar()) != '\n')
      ;             /* Skip to end of number line */
    if (start <= finish)
    {
      printf("Do you want me to print them in ascending order? ");
      if ((answer = yesorno()) == EOF)
        break;      /* Quit on EOF */
      if (answer == YES)
        printAscending(start, finish);
      else
        printDescending(finish, start);
    }
    else
    {
      printf("Do you want me to print them in descending order? ");
      if ((answer = yesorno()) == EOF)
        break;      /* Quit on EOF */
      if (answer == YES)
        printDescending(start, finish);
      else
        printAscending(finish, start);
    }
    printf("Do you want me to find some more primes? ");
  }
  return 0;
}

/*
 * Print primes between start and finish in ascending order.
 */
void printAscending(int start, int finish)
{
  int prime(long x);
  int i;
  int count;

  count = 0;
  for (i = start; i <= finish; i++)     /* Ascending order */
    if (prime(i))
    {
      printf("%li\n", i);
      count++;
    }
  if (count == 0)
     printf("There are no primes between %li and %li.\n", start, finish);
}
  
/*
 * Print primes between start and finish in descending order.
 */
void printDescending(int start, int finish)
{
  int prime(long x);
  int i;
  int count;

  count = 0;
  for (i = start; i >= finish; i--)
    if (prime(i))
    {
      printf("%li\n", i);
      count++;
    }
  if (count == 0)
     printf("There are no primes between %li and %li.\n", start, finish);
}

/*
 * Determine if X is prime.
 */
int prime(long x)
{
  int i;

  if (x >= 0 && x <= 2)          /* 0, 1 and 2 are prime */
    return YES;
  if (x % 2 == 0)                /* even numbers aren't */
    return NO;
  for (i = 3; i <= sqrt(x); i+= 2)    /* otherwise try dividing */
    if (x % i == 0)
      return NO;
  return YES;
}

/*
 * Get a yes or no answer (from class).
 */
int yesorno()
{
  int c;
  int answer;

  c = getchar();
  while (c == ' ')
    c = getchar();
  answer = (c == EOF) ? EOF : (c == 'y') ? YES : NO;
  while (c != '\n')
    c = getchar();
  return answer;
}
