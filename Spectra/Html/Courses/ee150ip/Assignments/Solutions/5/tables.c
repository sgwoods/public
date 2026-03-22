/*
 * Useful Helper Functions for Problem #5.
 */
#include <stdio.h>
#include "tables.h"

/*
 * Read "n" input values and store them in positions 0 through n-1 of
 * the "values" array.
 *
 * If it hits EOF when trying to read the first value, it returns -1.
 * Otherwise, it returns the number of values it successfully read.
 * This value is equal to "n" if no errors occurred.
 * 
 */
int readValues(int values[], int n)
{
  int count;            /* number of values read */
  int value;            /* next input value */
  int r;                /* scanf return value */

  for (count = 0; count < n && (r = scanf("%i", &value)) == 1; count++)
    values[count] = value;

  /* Return -1 on EOF when trying to read the first value.  Otherwise,
     return the count of values successfully read. */

  return (r == -1 && count == 0) ? -1 : count;
}


/*
 * Return the sum of the first n values in the provided array.
 * 
 */
long sumValues(int values[], int n)
{
  long sum = 0;
  int i;

  for (i = 0; i < n; i++)
    sum += values[i];
  return sum;
}

/*
 * Set each item in the array to a particular value.
 * 
 */
void assignValues(int values[], int n, int value)
{
  int i;

  for (i = 0; i < n; i++)
    values[i] = value;
}

/*
 * Print the first "n" values in an array of integers, one per line.
 *
 * [This function is useful for debugging; in particular, to ensure
 *  that any array you read in or processed looks the way you expected
 *  it to.]
 */
void printValues(int values[], int n)
{
  int i;                /* array index */

  for (i = 0; i < n; i++)
    printf("%i\n", values[i]);
}

/*
 * Insert an element in the correct spot in a table of doubles (assuming
 * we want the table in ascending order).   The first parameter is the
 * array into which you want to insert a double.  The second parameter
 * is the number of values that have so far been inserted into the array.
 * And the last parameter is the value you wish to insert.
 */
void insertDoubleValue(double values[], int n, double value)
{
  int pos;                /* array index */

  for (pos = n; pos > 0 && value < values[pos - 1]; pos--)
    values[pos] = values[pos - 1];
  values[pos] = value;
}

/*
 * Read a line of input into a character string.
 */
int getline(char line[], int max)
{
  int c;
  int i = 0;

  while ((c = getchar()) != '\n' && c != EOF)
    if (i < max)
      line[i++] = c;
  line[i] = '\0';
  return (c == EOF) ? -1 : i;
}
