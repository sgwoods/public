/* Group 4 assignment #6 */

#include<stdio.h>
#include<ctype.h>
#define P1	  35		/* player1 value in array */
#define P2	  79		/* player2 value in array */
#define EMPTY	  32		/* empty value in array */

main()
{
  int Do_Move(int col_number, int chip, int pieces[]);
  int chip;   			/* chip to be played with */
  int chipreturn;               /* chip lost through slide */
  int thinking;                 /* garbage variable to stall game so
				   that player has time to see board
				   after his move and before computer
				   goes */
  int a;                        /* counter */
  int gamemode;                 /* mode 1 vs. computer, mode2 player1
				   vs. player 2 */
  int player;			/* player who will move next */
  int move;			/* move player chooses */
  char cont='Y';                /* variable to continue game */
  char win;                     /* variable to tell if player won */
  void Draw_Board(int pieces[], int player1_chips, int player2_chips);
  int winner(int pieces[], char win);
  int get_move(int player, int pieces[], int gamemode,
      int player1_chips, int player2_chips);


  while(cont=='Y')        	/* this loops until player chooses not
				   to continue */
  {                		/* this sets board to be blank */
  int pieces[25] = {EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,
     EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,
     EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY};


  int player1_chips = 16;       /* holds player1's chips */
  int player2_chips = 16;       /* holds player2's chips */
  win='n';
  player = 1;                   /* player 1 always starts first */
  move = 0;                     /* initializes move */
				/* this part prints welcome screen */
  printf("\n\n\n\n\n\n\n\n\n\n\n		|");
  for(a=0;a<26;a++)
    printf("%c", 45);
  printf("|\n		|");
  for(a=0;a<9;a++)
    printf("%c", 61);
  printf("SLIDE 5!");
  for(a=0;a<9;a++)
    printf("%c", 61);
  printf("|\n		|");
  for(a=0;a<26;a++)
    printf("%c", 45);
  printf("|\n		|");
  printf("                          |\n   		|");
  printf("        Options           |\n		|");
  printf("  1. Player1 vs. Computer |\n		|");
  printf("  2. Player1 vs. Player2  |\n		|");
  printf("                          |\n		|");
  for(a=0;a<26;a++)
    printf("%c", 95);
  printf("|\n\n\n\n\n\n\n\n\n");
  printf("Enter Option: ");
  scanf(" %i", &gamemode);  	/* gets gamemode to setup game */
  while((gamemode<1)||(gamemode>2))
  {
    printf("Invalid Option.  Reenter Option: ");
    scanf(" %i", &gamemode);
  }
  Draw_Board(pieces, player1_chips, player2_chips);
  while((win=='n')&&(move!='q'))
    {
      if((gamemode==1)&&(player==2))
      {
	printf("Computer thinking...Press enter to continue: ");
	thinking = getchar();   /* this pauses so player1 can see his move */
	if (move==10)  		/* special case when move is 10 */
	  thinking = getchar();
	while(thinking!='\n')
	  thinking = getchar();
      }
      move=get_move(player, pieces, gamemode, player1_chips,
		    player2_chips);
      if (player==1)            /* this subtracts the used chip */
      {
	if (player1_chips==0)   /* if player1 has no chips player2 used */
	{
	  player2_chips -= 1;
	  chip = P2;             /* chip used is now player 2 */
	}
	else
	{
	  player1_chips -= 1;
	  chip = P1;
	}
      }
      else
      {
	if (player2_chips==0)  	/* if player2 has no chips player1 used */
	{
	  player1_chips -= 1;
	  chip = P1;             /* uses player1 chips */
	}
	else
	{
	  player2_chips -= 1;
	  chip = P2;
	}
      }
				/* Do_Move returns a chip that slid out */
      chipreturn = Do_Move(move,chip,pieces);
      if (chipreturn==P1)
	player1_chips = player1_chips + 1;
      else if (chipreturn==P2)
       player2_chips = player2_chips + 1;
      Draw_Board(pieces, player1_chips, player2_chips);
      win = winner(pieces, win);
      if (player==1)            /* this switches players after move */
	player=2;
      else
        player=1;
      if (move=='q')
	printf("The game has ended.\n");
    }
    if (win==1)                 /* this section prints results */
      printf("Player 1 won!\n");
    if (win==2)
      printf("Player 2 won!\n");
    if (win=='t')
      printf("The game ends in a tie!\n");
    printf("Another game (Y or N)? ");
    scanf(" %c", &cont);
  }
return 0;
}


