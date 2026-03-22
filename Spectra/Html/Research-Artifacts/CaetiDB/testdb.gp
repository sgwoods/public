set xlabel "West - East"
set ylabel "South - North"
set xrange [180:280]
set yrange [370:500]
set xtics 0,10
set ytics 0,10
# set key 100,115
set nokey 
set term postscript landscape monochrome "Times-Roman" 14
set output "testdb.ps"
#plot "caeti-db.0" title "Zero" with points, "caeti-db.1" title "One" with points, "caeti-db.2" title "Two" with points
plot "caeti-db.1" title "One" with points, "caeti-db.2" title "Two" with points

