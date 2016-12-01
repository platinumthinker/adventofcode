#!/usr/bin/gnuplot

set terminal pngcairo mono enhanced size 1000,1000
unset grid
unset label

set dgrid3d 30,30
set output "lights.png"
set xrange [0:1000]
set yrange [0:1000]

splot "output.txt" using 1:2:3 with lines
