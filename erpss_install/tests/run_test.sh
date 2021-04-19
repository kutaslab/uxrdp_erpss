#!/bin/bash

# ERPSS 32-bit binary ASCII terminal and X11 graphics smoke tests

# dumps recording info to stdout
headinfo calstest.crw

# pops a graphics window EEG viewer and UI navigator in the console.
# this blocks the test, press q in the console to quit and continue
garv 100 calstest.crw calstest.log

# generates .blf binlist file
cdbl calstest.bdf calstest.log calstest.blf 250 >> calstest.counts
cat calstest.counts

# workhorse averager generates .avg file
rm -f calstest.x.avg
echo "calstest.crw calstest.log calstest.blf" | avg 100 calstest.x.avg
headinfo calstest.x.avg

rm -f calstest.x.nrm
normerp calstest.x.avg calstest.x.nrm -a 5 -n -40 40 10 1 1000

# pops up an X11 window of bin averages
ploterps xwin 26chan -files calstest.x.avg -bins 1 10 20

# dumps a pdf of bin averages to out.pdf
ploterps pdff 26chan -files calstest.x.avg -bins 1 10 20

