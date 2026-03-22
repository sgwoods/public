/* read in the first digit characters and pass them to BinTodec() for converting
  until read in a 'return' key                                          */

  char getNondelimiter()
 {
   char c=' ';

   while(c==' '||c==','|| c==';' || c=='.')
           c=getchar();

   return c;
  }

