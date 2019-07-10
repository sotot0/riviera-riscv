#!/bin/bash
RVTESTS=`cd rv_tests && ls *.S | cut -d "." -f 1`

rm testnames.txt
for tst in $RVTESTS; do
  echo $tst >> testnames.txt
  BINARY=$tst make
done
