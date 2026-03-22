/*These are the functions menu, rules, rule2, setup, and switch.*/

#include <stdio.h>

/*menu returns a 1 if it is a new game, a 0 if the user wants to quit*/

int menu(void)
{
 char c;                        /*character read from user*/
 int instruct;                  /*this is to see if we need show the 2nd*/
 int numread;	                /*This is to keep reading until a Q or N*/
 int loop_again;                /*to see if menu needs to keep running*/
 void rule( void );		/*function prototype to display rules*/ 
 void rule2( void );            /*displays second half of rules*/
	
 loop_again = 1;
 while (loop_again = 1)
 {
  printf("\n\n\n\t\t\t     W E L C O M E  T O \n");
  printf("\t\t  xx     x     x    xx     xxxx       xxxx\n");
  printf("\t\t x  x    x     x    x x    x          x   \n");
  printf("\t\t x       x     x    x  x   xxx        xxxx\n");
  printf("\t\t  xx     x     x    x   x  x             x\n");
  printf("\t\t    x    x     x    x   x  x             x\n");
  printf("\t\t x  x    x     x    x  x   x             x\n");
  printf("\t\t  xx     xxx   x    xxx    xxxx       xxxx\n\n\n\n\n");  
 
  printf("\n\t\t          G A M E  O P T I O N S\n\n\n\n");
  printf("\t   Q - quit     N - new game    R - rules/instructions\n\n\n\n");
  printf(" Please enter your choice(Q,N,R): ");
  numread = 0; 
  while (numread == 0)  
  { 
   scanf("%c", &c);
    if ((c == 'Q') || (c == 'q'))	/*returns a 0 to quit main program*/
    {
     loop_again = 0;  
     numread = 1;
     return 0;
    }
    if ((c == 'N') || (c == 'n'))	/*returns a 1 to main for a new game*/
    {
     loop_again = 0;
     numread = 1;
     return 1;
    }
    if ((c == 'R') || (c == 'r'))
    {
     numread = 0;
     loop_again = 1;
     instruct = 1;
     rule();        		/*function call to display rules*/
     printf(" PLEASE ENTER YOUR COMMAND(F,M): ");
    }
    if (instruct == 1) 			/*ensures that "rule2" isnt dis- */
    {                                   /*played until "rule" is displayed*/
     if ((c == 'F') || (c == 'f'))
     {
      rule2(); 	  		/*displays 2nd rule page*/
      printf(" PLEASE ENTER YOUR COMMAND(R,M): ");
      loop_again = 1;
     }
     if ((c == 'M') || (c == 'm'))	/*return to the welcoming display*/	
     {
      loop_again = 1;
      numread = 1;
      instruct = 0;
     }
   }
  }
 }
} 

/*this function prints out the first page of the rules. it returns nothing.*/

void rule( void )
{
 printf("\t\t\tH O W  T O  P L A Y  S L I D E  5\n\n");
 printf("1. This game is for two players.(Ages 9 and up)\n\n"
        "2. Each player chooses a color. BLACK or WHITE.\n\n"
        "3. BLACK moves first. Both players begin with 16 chips.\n\n"
        "4. The first player to move, slips a chip into any of the 5\n"
        "   slots along either side of the top of the game board.\n\n"
        "5. Players take turns inserting chips of their color one at\n"
        "   a time, either to advance a row of their color, or to   \n"
        "   block an opponents chip. The first player to get 5 of   \n"
        "   their colored chips in a row, either vertically,        \n"
        "   horizontally, or diagonally, wins the game.           \n\n"
        "6. The strategy of the game is to block your opponent from \n"
        "   getting 5 in a row while at the same time placing your  \n"
        "   chips so you get 5 in a row.                          \n\n"
        "OPTIONS:   F - foward to next page of rules                \n"
        "           M - return to main menu/game in progress        \n"); 
 }

/*This function prints out the second page of the rules*/

void rule2( void )
{       
 printf("\n\n\n7. Slide 5!...When a row is filled up with 5 chips, any\n" 
        "   chip put in will cause the bottom chip to roll out of   \n"
        "   the bottom. But be cautioned!! be sure to look at what  \n"
        "   the result will be when all the chips move.You may lose.\n\n" 
        "8. A PLAYER CAN RUN OUT OF CHIPS!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n"
        "   A chip which is forced out the bottom during a 'slide'5   \n"
        "   may be reused by it's owner. If a player runs out of chips\n"
        "   a PENALTY results.  The player without chips must continue\n"
        "   to play USING THE OPPONENTS CHIPS until a chip of the     \n"
        "   proper color becomes available.                         \n\n"
        "9. Play continues until one player gets five chips of his-her\n"
        "   color in a diagonal, vertical or horizontal line. When    \n"
        "   this happens the game is over.                        \n\n\n" 
        "     G O O D  L U C K ! ! ! ! ! ! ! ! ! ! ! ! ! !      \n\n\n\n"
        "OPTIONS:   M - return to main menu/game in progress          \n"
        "           R - go back to first page of rules                \n");

}

