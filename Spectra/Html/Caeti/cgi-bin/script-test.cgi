#! /bin/sh

echo Content-type: text/html
echo

cat << EOF
<HTML>
<HEAD><TITLE>Date</TITLE></HEAD>

<BODY>
<P>The current date is: <B>
EOF

/bin/date

cat << EOF
</B>
</BODY>
</HTML>
EOF