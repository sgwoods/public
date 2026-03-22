
#include <stdio.h>

/*This function displays the board and game status.  It is passed all the
variables it needs and there is no possible return.  The series of printf’s is
a must, as the game status displays change line to line.*/


void displayBoard(char players[2][17], char board[5][5], int chips[2], int
move)
{
/*prototype an extra function, one which prints a name from the given
array. It returns the index of the color variable, stored one cell after the
end marker, a -1.*/

   void printname(char players[2][17], int who);


/* The body of the function, consisting of nothing more than a series of
printfs*/

   printf("\t\t\t5 x 6\t\t\tTo Move:");
   printname(players, move);
   printf("(%c)\n", players[move][16]);

   printf("\t\t\t / \\\t\t\tChips Remaining:\n");

   printf("\t\t      4 x %c x 7\t\t\t", board[0][4]);
   printname(players, 0);
   printf("(%c): %i\n", players[0][16], chips[0]);

   printf("\t\t       / \\ / \\\t\t\t");
   printname(players, 1);
   printf("(%c): %i\n", players[1][16], chips[1]);

   printf("\t\t    3 x %c . %c x 8\t\t\t\n", board[0][3], board[1][4]);
   printf("\t\t     / \\ / \\ / \\\t\tCommands:\n");
   printf("\t\t  2 x %c . %c . %c x 9\t\tH: Help\n", board[0][2], board[1][3],
board[2][4]);
   printf("\t\t   / \\ / \\ / \\ / \\\t\tR: Rules\n");
   printf("\t\t1 x %c . %c . %c . %c x 10\t\tQ: Quit\n", board[0][1],
board[1][2], board[2][3], board[3][4]);
   printf("\t\t / \\ / \\ / \\ / \\ / \\\t\t#: Move\n");
   printf("\t\tx %c . %c . %c . %c . %c x\n", board [0][0], board[1][1],
board[2][2], board[3][3], board [4][4]);
   printf("\t\t \\ / \\ / \\ / \\ / \\ /\n");
   printf("\t\t  x %c . %c . %c . %c  x\n", board[1][0], board[2][1],
board[3][2], board[4][3]);
   printf("\t\t   \\ / \\ / \\ / \\ /\n");
   printf("\t\t    x %c . %c . %c x\n", board[2][0], board[3][1], board[4][2]);
   printf("\t\t     \\ / \\ / \\ /\n");
   printf("\t\t      x %c . %c x\n", board[3][0], board[4][1]);
   printf("\t\t       \\ / \\ /\n");
   printf("\t\t        x %c x\n", board[4][0]);
   printf("\t\t         \\ /\n");
   printf("\t\t          X\n\n\n");

   printf(" What would you like to do(H, Q, R, or #)? ");
}



/* This function takes in the player name array and prints out a winner's
congratulations to the player who won.*/


void displayWinner(char players[2][17], int winner)
{

	void printname(char players[2][17], int who);
	void pause(int);
	if((winner == 0) || (winner == 1))
	{
      
	  printf("\n\n\n\n\n\n\n\n\t\tC-*-O-*-N-*-G-*-R-*-A-*-T");
	  printf("-*-U-*-L-*-A-*-T-*-I-*-O-*-N-*-S\n\n\t\t***   ");
	  printname(players, winner);
	  printf("   ***\n\t\tYOU WIN!!!!!\n\n");	
	  printf("\t\tUnfortunately, we seem to be out of prizes...\n");
	  printf("\t\tBetter luck next time, ");
	  printname(players, winner);
	  printf(", please try again!\n\n\n\n\n\n\n\n\n\n");
	}
	else
	{
	  printf("\n\n\n\n\nITS A TIE!!!!!!\n");
	  printf("How the heck did you people manage that one?\n");
	  printf("Please play again ");
	  printname(players, 0);
	  printf(" and ");
	  printname(players, 1);
	  printf(".\n");
	}
	getchar();
}



/*This function takes in the player name array and prints out one of the
two names, according to the "who" variable.*/


void printname(char players[2][17], int who)
{
   int pos;

   for (pos = 0;players[who][pos] != -1;pos++)
      printf("%c", players[who][pos]);

}


/*This function is prints out the ending credits for the program, complete
with pauses.*/


void displayEnd()
{

/*proto for a function which prints out a numbers of lines slowly, to give
the scrolling effect*/

	void pause(int length);

/*The rest of the credits*/
	
	printf("\n\n\n\n\n\n\n\n\n\n\n");
	printf("\t\tSlide-5 Programmed by...\n");
	printf("\t\tEE 150 Section 2\n\t\tGroup #1\n");
	printf("\t\tMembers:\n");
	printf("\t\t        Ryan Gonzalez\n");
	printf("\t\t        Mian Zhao\n");
	printf("\t\t        Christopher Cha\n");
	printf("\n\tSpecial thanks to whoever is grading this program,\n");
	printf("\tfor putting up with the dumb humor in these messages.\n");
	pause(10);
	
	printf("\t\tThank you for playing Slide-5!");
	pause(12);

}

/*The scrolling function, 'nuff said*/

void pause(int length)
{
        double count;
	unsigned long lines;

	for(lines = 0;lines <= length;lines++)
	{
	   for(count = 0;count < 500;count=count+0.001);
	   printf("\n");
	}

}

	
