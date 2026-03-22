/*
 * Print a prompt and then get a yes or no answer using "yesorno".
 */
#include <stdio.h>
#include <ctype.h>

#define YES 1
#define NO  0

int main()
{
  int yesorno(void);
     
  printf("Enter a YES or NO answer: ");
  if (yesorno() == YES)
    printf("That was a YES!\n");
  else
    printf("That was a NO!\n");
  return 0;
}

int yesorno(void)                  
{ 
  int c;                           /* holds input character */
  int answer;                      /* holds YES or NO answer */

  c = getchar();
  if (tolower(c) == 'y')
    answer = YES;                  /* YES for 'Y' or 'y' */
  else
    answer = NO;                   /* NO for anything else */
  if (c != EOF)                
    while (c != '\n')              /* skip other characters on line */
      c = getchar(); 
  return answer;        
}
