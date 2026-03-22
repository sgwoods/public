/* This function takes in the board and the player array (for the colors)
and returns the game status, whether player 1 or player 2 won, it s a
tie, or not over yet*/

#include <stdio.h>

/*These made life easier when doing the checks (imagine typing these in
the 50 odd times they were needed)*/


#define s1	board[0][0]
#define s2      board[0][1]
#define s3      board[0][2]
#define s4      board[0][3]
#define s5      board[0][4]
#define s6      board[1][0]
#define s7      board[1][1]
#define s8      board[1][2]
#define s9      board[1][3]
#define s10     board[1][4]
#define s11     board[2][0]
#define s12     board[2][1]
#define s13     board[2][2]
#define s14     board[2][3]
#define s15     board[2][4]
#define s16     board[3][0]
#define s17     board[3][1]
#define s18     board[3][2]
#define s19     board[3][3]
#define s20     board[3][4]
#define s21     board[4][0]
#define s22     board[4][1]
#define s23     board[4][2]
#define s24     board[4][3]
#define s25     board[4][4]

int game_over(char board[5][5], char players[2][17])
{
/*declare variables, the wins, the colors, and a worker position*/

	int p1win = 0,p2win=0;
	char p1color, p2color;
	int pos;

/*set the two player colors for the checks*/

	p1color = players[0][16];
	p2color = players[1][16];

/*the actual checks, for both a player 1 win and a player 2 win*/

	if(((s1==s2)&&(s2 == s3)&&(s3 == s4)&&(s4 == s5)&&(s1==p1color))||
	 ((s6== s7)&&(s7 == s8)&&(s8 == s9)&&(s9 == s10)&&(s6==p1color))||
	 ((s11==s12)&&(s12 == s13)&&(s13 ==s14)&&(s14==s15)&&(s11==p1color))|| 
	 ((s16==s17)&&(s17 == s18)&&(s18==s19)&&(s19 ==s20)&&(s16==p1color))||
	 ((s21==s22)&&(s22 == s23)&&(s23==s24)&&(s24==s25)&&(s21==p1color))||
	 ((s1 == s6)&&(s6 == s11)&&(s11 ==s16)&&(s16==s21)&&(s1==p1color))||
	 ((s2 == s7)&&(s7 == s12)&&(s12 ==s17)&&(s17==s22)&&(s2==p1color))||
	 ((s3 == s8)&&(s8 == s13)&&(s13 ==s18)&&(s18==s23)&&(s3==p1color))||
	 ((s4 == s9)&&(s9 == s14)&&(s14 ==s19)&&(s19==s24)&&(s4==p1color))||
	 ((s5 == s10)&&(s10 == s15)&&(s15==s20)&&(s20==s25)&&(s5==p1color))||
	 ((s1 == s7)&&(s7==s13)&&(s13==s19)&&(s19==s25)&&(s1==p1color))||
	 ((s21 == s17)&&(s17==s13)&&(s13==s9)&&(s9==s5)&&(s21==p1color)))
		p1win = 1; 	/* after all that, player 1 won*/

	if(((s1==s2)&&(s2 == s3)&&(s3 == s4)&&(s4 == s5)&&(s1==p2color))||
	 ((s6== s7)&&(s7 == s8)&&(s8 == s9)&&(s9 == s10)&&(s6==p2color))||
	 ((s11==s12)&&(s12 == s13)&&(s13 ==s14)&&(s14==s15)&&(s11==p2color))|| 
	 ((s16==s17)&&(s17 == s18)&&(s18==s19)&&(s19 ==s20)&&(s16==p2color))||
	 ((s21==s22)&&(s22 == s23)&&(s23==s24)&&(s24==s25)&&(s21==p2color))||
	 ((s1 == s6)&&(s6 == s11)&&(s11 ==s16)&&(s16==s21)&&(s1==p2color))||
	 ((s2 == s7)&&(s7 == s12)&&(s12 ==s17)&&(s17==s22)&&(s2==p2color))||
	 ((s3 == s8)&&(s8 == s13)&&(s13 ==s18)&&(s18==s23)&&(s3==p2color))||
	 ((s4 == s9)&&(s9 == s14)&&(s14 ==s19)&&(s19==s24)&&(s4==p2color))||
	 ((s5 == s10)&&(s10 == s15)&&(s15==s20)&&(s20==s25)&&(s5==p2color))||
	 ((s1 == s7)&&(s7==s13)&&(s13==s19)&&(s19==s25)&&(s1==p2color))||
	 ((s21 == s17)&&(s17==s13)&&(s13==s9)&&(s9==s5)&&(s21==p2color)))
		p2win = 1; 	/* after all that, player 2 won*/

	if(p1win && p2win)
	  return 2; 		/*tis a TIE!!*/
	else if	(p1win)
	    return 0;		/*tis PLAYER 1'S day*/
	else if(p2win) 
	    return 1;		/*tis PLAYER 2'S day*/
	else
	    return 3;		/*game no over yet*/
	
}
	  
