/*
 * Echo the input, a character at a time.
 *
 * Because of buffering, the input:
 *   alex
 * will result in the output
 *   Read: a
 *   Read: l
 *   Read: e
 *   Read: x
 *   Read: 
 *
 * The last "Read" is due to the newline after the alex.
 */
#include <stdio.h>

main()
{
  char c;    /* next input character */

  while (scanf("%c", &c) == 1)
    printf("Read: %c\n", c);
  return 0;
}
