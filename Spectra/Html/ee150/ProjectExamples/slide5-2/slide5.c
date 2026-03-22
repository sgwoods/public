/*Main program for slide 5*/
/*Group 1                 */

#include<stdio.h>
#include"slide5.h" 

main()
{
  char dropout;           /*color of chip which slide out*/
  int whoplay;            /*current player 0 for player1 1 for player2*/
  int move;               /*a number represent move by players (1-10)*/
  int chips[2];           /*how many chips each player holds*/
                          /*chips[0] for player1, chips[1] for player2*/
  char color;             /*current color*/
  char board[5][5];       /*slide5 gameboard*/
  char players[2][17];    /*players' name and color they choose*/
  int  winner;            /*0 for player1, 1 for player2, 2 for tie*/ 
  int over;               /*check whether game is over*/

  while(menu())
    {
      setup(players,board,chips);             /*initialize the game board*/
      whoplay=(players[1][16]==(color='B'));  /*who choose 'B'  play first*/ 
      over=0,move=0;                                 
      while(move!=-1 && over==0)
      {
	displayBoard(players,board,chips,whoplay);
	winner=game_over(board,players);
        if (winner!=3) 	  over=1;
	else if ((move=get_move())>=0)
	      {
		dropout=do_move(move,board,color);
		if (dropout!='0') chips[(dropout==players[1][16])]++;
		color=chipcolor(color,whoplay,players,chips);
		whoplay=switch_player(whoplay);
	      }
      }
   if(over) displayWinner(players,winner);
    }
  displayEnd();
 return 0;
}
















































