/*This function gets the names and colors from the players, initializes the *
 *board and chips  to begin a new game*/

#include <stdio.h>

void setup(char players[2][17], char board[5][5], int chips[2])
{
 char c;			/*character read from user*/
 char c1;			/*rubbish holder before getting names*/
 int i;			/*number of values in "players"*/
 int row;			/*row within board display*/
 int col;			/*column in board display*/
 chips[0] = 16;			/*initializes # of player 1 chips*/
 chips[1] = 16;			/*initializes # of player 2 chips*/
 
				/*clears the board*/
 for (row = 0; row < 5; row++)
 {
  for (col = 0; col < 5; col++)
   board[row][col] = ' ';
 }
				/*gets names from the players*/
 printf("\n1.Player ONE please enter your name(up to 15 characters): ");
 i = 0;
 c1 = getchar();

 while (((c = getchar()) != '\n') && (i < 15))
 {
  players[0][i] = c;
  i++;
 }

					/*gets name from player two*/
 players[0][i] = -1;


 i = 0;
 printf("2:Player TWO please enter your name(up to 15 characters): ");


 while (((c = getchar())!= '\n') && (i < 15))
 {
  players[1][i] = c;
  i++;
 }

					/*gets color from the playres*/
 players[1][i]=-1;
 printf("Player ONE please choose your color. black or white (B or W): ");

 while ((c = getchar()) != '\n')
 {
  if ((c == 'B') || (c == 'b'))
  {
   players[0][16] = 'B';
   players[1][16] = 'W';
  }
  else
  {
   players[0][16] = 'W';
   players[1][16] = 'B';
  }
 } 
}
