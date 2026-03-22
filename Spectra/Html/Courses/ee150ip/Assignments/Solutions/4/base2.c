/*
 * Solution to program #4, part #2.
 */
#include <stdio.h>
#include <stdlib.h>

#define INPUT_BASE 2
#define OUTPUT_BASE 2

#define TRUE 1
#define FALSE 0

int main()
{
  long getNumInBase(int base, int flag);
  int getNonBlank();
  void displayResults(char op, long op1, long op2, long answer);
  long getOperand1();
  long getOperand2();

  char op;
  long value1;
  long value2;
  long result;
  int display_result;

  while ((op = getNonBlank()) != -1)
  {
    value1 = getOperand1();
    if (value1 >= 0)
    {
      value2 = getOperand2();
      if (value2 >= 0)
      {
        display_result = TRUE;
        switch (op)
        {
          case '+': result = value1 + value2;
                    break;
          case '-': result = value1 - value2;
                    break;
          case '*': result = value1 * value2;
                    break;
          case '/': if (value2 == 0)
                    {
                      printf("Attempted division by zero.\n");
                      display_result = FALSE;
                    }
                    else
                      result = value1 / value2;
                    break;
          default:  display_result = FALSE;
                    printf("Bad operator: %c.\n", op);
                    break;
        }
        if (display_result == TRUE)
          displayResults(op, value1, value2, result);
      }
    }
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

/*
 * Handle reading the first operand and printing any errors.
 */
long getOperand1()
{
  long getNumInBase(int base, int flag);

  long value1;

  value1 = getNumInBase(INPUT_BASE, ' ');
  if (value1 < 0)
  {
    switch (value1)
    {
      case -1: printf("First operand is bad.\n");     
               break;
      case -2: printf("First operand is missing.\n"); 
               break;
      case -3: printf("Second operand is missing.\n"); 
               break;
      case -4: printf("First operand followed by garbage.\n");
               break;
    }
  }
  return value1;
}

/*
 * Handle reading the second operand and printing any errors.
 */
long getOperand2()
{
  long getNumInBase(int base, int flag);

  long value1;

  value1 = getNumInBase(INPUT_BASE, '\n');
  if (value1 < 0)
  {
    switch (value1)
    {
      case -1: printf("Second operand is bad.\n");     
               break;
      case -2: printf("Second operand is missing.\n");
               break;
      case -4: printf("Second operand followed by garbage.\n");
               break;
    }
  }
  return value1;
}