/* this function draws board and information menu */
void Draw_Board(int pieces[], int player1_chips, int player2_chips)
{
				/* these represents chip values with
				   their array index on them */
int ch0,ch1,ch2,ch3,ch4,ch5,ch6,ch7,ch8,ch9,ch10,ch11,ch12,ch13,ch14,ch15;
int ch16,ch17,ch18,ch19,ch20,ch21,ch22,ch23,ch24;
				/* these print characters for table */
int a;                          /* counter */

ch0=pieces[0];ch1=pieces[1];ch2=pieces[2];ch3=pieces[3];ch4=pieces[4];
ch5=pieces[5];ch6=pieces[6];ch7=pieces[7];ch8=pieces[8];ch9=pieces[9];
ch10=pieces[10];ch11=pieces[11];ch12=pieces[12];
ch13=pieces[13];ch14=pieces[14];ch15=pieces[15];
ch16=pieces[16];ch17=pieces[17];ch18=pieces[18];
ch19=pieces[19];ch20=pieces[20];ch21=pieces[21];
ch22=pieces[22];ch23=pieces[23];ch24=pieces[24];

printf("\n              #5  X  #6\n");
printf("                 /%c\\   \n", ch20);
printf("            #4  /%c%c%c\\  #7             ", ch20, ch20, ch20);
printf("|");
for(a=0;a<26;a++)
  printf("%c", 45);
printf("|\n");
printf("               /%c\\%c/%c\\                |",
  ch15, ch20, ch21);
for(a=0;a<9;a++)
  printf("%c", 61);
printf("SLIDE 5!");
for(a=0;a<9;a++)
  printf("%c", 61);
printf("|\n");
printf("          #3  /%c%c%cX%c%c%c\\  #8           |",
  ch15, ch15, ch15, ch21,ch21,ch21);
for(a=0;a<26;a++)
  printf("%c", 45);
printf("|\n");
printf("             /%c\\%c/%c\\%c/%c\\              |",
  ch10,ch15,ch16,ch21,ch22);
printf("     Menu      |  Chips   |\n");
printf("        #2  /%c%c%cX%c%c%cX%c%c%c\\  #9         |",
  ch10,ch10,ch10,ch16,ch16,ch16,ch22,ch22,ch22);
for(a=0;a<26;a++)
  printf("%c", 45);
printf("|\n");
printf("           /%c\\%c/%c\\%c/%c\\%c/%c\\            |",
  ch5,ch10,ch11,ch16,ch17,ch22,ch23);
printf("  H Help       | Player1  |\n");
printf("      #1  /%c%c%cX%c%c%cX%c%c%cX%c%c%c\\  #10      |",
  ch5,ch5,ch5,ch11,ch11,ch11,ch17,ch17,ch17,ch23,ch23,ch23);
printf("  R Rules      |   %2i     |\n", player1_chips);
printf("         /%c\\%c/%c\\%c/%c\\%c/%c\\%c/%c\\          |",
  ch0,ch5,ch6,ch11,ch12,ch17,ch18,ch23,ch24);
printf("  Q Quit       | Player2  |\n");
printf("        X%c%c%cX%c%c%cX%c%c%cX%c%c%cX%c%c%cX	      |",
  ch0,ch0,ch0,ch6,ch6,ch6,ch12,ch12,ch12,ch18,ch18,ch18,ch24,
  ch24,ch24);
printf("  ( ) Column   |   %2i     |\n", player2_chips);
printf("         \\%c/%c\\%c/%c\\%c/%c\\%c/%c\\%c/	      |",
  ch0,ch1,ch6,ch7,ch12,ch13,ch18,ch19,ch24);
printf("      Number   |          |\n");
printf("          \\%c%c%cX%c%c%cX%c%c%cX%c%c%c/	      |",
  ch1,ch1,ch1,ch7,ch7,ch7,ch13,ch13,ch13,ch19,ch19,ch19);
for(a=0;a<26;a++)
  printf("%c", 95);
printf("|\n");
printf("           \\%c/%c\\%c/%c\\%c/%c\\%c/\n",
  ch1,ch2,ch7,ch8,ch13,ch14,ch19);
printf("            \\%c%c%cX%c%c%cX%c%c%c/\n",
  ch2,ch2,ch2,ch8,ch8,ch8,ch14,ch14,ch14);
printf("             \\%c/%c\\%c/%c\\%c/\n",
  ch2,ch3,ch8,ch9,ch14);
printf("              \\%c%c%cX%c%c%c/\n",
  ch3,ch3,ch3,ch9,ch9,ch9);
printf("               \\%c/%c\\%c/\n",
  ch3,ch4,ch9);
printf("                \\%c%c%c/\n",
  ch4,ch4,ch4);
printf("                 \\%c/\n",ch4);
printf("                  X\n\n");
}



/* this funtion is given the player's move from the get_move function
   and it performs the given move and returns the chip that is displaced
   by the act of sliding.  1 is returned for player1_chip that is
   displaced, 2 for player2_chip, 0 if nothing is displaced.  The funtion
   calls two other funtions, col_number1_5 and col_num6_10 to handle
   the actual move because of the fact that columns 1 to 5 affect the
   table differently than columns 6 to 10 */
int Do_Move(int col_number, int chip, int pieces[])
{
  int chipreturn;     		/* holds chip that is returned by slide */

  if (col_number>=1 && col_number<=5)
  {
    int Do_Move_Col1_5(int col_number, int chip, int pieces[]);

    chipreturn = Do_Move_Col1_5(col_number, chip, pieces);
  }
  else if (col_number>=6 && col_number<=10)
  {
    int Do_Move_Col6_10(int col_number, int chip, int pieces[]);

    chipreturn = Do_Move_Col6_10(col_number, chip, pieces);
  }
  return chipreturn;
}


/* this function only handles moves that involve columns 1 to 5.  This
   function detects whether a slide is necessary and if so, it only
   performs the slide for the correct positions.  this function
   returns the chip number that is ejected by the slide */
int Do_Move_Col1_5(int col_number, int chip, int pieces[])
{
  int position;   		/* position (index) in the array */
  int z;                        /* counter */
  int chipreturn = 0;
  int spots_filled = 0;
  char done = 'n';		/* this stops the counting */

  position = col_number * 5 - 5;
  for (z=0;z<=4;z++)    	/* this determines spots filled */
  {
    if (pieces[position+z]!=EMPTY)
    {
      if (done!='y')
	spots_filled = spots_filled + 1;
    }
    else
      done = 'y';
  }
  if (spots_filled==5)       	/* saves chipreturn at end of row if filled */
  {
    chipreturn = pieces[position+4];
    for (z=4;z>0;z--)           /* slides row down */
      pieces[position+z]=pieces[position+z-1];
  }
  else
  {
    for (;spots_filled!=0;spots_filled--)
				/* slides row down */
      pieces[position+spots_filled]=pieces[position+spots_filled-1];
  }
  pieces[position]=chip;
  return chipreturn;
}


/* this function only handles moves that involve columns 6 to 10.  This
   function detects whether a slide is necessary and if so, it only
   performs the slide for the correct positions.  this function
   returns the chip number that is ejected by the slide */
int Do_Move_Col6_10(int col_number, int chip, int pieces[])
{
  int position;
  int done;
  int z;
  int chipreturn = 0;
  int spots_filled = 0;

  position = col_number + 14;
  for (z=0;z<=4;z++)    	/* this determines spots filled */
  {
    if (pieces[position-5*z]!=EMPTY)
    {
      if (done!='y')
	spots_filled = spots_filled + 1;
    }
    else
      done = 'y';
  }
  if (spots_filled==5)       	/* saves chipreturn at end of row if filled */
  {
    chipreturn = pieces[position-20];
    for (z=4;z>=0;z--)          /* slides row down */
      pieces[position-5*z]=pieces[position-5*z+5];
  }
  else
  {
    for (;spots_filled!=0;spots_filled--)
    		                /* slides row down */
      pieces[position-5*spots_filled]=pieces[position-5*spots_filled+5];
  }
  pieces[position]=chip;
  return chipreturn;
}



