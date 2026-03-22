/*
 * Print the histogram.
 */
#include <stdio.h>

#define MAXMARKS  25                  /* maximum marks per bucket */
#define MARKER    '*'                 /* marker for values */

void print_histogram(unsigned long buckets[],
                     int bucketsize, int numbuckets,
                     int minval, int maxval)
{
  int           min(int x, int y);
  int           max(int x, int y);
  void          put_n_chars(char c, int n);
  unsigned long table_max(unsigned long a[], int n);
  int           b;                   /* bucket index */
  int           bmin;                /* smallest value in a bucket */
  int           bmax;                /* largest value in a bucket */
  double        scale;               /* scaling factor */
  int           marks;               /* # of marks to write on line */
  unsigned long most;                /* # of marks in largest bucket */

  most = table_max(buckets, numbuckets); 
  scale = (most > MAXMARKS) ? (double) MAXMARKS / most : 1.0;
  for (b = 0, bmin = minval; b < numbuckets; b++, bmin = bmax + 1)
  {                                       /* print each row to scale */
    bmax = min(bmin + bucketsize - 1, maxval);
    marks = (buckets[b] > 0) ? max(buckets[b] * scale, 1) : 0;
    printf("%3i-%3i |", bmin, bmax);      /* write label */
    put_n_chars(MARKER, marks);           /* write markers */
    put_n_chars(' ', MAXMARKS - marks);   /* write spaces */
    if (buckets[b])                       /* write count */ 
      printf(" (%lu)", buckets[b]);
    putchar('\n');  
  }
}

unsigned long table_max(unsigned long a[], int n)
{
  int           i;
  unsigned long largest;                   /* largest count */

  for (largest = 0, i = 0; i < n; i++)
    if (a[i] > largest)
      largest = a[i];
  return largest;
}
