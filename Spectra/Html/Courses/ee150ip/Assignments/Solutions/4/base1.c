/*
 * Solution to program #4, part #1
 *
 */
#include <stdio.h>
#include <stdlib.h>

#define INPUT_BASE 2
#define OUTPUT_BASE 2

int main()
{
  void displayResults(char op, long op1, long op2, long answer);
  long getNumInBase(int base, int flag);
  int getNonBlank();

  char op;
  long value1;
  long value2;
  long result;

  while ((op = getNonBlank()) != -1)
  {
    value1 = getNumInBase(INPUT_BASE, ' ');
    value2 = getNumInBase(INPUT_BASE, '\n');
    switch (op)
    {
      case '+': result = value1 + value2;
                break;
      case '-': result = value1 - value2;
                break;
      case '*': result = value1 * value2;
                break;
      case '/': result = value1 / value2;
                break;
      default:  result = 0;
                break;
    }
    displayResults(op, value1, value2, result);
  }
  return 0;
}

/*
 * Take care of writing the answer in the form:
 *
 *     x (decimal) + x (decimal) = x (decimal) 
 */
void displayResults(char op, long op1, long op2, long answer)
{
  void printValue(long value);

  printValue(op1);
  printf(" %c ", op);
  printValue(op2);
  printf(" = ");
  printValue(answer);
  putchar('\n');
}

/*
 * Take care of actually writing the binary number, followed 
 * by its decimal value.
 */
void printValue(long value)
{
  void putNumInBase(long value, int base);

  int sign;

  sign = (value < 0) ? -1 : 1;
  if (sign == -1)
    putchar('-');
  putNumInBase(labs(value), OUTPUT_BASE);
  printf(" (%li)", value);
}
