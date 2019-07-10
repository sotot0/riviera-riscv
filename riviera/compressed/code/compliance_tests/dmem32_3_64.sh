#!/bin/bash

FILES=*.dmem.dat

for f in $FILES
do

	tac $f > tmpfile.dmem.dat
	paste -s -d '\0\n' tmpfile.dmem.dat > tmpp.dmem.dat
	tac tmpp.dmem.dat > $f
	sed -r 's/\s+//g' $f > "64_$f"
	rm tmpfile.dmem.dat
	rm tmpp.dmem.dat

done
