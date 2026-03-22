/*
 * The insertion function itself.
 */
void table_insert(int a[], int num, int value)
{
  int i;

  for (i = num; i > 0 && value < a[i - 1]; i--)
     a[i] = a[i - 1];
  a[i] = value;
}
