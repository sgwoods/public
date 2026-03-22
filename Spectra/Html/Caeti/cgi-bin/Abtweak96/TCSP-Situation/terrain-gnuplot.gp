
set xlabel "West - East"
set ylabel "South - North"
set xrange [0:10]
set yrange [0:10]
set xtics 0,1
set ytics 0,1
set nokey
set term postscript landscape monochrome "Times-Roman" 14
set output "QCSP/TSit/Terrain-Map1.ps"
set arrow from 2,9 to 1,9
set label "M" at 4,9 center
set label "M" at 5,9 center
set label "M" at 3,8 center
set label "M" at 4,8 center
set label "M" at 7,8 center
set label "M" at 8,8 center
set label "M" at 1,7 center
set label "M" at 2,7 center
set label "M" at 3,7 center
set label "M" at 6,7 center
set label "M" at 7,7 center
set label "M" at 8,7 center
set label "M" at 2,6 center
set label "M" at 6,6 center
set label "M" at 7,6 center
set label "M" at 1,5 center
set label "M" at 1,4 center
set label "M" at 2,4 center
set label "M" at 3,4 center
set label "M" at 1,3 center
set label "M" at 2,3 center
set label "M" at 3,3 center
set label "f" at 4,7 center
set label "f" at 6,3 center
set label "f" at 7,2 center
set label " " at 1,9 center
set label " " at 2,9 center
set label " " at 3,9 center
set label " " at 6,9 center
set label " " at 7,9 center
set label " " at 8,9 center
set label " " at 1,8 center
set label " " at 2,8 center
set label " " at 5,8 center
set label " " at 6,8 center
set label " " at 5,7 center
set label " " at 1,6 center
set label " " at 3,6 center
set label " " at 4,6 center
set label " " at 5,6 center
set label " " at 8,6 center
set label " " at 2,5 center
set label " " at 3,5 center
set label " " at 4,5 center
set label " " at 5,5 center
set label " " at 6,5 center
set label " " at 7,5 center
set label " " at 8,5 center
set label " " at 4,4 center
set label " " at 5,4 center
set label " " at 6,4 center
set label " " at 7,4 center
set label " " at 8,4 center
set label " " at 4,3 center
set label " " at 5,3 center
set label " " at 7,3 center
set label " " at 8,3 center
set label " " at 1,2 center
set label " " at 2,2 center
set label " " at 3,2 center
set label " " at 4,2 center
set label " " at 5,2 center
set label " " at 6,2 center
set label " " at 8,2 center
set label " " at 1,1 center
set label " " at 2,1 center
set label " " at 3,1 center
set label " " at 4,1 center
set label " " at 5,1 center
set label " " at 6,1 center
set label " " at 7,1 center
set label " " at 8,1 center
plot "QCSP/TSit/Route-coords" with lines