/* this function has the task of handling all input in this game.  The
   user is give several options (help, rules, quit, and move) and
   this funtion does the appropriate thing */
int get_move(int player, int pieces[], int gamemode,
    int player1_chips, int player2_chips)
{
  void Draw_Board(int pieces[], int player1_chips, int player2_chips);
				/* the intelligence function is
				   the brains behind the computer player
				   which happens to be player 2.  When
				   computer mode is not selected,
				   this function serves to give help
				   to player 2 */
  int intelligence(int pieces[]);
				/* the yourintelligence function is
				   solely used for player 1 advice.
				   It is exactly opposite of intelligence
				   function */
  int yourintelligence(int pieces[]);
  char input;                  /* input from user */
  char temporary='t';          /* temporary handles the case if input
				  requires 2 digits like 10.  It is
				  disregarded for single entrys */
  int choice;                  /* choice is test of validity.  If
				  the input was totally wrong, choice
				  is n.  If input not a move choice
				  is y, etc. */
  int advice=0;

  choice = 'n';
  while ((choice=='n')||(choice=='y')||(choice=='l'))
  {
    choice='n';
				/* this if tests if computer is playing */
    if ((player==2)&&(gamemode==1))
    {
      input = intelligence(pieces);
      choice='d';     		/* this choice means move read and
				   funtion done */
    }
    else                        /* if computer not playing or player1's
				   turn */
    {
      printf("Enter move player%i: ", player);
      scanf(" %c", &input);
      scanf("%c", &temporary);  /* this code just accepts 10 as valid */
      if ((input=='1')&&(temporary=='0'))
	input='0';
      if (input=='H')           /* this is the Help funtion */
      {
				/* this suggests move for player2 */
	if ((gamemode==2)&&(player==2))
	  advice = intelligence(pieces);
				/* this suggests move for player1 */
	else
	  advice = yourintelligence(pieces);
	printf("The computer recommends #%i.\n", advice);
	choice = 'y';          /* choice y because not valid move */
      }
      if (input=='R')          /* this is the rules funtion */
      {
	choice='l';            /* choice l because must reprint board */
	printf("\n\n                       RULES\n");
	printf("                       %c%c%c%c%c\n",31,31,31,31,31);
	printf("\n\n1.  Each player chooses a color of playing piece.\n\n");
	printf("2.  Decide which player goes first.\n\n");
	printf("3.  The first player slips a chip into any one of the\n");
	printf("    5 slots along either side of the top of the game board.\n\n");
	printf("4.  The second player puts a chip in any one of the\n\n");
	printf("    slots.\n\n");
				/* this prints more of the rules if
				   user desires */
	printf("\n More or End (M or E)? ");
	scanf(" %c", &input);
      }
      if (input=='M')   	/* prints more if M */
      {
	choice='l'; 	        /* choice l because must reprint board */
	printf("\n5.  Players take turns inserting chips of their color\n");
	printf("    one at a time, either to advance a row of their,\n");
	printf("    color or to block an opponents chip.  The first\n");
	printf("    player to get 5 colored chips in a row, either,\n  ");
	printf("  vertically, horizontally, or diagonally, wins the game.\n");
	printf("    (Note a player may run out of chips, see rule  8.)\n\n");
	printf("6.  The strategy of the game is to block your opponent\n  ");
	printf("  from getting 5 in a row while at the same time placing\n");
	printf("    your chips so you get 5 in a row.\n\n");
	printf("\n    More or End (M or E)? ");
	scanf(" %c", &input);
      }
	if (input=='M')   	/* prints more if M */
      {
	choice='l';        	/* choice l because must reprint board */
	printf("7.  Slide 5!  .. When a row is filled up with 5 chips,\n  ");
	printf("  any chip put in will cause the bottom chip to roll out\n");
	printf("    the bottom.  This is called SLIDING 5!  Be very\n");
	printf("    careful before you slide 5, because the new\n");
	printf("    combinations that form may result in a win for your\n");
	printf("    opponent.  Look very carefully at what will result\n");
	printf("    when all the chips move.\n\n");
	printf("8.  A chip which is forced out the bottom during a\n");
	printf("    \"slide 5\" may be reused by its owner.  Sometimes,\n");
	printf("    however, a player may run out of chips to play.  When\n");
	printf("    this happens, a PENALTY results.  The player\n");
	printf("\n More or End (M or E)? ");
	scanf(" %c", &input);
      }
      if (input=='M')   	/* prints more if M */
      {
	choice='l';             /* choice l because must reprint board */
	printf("\n    without chips must continue to play USING THE\n");     
	printf("    OPPONENTS CHIPS until another chip of the proper \n");
	printf("    color becomes available.  When playing with your\n");
	printf("    opponents chip, to place that chip in a position\n");
	printf("    that will not set up a win for your opponent. Or\n");
	printf("    turn the tables by using your opponent chip to\n");
	printf("    \"slide 5\" in a way that will allow you to recover\n");
	printf("    one of your own chips. (Note, when a player has chips\n");
	printf("    of his/her color he/she MUST play these.)\n\n");
	printf("9.  Play continues until one player gets 5 chips of\n");
	printf("    his/her color in a diagonal, vertical or horizontal\n");
	printf("    line.  When this happens, the game is over.\n\n");
	printf("\n More or End (M or E)? ");
	scanf(" %c", &input);
      }
      if (input=='Q')		/* handles Quit funtion */
      {
	choice='d';
	input='q';
      }
				/* this converts input to 0 (col 10)
				   if 10 was entered */
      if ((temporary=='0')&&(input=='0'))
      {
	input = 0;
	choice='d';             /* choice d because valid move (done) */
      }
      else if (temporary!='\n')
	choice='n';             /* choice n because bad input */
      else if ((input<='9')&&(input>'0'))
      {
	input = input - '0';
	choice='d';             /* choice d because valid move (done) */
      }
    }
    if (choice=='n')
      printf("Invalid Move! "); /* prints error message for bad input */
    if (choice=='l')            /* redraws board if Rules were called */
      Draw_Board(pieces, player1_chips, player2_chips);
  }
  if (input==0)                 /* if 10 was entered temporary and input
				   was set to 0 so this converts it back to
				   10 */
    input = 10;
  return input;
}


