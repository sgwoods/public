# IN PROGRESS - modifying  sgw

# PUT YOUR HOSTS IN THIS LIST.
sunhosts="logos"

MYPATH=/u/sgwoods/Html
SPECIALFILE=/u/sgwoods/Html/USERS.special

echo Content-type: text/html
echo ""

echo \<html\>
echo \<TITLE\>Clarkson Computer Labs\</TITLE\>
echo \<h1\>3rd Floor Suns\</h1\>
echo \<h3\>Located in Clarkson Hall\</h3\>
echo \<hr\>
echo \<a href\=/who_help.html\>\<img src=/Gifs/help.gif\>
echo Get help on this page\</a\>
echo \<HR\>
echo This is the state of the Suns on: \<B\>`/bin/date`\</B\>
echo

uphost=
downhost=
x=0
for host in $sunhosts
do
   response=`/usr/etc/ping $host 2`
   
   if [`echo $response | /usr/bin/grep alive |  /usr/ucb/wc -l` -ne 0 ]
   then
     uphost=`echo $uphost $host`
   else 
     downhost=`echo $downhost $host`
   fi
done

echo \<P\>

for host in $uphost
do
   shost=`echo $host | /bin/cut -f1 -d.`
   echo -n \<B\>\<A HREF="telnet://$host.clarkson.edu"\>
   echo -n $shost
   echo -n \</B\>\</A\>
   echo -n \<IMG SRC="/Gifs/black_term.gif" ALIGN="MIDDLE"\> 

   whusers=`/usr/ucb/rusers -i $host`
   if [`echo $whusers | /usr/bin/grep $shost | /usr/ucb/wc -l` -ne 0 ]
   then
   whusers=`echo $whusers | cut -f2- -d" "`
   y=0
   whusers=`echo $whusers | tr -s ' ' '\012' | sort -u`
   echo "$whusers" |
   while read person
   do
     if [`/usr/bin/grep $person $SPECIALFILE |  /usr/ucb/wc -l` -ne 0 ]
     then
        type=`/usr/bin/grep $person $SPECIALFILE | cut -c1`
     else
        type=`echo $person | cut -c1`
     fi
     case $type in
     u )
     echo -n  "   "\<IMG SRC="/Gifs/reg_bart.gif" ALIGN="MIDDLE"\>
     ;;
     g )
     echo -n  "   "\<IMG SRC="/Gifs/cool_bart.gif" ALIGN="MIDDLE"\>
     ;;
     f )
     echo -n  "   "\<IMG SRC="/Gifs/grad_bart.gif" ALIGN="MIDDLE"\>
     ;;
     s )
     echo -n  "   "\<IMG SRC="/Gifs/doc_bart.gif" ALIGN="MIDDLE"\>
     ;;
     c )
     echo -n  "   "\<IMG SRC="/Gifs/hat_bart.gif" ALIGN="MIDDLE"\>
     ;;
     x )
     echo -n  "   "\<IMG SRC="/Gifs/duh_bart.gif" ALIGN="MIDDLE"\>
     ;;
     z )
     echo -n  "   "\<IMG SRC="/Gifs/elgin.gif" ALIGN="MIDDLE"\>
     ;;
     o )
     echo -n  "   "\<IMG SRC="/Gifs/cold_bart.gif" ALIGN="MIDDLE"\>
     ;;
     a )
     echo -n  "   "\<IMG SRC="/Gifs/robotman.gif" ALIGN="MIDDLE"\>
     ;;
     *)
     echo -n  "   "\<IMG SRC="/Gifs/red_bart.gif" ALIGN="MIDDLE"\>
     ;;
     esac 
     echo -n " "\<A HREF="/cgi-bin/finger?$person@$host"\>$person\</A\>
     y=`expr $y + 1`
     if [ $y -eq 4 ]
     then
        y=0
        echo \<P\>
     fi
   done
   echo \<P\>
   else
     echo -n  "   "\<IMG SRC="/Gifs/chair.gif" ALIGN="MIDDLE"\>
     echo -n " "\<I\>nobody\</I\>"   "
     x=`expr $x + 1`
     if [ $x -eq 2 ]
     then
        x=0
        echo \<P\>
     fi
   fi

done

x=0
echo \<P\>
for host in $downhost
do
   echo -n \<B\>
   echo -n `echo $host | /usr/bin/cut -f1 -d.`
   echo -n \</B\>
   echo -n \<IMG SRC="/Gifs/red_term.gif" ALIGN="MIDDLE"\>
   x=`expr $x + 1`
   if [ $x -eq 4 ]
   then
        x=0
        echo \<P\>
   fi

done
echo \<hr\>
echo \<p\>\<a href="http://woody.c2tc.rl.af.mil/htbin/C013"\>Here\'s where
echo I got the idea.\</a\>

cat << DUH
<p> If you want me to change your picture just send mail to me. 
I'll try to honor all requests
<img src="/Gifs/calvin_mad.gif">
<address>woodforc@sun.soe.clarkson.edu</address>
DUH

echo \<hr\>
echo \<a href="http://jupiter.ece.clarkson.edu:5050/"\>
echo \<img src=/Gifs/right_hand.gif\>
echo Back \</a\> to the Home Page...

echo \</html\>

