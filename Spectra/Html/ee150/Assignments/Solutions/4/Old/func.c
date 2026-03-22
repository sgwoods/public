 char getNondelimiter()
 {
  char c=' ';

  while(c==' '||c==','|| c==';' || c=='.')
           c=getchar();
   
   return c;
  }

int BinToDec(char c)
  {
    int value;
    value= c-'0';

    while( !(c==' ' || c==',' || c==';' || c=='.' || c =='\n') )
       {
         c = getchar();

         if( (c -'0') <= 1 && (c-'0') >= 0) value = 2 * value + (c-'0');
        }
     if ( c=='\n' ) value= (-1) * value ;
     return value;
   }