/* this function determines if a player has won or tied and returns that
   information */
int winner(int pieces[], char win)
{
  int m,u; 			/* counters */
  char win1 ='n';
  char win2 ='n';         /* determines if player 1 or 2 won */

  for(m=0;m<=4;m++)             /* this checks for rows of 1 */
  {
    if ((pieces[m*5]==P1)&&(pieces[m*5+1]==P1)&&(pieces[m*5+2]==P1)&&
       (pieces[m*5+3]==P1)&&(pieces[m*5+4]==P1))
      win1 = 'y';
  }
  for(u=20;u<25;u++)            /* this checks for columns of 1 */
  {
    if ((pieces[u]==P1)&&(pieces[u-5]==P1)&&(pieces[u-10]==P1)&&
       (pieces[u-15]==P1)&&(pieces[u-20]==P1))
      win1 = 'y';
  }
  for(m=0;m<=4;m++)             /* this checks for rows of 2 */
  {
    if ((pieces[m*5]==P2)&&(pieces[m*5+1]==P2)&&(pieces[m*5+2]==P2)&&
       (pieces[m*5+3]==P2)&&(pieces[m*5+4]==P2))
      win2 = 'y';
  }
  for(u=20;u<25;u++)            /* this checks for columns of 2 */
  {
    if ((pieces[u]==P2)&&(pieces[u-5]==P2)&&(pieces[u-10]==P2)&&
       (pieces[u-15]==P2)&&(pieces[u-20]==P2))
      win2 = 'y';
  }
  				/* this section checks for diagonals */
  if((pieces[0]==P1)&&(pieces[6]==P1)&&(pieces[12]==P1)&&
    (pieces[18]==P1)&&(pieces[24]==P1))
    win1 = 'y';
  if((pieces[0]==P2)&&(pieces[6]==P2)&&(pieces[12]==P2)&&
    (pieces[18]==P2)&&(pieces[24]==P2))
    win2 = 'y';
  if((pieces[20]==P1)&&(pieces[16]==P1)&&(pieces[12]==P1)&&
    (pieces[8]==P1)&&(pieces[4]==P1))
    win1 = 'y';
  if((pieces[20]==P2)&&(pieces[16]==P2)&&(pieces[12]==P2)&&
    (pieces[8]==P2)&&(pieces[4]==P2))
    win2 = 'y';
  if ((win1=='y')&&(win2=='y')) /* this decides what to return */
    win = 't';    		/* since both won, tie */
  else if (win1=='y')
    win = 1;                    /* returns player1 win */
  else if (win2=='y')
    win = 2;                    /* returns player2 win */
  else
    win = 'n';
  return win;
}


/* the intelligence function is the brains behind the computer player
   which happens to be player 2.  When computer mode is not selected,
   this function serves to give help to player 2.  Note: this section
   is complicated because it must handle every posible winning
   combination and explanation of extremely condensed code will result
   in paragraphs of comments.  The comments before each for loop give
   a good overall function of the loop without going into details */
