/*Take player's chip color and move , change the gameboard array*/


#include<stdio.h>

char do_move(int move,char board[5][5],char newchip)
{
  char c,dropout;
  int i,j;
  int findEmpty;

  dropout='0';

  if(move<=5) 
    {
      findEmpty=0;
      i=0;
      move--;
      while(i<5 && findEmpty==0)
	{
	  if (board[i][move]==' ')   findEmpty=1;
	  i++;
	}
  
      if (i==5)
	dropout=board[4][move];

      for(j=i-1;j>0;j--)
	board[j][move]=board[j-1][move];

      board[0][move]=newchip;
    }
  else
    {
      findEmpty=0;
      j=4;
      move=move-6;
      while(j>=0 && findEmpty==0)
	{
	  if(board[move][j]==' ') findEmpty=1;
	  j--;
	}
      if(j==-1)
	dropout=board[move][0];
      for(i=j+1;i<=3;i++)
	board[move][i]=board[move][i+1];
      board[move][4]=newchip;
    }


 return dropout;
}




