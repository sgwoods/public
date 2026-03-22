/* Group 1.
 *Read a character from keyboard and return the valid move number
 *if r or R is pressed call rule function. If h or H is pressed call
 *help function. If Q or q is pressed back to main menu
 */

#include<stdio.h>
#include<ctype.h>

int get_move(void)
{
  void rule();
  void rule2();

  int valid=0;    /*initialize the valid condition as false*/
  char c;         /*character from keyboard*/
  int move=-2;    /*set move condition false and its value equal to -2*/
  int exitrule=0;
  while(valid==0||move==-2)
    {
      while(c=getchar(),(c!='R'&&c!='r')&&(c!='H'&&c!='h')&&
	    (c!='Q'&&c!='q') && isdigit(c)==0)
	;

      if (c=='R'||c=='r')
	{
	  while(exitrule==0)
	    {
	      rule();
	      printf("Please enter your option:");
	      getchar();
	      if((c=getchar()), c=='F'||c=='f')
		{
		  rule2();
		  getchar();
		  printf("Please enter your option:");
		  if((c=getchar()), c=='M'|| c=='m')
		    exitrule=1;
		}
	      else
		exitrule=1;
	    }
          break;
	}
      else if (c=='H'||c=='h')
	{
	  help();
	  getchar();
	  break;
	}
      else if(c=='Q'||c=='q')
	{
	  valid=1;
          move=-1;
	}
      else
	{
	move=c-'0';
	while(c=getchar(), c!='\n')
          move=move*10+(c-'0');
        if (move<=10 && move>=1) valid=1;
        else
          printf("This is not a valide move, try again:"); 
      }
    }

  return move;
}






