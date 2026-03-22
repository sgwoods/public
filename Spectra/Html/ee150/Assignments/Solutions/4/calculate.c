/* This program will do the binary addition and multiplication,
and output the result in decimal form.                 */

# include <stdio.h>
  int BinToDec(char c);   
  char getNondelimiter();

main()
{
  char c;
  int END=0, n=-1;
  int value=0,temp=0,temp_empty=1;
  char op='+';

  printf("Please input the Binary numbers (press return to exit): \n");
/*
   read in one operator and one operand every time.If the operator is
  '+',assign the value of operand to TEMP until reading in another '+'.
   Then we  can add TEMP into VALUE.
   If the operator is '*',TEMP=TEMP*operand.
*/ 
  while(END!=1 && (c=getNondelimiter())!='\n')
   {
      if (c=='+') 
          {op='+';c=getNondelimiter();}
      else if(c =='*')
          {op='*';c=getNondelimiter();}

      n=BinToDec(c);

      if(n<0)
      {
       n=(-1)*n;
       END=1;
       }
     if(temp_empty==1)
          printf("%i  ",n);
     else
          printf(" %c %i ",op,n);
     if(op=='+')
        {value=value+temp;
         temp=n;
         temp_empty=0;
        }
     if(op=='*')
        {
         if (temp_empty==1)
               temp=n;
         else
               temp=temp*n;
         temp_empty=0;
         }  
    } 
     value=value+temp;         
     printf("= %i \n",value);
  }
