# AVG linespoints, (redo) FCDR 2 Solns 0100,0500,0750,01000  most at 2000 exceed time
# Prog Statements adjusted for average generated example size 
# 1. Std Dist included

set xlabel "Program statements"
set xrange [0:9000]
set xtics 0,500
set ylabel "Constraint checks"
set yrange [0:150000]
set ytics   0,10000

set key 
set size 0.7,1.4
set term postscript landscape 22
set output "redo-avg.ps"
plot "redo.avg" title "Std Dist" with linespoints


