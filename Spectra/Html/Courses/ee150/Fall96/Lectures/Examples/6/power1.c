/*
 * A power function that works for positive exponents.
 */
double power(double x, int y)
{
  int i;          /* counter for number of multiplies */
  double result;  /* holds the final answer */

  result = 1;
  for (i = 1; i <= y; i = i + 1)
    result = result * x;
  return result;
}
