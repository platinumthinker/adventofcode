#!/usr/bin/gnuplot

set terminal pngcairo mono enhanced size 1000,1000
unset grid
unset label

set output "lights.png"

plot [0:1000] [0:1000] "output.txt" using 1:2 with points