int intelligence(int pieces[])
{
  static int count = 0;     	/* static count helps provide "random" # */
				/* table holds "random" moves */
  int table[10] = {6,3,4,1,9,2,0,5,8,7};
  int val1,val2;                /* these hold occurance of a chip in row */
  int a,b;                      /* counters */
  int mark;                     /* mark holds position of odd chip,
				   if checking for 2's, holds odd 1 */
  int val,move;
  int must1=0;                  /* must1 is a move that will cause
				   the player to win, it is done
                                   first before must2 */
  int col_num=0;
  int must2=0;                  /* must2 is a move that will prevent
				   the opponent from winning */

  for(a=0;a<5;a++)      	/* this for loop checks every row for
				   posible winning combinations for the
                                   other player and offers move to block */
  {
    val1 = 0; val2 = 0; mark=0;
    for(b=0;b<5;b++)
    {         
      val = pieces[5*a+b];
      if(val==P1)
      {
	val1 += 1;
	if ((a==4)&&(val1==4))
	{
	   if (mark==0)
	     must2 = 7;         /* Note: as before must2 is defense */
	   else
	     must2 = 10;
	}
	else if ((val1==4)&&(pieces[5*a+4]!=P1))
	  must2 = a + 1;
	else if ((val1==4)&&(pieces[mark+5]==P1)&&(pieces[mark]!=EMPTY))
	  must2 = a + 1;
	else if ((val1==4)&&(pieces[mark+5]==P1)&&(pieces[mark]==EMPTY))
	  must2 = 10;
	else if ((val1==4)&&(pieces[mark]==EMPTY)&&((mark==0)||
		(mark==5)||(mark==10)||(mark==15)))
	  must2 = a + 1;
      }
      else
	mark = 5*a+b;
    }
  }
  for(a=0;a<5;a++)          	/* this for loop checks rows for posible
				   winning combinations and offers move
				   to win */
  {
    val1 = 0; val2 = 0; mark=0;
    for(b=0;b<5;b++)
    {
      val = pieces[5*a+b];
      if(val==P2)
      {
	val2 += 1;
	if ((a==4)&&(val2==4)&&(pieces[24]==P2))
	  must1 = mark-14;      /* as before must1 is offense */
	else if ((a==4)&&(val2==4))
	  must1 = 5;
	else if ((val2==4)&&(pieces[5*a+4]!=P2))
	  must1 = a + 1;
	else if ((val2==4)&&(pieces[mark]==EMPTY))
	  must1 = a + 1;
	else if ((val2==4)&&(pieces[mark+5]==P2))
	  must1 = mark - 5 * a + 6;
      }
      else
	mark = 5*a+b;
    }
  }
  for(a=20;a<25;a++)        	/* this for loop checks columns for
				   posible winning combinations for
				   opponent and blocks them */
  {
    val1 = 0; val2 = 0; mark = 0;
    for(b=0;b<21;b+=5)
    {
      col_num = (a-b)/5 + 1;
      val = pieces[a-b];
      if(val==P1)
      {
	val1 += 1;
	if ((val1==4)&&(a==20))             /* this handles top row */
	{
	  if (mark==0)
	    must2 = 5;
	  else if(mark!=4)
	    must2 = 4;
	  else
	    must2 = 3;
	}
	else if ((val1==4)&&(pieces[a-20]!=P1)) /* this handles row top */
	  must2 = a-14;
      }
      else
	mark = col_num;         /* col_num with odd val */
    }
  }
  for(a=20;a<25;a++)         	/* this for loop checks columns for posible
				   winning combinations and offers move
				   to win */
  {
    val1 = 0; val2 = 0; mark = 0;
    for(b=0;b<21;b+=5)
    {
      col_num = (a-b)/5 + 1;
      val = pieces[a-b];
      if(val==P2)
      {
	val2 += 1;
	if ((val2==4)&&(a==20)) /* this handles top row */
	{
	  if (mark==0)
	    must1 = 6;
	  else
	    must1 = mark;
	}
	else if ((val2==4)&&(pieces[a-20]!=P2))
	  must1 = a-14;
      }
      else
	mark = col_num;         /* col_num with odd val */
    }
  }
  for(a=20;a<25;a++)	     	/* this columns for loop checks for winning
				   combinations with winning move one slide
				   away (above) for player 2 */
  {
    val1 = 0; val2 = 0; mark = 0;
    for(b=0;b<21;b+=5)           
    {
      col_num = (a-b)/5 + 1;
      val = pieces[a-b];
      if(val==P2)
      {
	val2 += 1;
	if ((val2==4)&&(pieces[a]==EMPTY))
	  must1 = a-14;
				/* this else checks above rows if the
				   winning piece is hovering above
                                   the mark, or odd chip */
	else if((val2==4)&&(pieces[a-(5-mark)*5-1]==P2)&&(a!=20))
	{
	  for(b=2;b<a-18;b++)  /* this warns computer if hovering winning
				  chip won't slide because move will
				  be useless then */
	  {
	    val2=0;
	    if (pieces[a-(5-mark)*5-b]!=EMPTY)
	      val2 += 1;
            if (val2==a-20)
	      must1 = mark;
	  }
	}
      }
      else
	mark = col_num;         /* col_num with odd val */
    }
  }
  for(a=20;a<25;a++)		/* this for will check up for winning
  				   posibility for player 1 */
  {
    val1 = 0; val2 = 0; mark = 0;
    for(b=0;b<21;b+=5)          /* this for checks one up */
    {
      col_num = (a-b)/5 + 1;
      val = pieces[a-b];
      if(val==P1)
      {
	val1 += 1;
	if ((val1==4)&&(pieces[a]==EMPTY))
	  must2 = a-14;
	else if((val1==4)&&(pieces[a-(5-mark)*5-1]==P1)&&(a!=20))
	{			/* random alternative defense */
	    if ((mark!=1)&&(pieces[a-4*5-1]!=EMPTY)&&(pieces[a-4*5-1]!=P1))
	      must2 = 1;
	    else if ((mark!=P2)&&(pieces[a-3*5-1]!=EMPTY)&&(pieces[a-3*5-1]!=P1))
	      must2 = 2;
	    else if((mark!=3)&&(pieces[a-2*5-1]!=EMPTY)&&(pieces[a-2*5-1]!=P1))
	      must2 = 3;
	    else if((mark!=4)&&(pieces[a-1*5-1]!=EMPTY)&&(pieces[a-1*5-1]!=P1))
	      must2 = 4;
	    else if((mark!=5)&&(pieces[a-0*5-1]!=EMPTY)&&(pieces[a-0*5-1]!=P1))
	      must2 = 5;
	    else
	      must2 = a-14;
	}
      }
      else
	mark = col_num;     	 /* col_num with odd val */
    }
  }
				/* this does defense for diagonals */
  if ((pieces[0]==P1)&&(pieces[6]==P1)&&(pieces[12]==P1)&&(pieces[18]==P1))
  {
    if(pieces[23]==P2)
      must2 = 9;
    else if((pieces[17]==P2)&&(pieces[22]!=EMPTY))
      must2 = 8;
    else if(pieces[5]==P2)
      must2 = 2;
    else
      must2 = 1;
  }
  else if ((pieces[24]==P1)&&(pieces[6]==P1)&&(pieces[12]==P1)&&
	  (pieces[18]==P1))
  {
    if (pieces[23]==P2)
      must2 = 9;
    else if((pieces[17]==P2)&&(pieces[22]!=EMPTY))
      must2 = 8;
    else if(pieces[5]==P2)
      must2 = 2;
    else
      must2 = 10;
  }
  else if ((pieces[24]==P1)&&(pieces[0]==P1)&&(pieces[6]==P1)&&
	  (pieces[12]==P1))
  {
    if (pieces[5]==P2)
      must2 = 2;
    else if((pieces[17]==P2)&&(pieces[22]!=EMPTY))
      must2 = 8;
    else
      must2 = 1;
  }
  else if ((pieces[24]==P1)&&(pieces[0]==P1)&&(pieces[12]==P1)&&
	  (pieces[18]==P1))
  {
    if (pieces[23]==P2)
      must2 = 9;
    else if((pieces[17]==P2)&&(pieces[22]!=EMPTY))
      must2 = 8;
    else
      must2 = 1;
  }
  else if ((pieces[24]==P1)&&(pieces[0]==P1)&&(pieces[6]==P1)&&
	  (pieces[18]==P1))
  {
    if (pieces[23]==P2)
      must2 = 9;
    else if((pieces[11]==P2)&&(pieces[10]!=EMPTY))
      must2 = 3;
    else
      must2 = 1;
  }
				/* this does offense for diagonals */
  if ((pieces[0]==P2)&&(pieces[6]==P2)&&(pieces[12]==P2)&&(pieces[18]==P2))
    must1 = 10;
  if ((pieces[24]==P2)&&(pieces[6]==P2)&&(pieces[12]==P2)&&(pieces[18]==P2))
    must1 = 1;
  if ((pieces[0]==P2)&&(pieces[24]==P2)&&(pieces[12]==P2)&&(pieces[18]==P2))
    if(pieces[5]==P2)
      must1 = 2;
    else if((pieces[11]==P2)&&(pieces[16]!=EMPTY)&&(pieces[21]!=EMPTY))
      must1 = 7;
  if ((pieces[0]==P2)&&(pieces[6]==P2)&&(pieces[24]==P2)&&(pieces[18]==P2))
    if((pieces[11]==P2)&&(pieces[10]!=EMPTY))
      must1 = 3;
    else if((pieces[17]==P2)&&(pieces[22]!=EMPTY))
      must1 = 8;
  if ((pieces[0]==P2)&&(pieces[6]==P2)&&(pieces[12]==P2)&&(pieces[24]==P2))
    if(pieces[23]==P2)
      must1 = 9;
    else if((pieces[17]==P2)&&(pieces[16]!=EMPTY)&&(pieces[15]!=EMPTY))
      must1 = 4;

				/* More offense for diagonals */
  if ((pieces[20]==P2)&&(pieces[16]==P2)&&(pieces[12]==P2)&&(pieces[8]==P2))
    if ((pieces[3]==P2)&&(pieces[2]!=EMPTY)&&(pieces[1]!=EMPTY)&&(pieces[0]!=EMPTY))
      must1 = 1;
    else if ((pieces[9]==P2)&&(pieces[14]!=EMPTY)&&(pieces[19]!=EMPTY)&&
	    (pieces[24]!=EMPTY))
      must1 = 10;
  if ((pieces[20]==P2)&&(pieces[16]==P2)&&(pieces[12]==P2)&&(pieces[4]==P2))
    if ((pieces[7]==P2)&&(pieces[6]!=EMPTY)&&(pieces[5]!=EMPTY))
      must1 = 2;
    else if ((pieces[13]==P2)&&(pieces[18]!=EMPTY)&&(pieces[23]!=EMPTY))
      must1 = 9;
  if ((pieces[20]==P2)&&(pieces[16]==P2)&&(pieces[8]==P2)&&(pieces[4]==P2))
    if ((pieces[11]==P2)&&(pieces[10]!=EMPTY))
      must1 = 3;
    else if ((pieces[17]==P2)&&(pieces[22]!=EMPTY))
      must1 = 8;
  if ((pieces[20]==P2)&&(pieces[8]==P2)&&(pieces[12]==P2)&&(pieces[4]==P2))
    if ((pieces[15]==P2))
      must1 = 4;
    else if ((pieces[21]==P2))
      must1 = 7;
  if ((pieces[16]==P2)&&(pieces[8]==P2)&&(pieces[12]==P2)&&(pieces[4]==P2))
    must1 = 5;
				/* More defense for diagonals */
  if ((pieces[20]==P1)&&(pieces[16]==P1)&&(pieces[12]==P1)&&(pieces[8]==P1))
    if ((pieces[3]==P1)&&(pieces[13]!=EMPTY)&&(pieces[18]!=EMPTY)&&(pieces[23]!=EMPTY))
      must2 = 9;
    else if ((pieces[9]==P1)&&(pieces[7]!=EMPTY)&&(pieces[6]!=EMPTY)&&
	    (pieces[5]!=EMPTY))
      must2 = 2;
    else
      must2 = 6;
  if ((pieces[20]==P1)&&(pieces[16]==P1)&&(pieces[12]==P1)&&(pieces[4]==P1))
    if ((pieces[7]==P1)&&(pieces[12]!=EMPTY)&&(pieces[17]!=EMPTY)&&(pieces[22]!=EMPTY))
      must2 = 8;
    else if ((pieces[13]==P1)&&(pieces[11]!=EMPTY)&&(pieces[10]!=EMPTY))
      must2 = 3;
    else
      must2 = 6;
  if ((pieces[20]==P1)&&(pieces[16]==P1)&&(pieces[8]==P1)&&(pieces[4]==P1))
    if ((pieces[11]==P1)&&(pieces[21]!=EMPTY))
      must2 = 7;
    else if ((pieces[17]==P1)&&(pieces[15]!=EMPTY))
      must2 = 4;
    else
      must2 = 6;
  if ((pieces[20]==P1)&&(pieces[8]==P1)&&(pieces[12]==P1)&&(pieces[4]==P1))
      must2 = 6;
  if ((pieces[16]==P1)&&(pieces[8]==P1)&&(pieces[12]==P1)&&(pieces[4]==P1))
    if ((pieces[7]==P2)&&(pieces[12]!=EMPTY)&&(pieces[17]!=EMPTY)&&(pieces[22]!=EMPTY))
      must2 = 8;
    else if ((pieces[13]==P2)&&(pieces[11]!=EMPTY)&&(pieces[10]!=EMPTY))
      must2 = 3;
  if(must1!=0)
    move = must1;
  else if(must2!=0)
    move = must2;
  else
  {
    move = table[count%10];
    if(move==0)
      move = 10;
  }
  count += 1;
  return move;
}


