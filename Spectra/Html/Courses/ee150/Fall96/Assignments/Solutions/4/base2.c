/* This program will read in several binary numbers and convert them 
   into decimal numbers                  */

# include <stdio.h>

/* function declearation */
  int BinToDec(char c);   
  char getNondelimiter();

main()
{
  char c;
  int END=0, n=-1;

  printf("Please input the Binary numbers (press return to exit): \n");

/* read in the first digit characters and pass them to BinTodec() for converting
  until read in a 'return' key                                          */
 
  while(END!=1 && (c=getNondelimiter())!='\n')
   {

     n=BinToDec(c);
     if(n<0)
      {
       n=(-1)*n;
       END=1;
       }
      printf(" %i,  ",n);
    }          
  }
   
/* 
  This function reads chars until a non-delimiter is encountered,
   and returns the first non-delimiter found.
*/
  char getNondelimiter()
 {
   char c=' ';

   while(c==' '||c==','|| c==';' || c=='.')
           c=getchar();
   
   return c;
  }

/*
 This function reads a binary number starting with the second
  character/digit and passes the first character/digit through
the function parameter.
 The value returned is the decimal value of the whole binary
number or else the negative value when this biary number followed
by a '\n'
*/

   int BinToDec(char c)
  {
    int value;
    value= c-'0';

    while(!(c==' ' || c==','|| c==';' || c=='.'||c=='\n'))
        {
         c=getchar();

         if((c -'0')<=1&& (c-'0')>=0) value= 2*value + (c-'0');
        
         }
  
    if(c=='\n') value=(-1)*value ;
    return value;
   }
    
