/* This function read in players name and current player then*/
/* check whether he is using his own color or not            */
/* subtract one chip from whose chip it belongs to           */
/* check whether the new player is running out over of chip  */
/* if it is ture , use opponent chip color.                  */
    
#include<stdio.h>

char chipcolor(char color, int whoplay,char players[2][17], int chips[2])
{
  int switch_player(int);
  int opponent;
  
  opponent=switch_player(whoplay);
  if(color==players[whoplay][16])
    chips[whoplay]--;
  else
    chips[opponent]--;

  if (chips[opponent]==0)
    return players[whoplay][16];
  else
    return players[opponent][16];
}