/* the yourintelligence function offers player 1 advice.  Note: it
   is the exact opposite!!! of intelligence, the difference is that
   offensive moves for intelligence need to be defensive moves etc. You
   need NOT review!!! this section if you have looked over intelligence
   and you understand the function of yourintelligence is purely
   to give advice to player 1 */
int yourintelligence(int pieces[])
{
  static int count = 0;
  int table[20] = {2,1,9,6,8,5,0,3,7,4,0,7,3,5,2,8,2,6,0,9};
  int val1,val2,a,b,mark,val,move;
  int must1=0;
  int col_num=0;
  int must2=0;

  for(a=0;a<5;a++)
  {
    val1 = 0; val2 = 0; mark=0;
    for(b=0;b<5;b++)
    {         
      val = pieces[5*a+b];
      if(val==P2)
      {
	val2 += 1;
	if ((a==4)&&(val2==4))
	{
	   if (mark<24)
	     must2 = 7;
	   else
	     must2 = 10;
	}
	else if ((val2==4)&&(pieces[5*a+4]!=P2))    /* handles row start top */
	  must2 = a + 1;
	else if ((val2==4)&&(pieces[mark+5]==P2))
	    must2 = a + 1;
	else if ((val2==4)&&(pieces[mark]==EMPTY)&&
	     ((mark==0)||(mark==5)||(mark==10)||(mark==15)))
	  must2 = a + 1;
      }
      else
	mark = 5*a+b;
    }
  }
  for(a=0;a<5;a++)
  {
    val1 = 0; val2 = 0; mark=0;
    for(b=0;b<5;b++)
    {
      val = pieces[5*a+b];
      if(val==P1)
      {
	val1 += 1;
	if ((a==4)&&(val1==4)&&(pieces[24]==P1))
	  must1 = mark-14;
	else if ((a==4)&&(val1==4))
	  must1 = 5;
	else if ((val1==4)&&(pieces[5*a+4]!=P1))    /* handles row start top */
	  must1 = a + 1;
	else if ((val1==4)&&(pieces[mark]==EMPTY))
	  must1 = a + 1;
	else if ((val1==4)&&(pieces[mark+5]==P1))
	  must1 = mark - 5 * a + 6;
      }
      else
	mark = 5*a+b;
    }
  }
  for(a=20;a<25;a++)
  {
    val1 = 0; val2 = 0; mark = 0;
    for(b=0;b<21;b+=5)
    {
      col_num = (a-b)/5 + 1;
      val = pieces[a-b];
      if(val==P2)
      {
	val2 += 1;
	if ((val2==4)&&(a==20))             /* this handles top row */
	{
	  if (mark==0)
	    must2 = 5;
	  else if(mark!=4)
	    must2 = 4;
	  else
	    must2 = 3;
	}
	else if ((val2==4)&&(pieces[a-20]!=P1)) /* this handles row top */
	  must2 = a-14;
      }
      else
	mark = col_num;                     /* col_num with odd val */
    }
  }
  for(a=20;a<25;a++)
  {
    val1 = 0; val2 = 0; mark = 0;
    for(b=0;b<21;b+=5)
    {
      col_num = (a-b)/5 + 1;
      val = pieces[a-b];
      if(val==P1)
      {
	val1 += 1;
	if ((val1==4)&&(a==20))             /* this handles top row */
	{
	  if (mark==0)
	    must1 = 6;
	  else
	    must1 = mark;
	}
	else if ((val1==4)&&(pieces[a-20]!=P2)) /* this handles row top */
	  must1 = a-14;
      }
      else
	mark = col_num;                     /* col_num with odd val */
    }
  }
  for(a=20;a<25;a++)	     /* this for will check blanks up for p2*/
  {
    val1 = 0; val2 = 0; mark = 0;
    for(b=0;b<21;b+=5)             /* this for checks one up */
    {
      col_num = (a-b)/5 + 1;
      val = pieces[a-b];
      if(val==P1)
      {
	val1 += 1;
	if ((val1==4)&&(pieces[a]==EMPTY)) /* this handles row not top */
	  must1 = a-14;
	else if((val1==4)&&(pieces[a-(5-mark)*5-1]==P2)&&(a!=20))
	{
	  for(b=2;b<a-18;b++)
	  {
	    val2=0;
	    if (pieces[a-(5-mark)*5-b]!=EMPTY)
	      val1 += 1;
	    if (val1==a-20)
	      must1 = mark;
	  }
	}
      }
      else
	mark = col_num;                     /* col_num with odd val */
    }
  }
  for(a=20;a<25;a++)	     /* this for will check blanks up for p1*/
  {
    val1 = 0; val2 = 0; mark = 0;
    for(b=0;b<21;b+=5)             /* this for checks one up */
    {
      col_num = (a-b)/5 + 1;
      val = pieces[a-b];
      if(val==P2)
      {
	val2 += 1;
	if ((val2==4)&&(pieces[a]==EMPTY)) /* this handles row not top */
	  must2 = a-14;
	else if((val2==4)&&(pieces[a-(5-mark)*5-1]==P1)&&(a!=20))
	{
				       /* random alternative defense */
	  {
	    if ((mark!=1)&&(pieces[a-4*5-1]!=EMPTY)&&(pieces[a-4*5-1]!=P1))
	      must2 = 1;
	    else if ((mark!=2)&&(pieces[a-3*5-1]!=EMPTY)&&(pieces[a-3*5-1]!=P1))
	      must2 = 2;
	    else if((mark!=3)&&(pieces[a-2*5-1]!=EMPTY)&&(pieces[a-2*5-1]!=P1))
	      must2 = 3;
	    else if((mark!=4)&&(pieces[a-1*5-1]!=EMPTY)&&(pieces[a-1*5-1]!=P1))
	      must2 = 4;
	    else if((mark!=5)&&(pieces[a-0*5-1]!=EMPTY)&&(pieces[a-0*5-1]!=P1))
	      must2 = 5;
	    else
	      must2 = a-14;
	  }
	}
      }
      else
	mark = col_num;                     /* col_num with odd val */
    }
  }
  if ((pieces[0]==P2)&&(pieces[6]==P2)&&(pieces[12]==P2)&&(pieces[18]==P2))
  {
    if(pieces[23]==P1)
      must1 = 9;
    else if((pieces[17]==P1)&&(pieces[22]!=EMPTY))
      must1 = 8;
    else if(pieces[5]==P1)
      must1 = 2;
    else
      must2 = 1;
  }
  else if ((pieces[24]==P2)&&(pieces[6]==P2)&&(pieces[12]==P2)&&
	  (pieces[18]==P2))
  {
    if (pieces[23]==P1)
      must1 = 9;
    else if((pieces[17]==P1)&&(pieces[22]!=EMPTY))
      must1 = 8;
    else if(pieces[5]==P1)
      must1 = 2;
    else
      must1 = 10;
  }
  else if ((pieces[24]==P2)&&(pieces[0]==P2)&&(pieces[6]==P2)&&
	  (pieces[12]==P2))
  {
    if (pieces[5]==P1)
      must1 = 2;
    else if((pieces[17]==P1)&&(pieces[22]!=EMPTY))
      must1 = 8;
    else
      must1 = 1;
  }
  else if ((pieces[24]==P2)&&(pieces[0]==P2)&&(pieces[12]==P2)&&
	  (pieces[18]==P2))
  {
    if (pieces[23]==P1)
      must1 = 9;
    else if((pieces[17]==P1)&&(pieces[22]!=EMPTY))
      must1 = 8;
    else
      must1 = 1;
  }
  else if ((pieces[24]==P2)&&(pieces[0]==P2)&&(pieces[6]==P2)&&
	  (pieces[18]==P2))
  {
    if (pieces[23]==P1)
      must1 = 9;
    else if((pieces[11]==P1)&&(pieces[10]!=EMPTY))
      must1 = 8;
    else
      must1 = 1;
  }
  if ((pieces[0]==P1)&&(pieces[6]==P1)&&(pieces[12]==P1)&&(pieces[18]==P1))
    must1 = 10;
  if ((pieces[24]==P1)&&(pieces[6]==P1)&&(pieces[12]==P1)&&(pieces[18]==P1))
    must1 = 1;
  if ((pieces[0]==P1)&&(pieces[24]==P1)&&(pieces[12]==P1)&&(pieces[18]==P1))
    if(pieces[5]==P1)
      must1 = 2;
    else if((pieces[11]==P1)&&(pieces[16]!=EMPTY)&&(pieces[21]!=EMPTY))
      must1 = 7;
  if ((pieces[0]==P1)&&(pieces[6]==P1)&&(pieces[24]==P1)&&(pieces[18]==P1))
    if((pieces[11]==P1)&&(pieces[10]!=EMPTY))
      must1 = 3;
    else if((pieces[17]==P1)&&(pieces[22]!=EMPTY))
      must1 = 8;
  if ((pieces[0]==P1)&&(pieces[6]==P1)&&(pieces[12]==P1)&&(pieces[24]==P1))
    if(pieces[23]==P1)
      must1 = 9;
    else if((pieces[17]==P1)&&(pieces[16]!=EMPTY)&&(pieces[15]!=EMPTY))
      must1 = 4;


  if ((pieces[20]==P1)&&(pieces[16]==P1)&&(pieces[12]==P1)&&(pieces[8]==P1))
    if ((pieces[3]==P1)&&(pieces[2]!=EMPTY)&&(pieces[1]!=EMPTY)&&(pieces[0]!=EMPTY))
      must1 = 1;
    else if ((pieces[9]==P1)&&(pieces[14]!=EMPTY)&&(pieces[19]!=EMPTY)&&
	    (pieces[24]!=EMPTY))
      must1 = 10;
  if ((pieces[20]==P1)&&(pieces[16]==P1)&&(pieces[12]==P1)&&(pieces[4]==P1))
    if ((pieces[7]==P1)&&(pieces[6]!=EMPTY)&&(pieces[5]!=EMPTY))
      must1 = 2;
    else if ((pieces[13]==P1)&&(pieces[18]!=EMPTY)&&(pieces[23]!=EMPTY))
      must1 = 9;
  if ((pieces[20]==P1)&&(pieces[16]==P1)&&(pieces[8]==P1)&&(pieces[4]==P1))
    if ((pieces[11]==P1)&&(pieces[10]!=EMPTY))
      must1 = 3;
    else if ((pieces[17]==P1)&&(pieces[22]!=EMPTY))
      must1 = 8;
  if ((pieces[20]==P1)&&(pieces[8]==P1)&&(pieces[12]==P1)&&(pieces[4]==P1))
    if ((pieces[15]==P1))
      must1 = 4;
    else if ((pieces[21]==P1))
      must1 = 7;
  if ((pieces[16]==P1)&&(pieces[8]==P1)&&(pieces[12]==P1)&&(pieces[4]==P1))
    must1 = 5;

  if ((pieces[20]==P2)&&(pieces[16]==P2)&&(pieces[12]==P2)&&(pieces[8]==P2))
    if ((pieces[3]==P2)&&(pieces[13]!=EMPTY)&&(pieces[18]!=EMPTY)&&(pieces[23]!=EMPTY))
      must2 = 9;
    else if ((pieces[9]==P2)&&(pieces[7]!=EMPTY)&&(pieces[6]!=EMPTY)&&
	    (pieces[5]!=EMPTY))
      must2 = 2;
    else
      must2 = 6;
  if ((pieces[20]==P2)&&(pieces[16]==P2)&&(pieces[12]==P2)&&(pieces[4]==P2))
    if ((pieces[7]==P2)&&(pieces[12]!=EMPTY)&&(pieces[17]!=EMPTY)&&(pieces[22]!=EMPTY))
      must2 = 8;
    else if ((pieces[13]==P2)&&(pieces[11]!=EMPTY)&&(pieces[10]!=EMPTY))
      must2 = 3;
    else
      must2 = 6;
  if ((pieces[20]==P2)&&(pieces[16]==P2)&&(pieces[8]==P2)&&(pieces[4]==P2))
    if ((pieces[11]==P2)&&(pieces[21]!=EMPTY))
      must2 = 7;
    else if ((pieces[17]==P2)&&(pieces[15]!=EMPTY))
      must2 = 4;
    else
      must2 = 6;
  if ((pieces[20]==P2)&&(pieces[8]==P2)&&(pieces[12]==P2)&&(pieces[4]==P2))
      must2 = 6;
  if ((pieces[16]==P2)&&(pieces[8]==P2)&&(pieces[12]==P2)&&(pieces[4]==P2))
    if ((pieces[7]==P1)&&(pieces[12]!=EMPTY)&&(pieces[17]!=EMPTY)&&(pieces[22]!=EMPTY))
      must2 = 8;
    else if ((pieces[13]==P1)&&(pieces[11]!=EMPTY)&&(pieces[10]!=EMPTY))
      must2 = 3;
  if(must1!=0)
    move = must1;
  else if(must2!=0)
    move = must2;
  else
  {
    move = table[count%20];
    if(move==0)
      move = 10;
  }
  count += 1;
  return move;
}
