# AVG linespoints, (redo) FCDR w/ adv 2 Solns 0100,0500,0750,01000,2000
# Prog Statements adjusted for average generated example size 
# 1. Std Dist included

set xlabel "Program statements"
set xrange [0:9000]
set xtics 0,500
set ylabel "Constraint checks"
set yrange [0:150000]
set ytics   0,10000

set key 
set term postscript landscape monochrome "Times-Roman" 14
set output "redo-adv-avg.ps"
plot "redo-adv.avg" title "Std Dist" with linespoints


