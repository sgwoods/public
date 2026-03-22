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

