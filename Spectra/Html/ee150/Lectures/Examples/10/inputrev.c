/*
 * Reverse input.
 */

#define ELEMENTS 100

main()
{
  int fill_array(int a[], int n);
  void print_array_backwards(int a[], int n);

  int table[ELEMENTS];
  int n;
  
  n = fill_array(table, ELEMENTS);
  print_array_backwards(table, n);
  return 0;
}
