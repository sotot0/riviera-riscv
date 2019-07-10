#!/bin/bash
RVTESTS=`cd rv_tests && ls *.S | cut -d "." -f 1`

for tst in $RVTESTS; do
  BINARY=$tst make clean
done
rm testnames.txt
