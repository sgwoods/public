/*
 * Useful helper functions.
 *   long getNumInBase(int base, char follower);
 *   void putNumInBase(long value, int base);
 */
#include <stdio.h>
#include <ctype.h>
#include <math.h>

/*
 * Read a positive number from the input.
 * 
 * Parameters:
 *    "base" is the base we expect the number to be in. 
 *    "expect" is the character we expect to follow the number.
 *
 * Returns: 
 *    the number's in base 10 
 *           OR
 *    -1 if there's an error (as in wrong digit, garbage, EOF, etc...).
 *    -2 if the number is missing.
 *    -3 if the number is followed by a newline, 
 *           but we expected something else.
 *    -4 if the number is followed by something we don't expect.
 */
long getNumInBase(int base, char follow)
{
  int toDecimal(int c, int b);
  int getNonBlank();

  int  c;                          /* next input character */
  int  value;                      /* decimal value of next char */
  long sum;                        /* running total */

  if ((c = getNonBlank()) == EOF)      /* EOF is error */
    sum = -1;
  else if (c == '\n')                
    sum = -2;                          /* hit CR, so number is missing */
  else               
  {
    if ((value = toDecimal(c, base)) == -1)
      sum = -1;                  /* got non-digit, so number is in error */
    else
    {                            
      /*
       * read and convert the number
       */
      sum = 0;
      while (value != -1)
      {                           /* valid next digit in base */
        sum = base * sum + value; /* update number */
        value = toDecimal(c = getchar(), base);
      }
      /*
       * verify number is followed by what it should be.
       */
      if (c != follow)             
      {
        if (c == '\n')
          sum = -3;       /* followed by \n, but not supposed to */
        else
          sum = -4;       /* followed by something strange */
      }
    }
    /*
     * If there's any kind of error, skip to the end of the line.
     */
    if (sum < 0)
    {
      while (c != '\n')            
        c = getchar(); 
    }
  }
  return sum;
}

void putNumInBase(long value, int base)
{
  int toDecimal(int c, int b);
  int toChar(int value);           

  int  k;                          /* digits needed in result */
  long divisor;                    /* initially b^(# of digits - 1) */

  if (value == 0)                  /* zero is the same in any base */
    printf("0");
  else
  {
    k = floor(log10(value)/log10(base)) + 1;

    /* Run through value, calculating and displaying the value of each
       of the digits in the new base (left to right) */

    for (divisor = pow(base, k - 1); divisor >= 1; divisor /= base)
    {
      putchar(toChar((int)(value / divisor))); 
      value %= divisor;
    }
  }
}

/*
 * Read and return the next non-blank on the current line (or the first
 * non-blank if it is called before any characters).
 */
int getNonBlank()
{
  int c;

  if ((c = getchar()) == EOF)           
    return -1;
  while (c == ' ')
    c = getchar();
  return c;
}

/*
 *  Return the value of the given character as a decimal digit.  The
 *  character is expected to be a value in the given base.
 */
int toDecimal(int c, int base)
{
  int value;

  if (!isdigit(c))
    value = -1;                         /* non-digit */
  else if ((value = c - '0') >= base)
    value = -1;                         /* out of range value */
  return value;
}

int toChar(int value)
{
  return value + '0';
}

