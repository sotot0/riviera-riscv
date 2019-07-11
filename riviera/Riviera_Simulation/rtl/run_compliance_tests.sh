#!/bin/bash
RVTESTS=`cd ../code/compliance_test/rv_tests && ls *.S | cut -d "." -f 1`

rm comp.log
make comp >> comp.log

echo ""
echo "Starting..."
echo ""

for tst in $RVTESTS; do
  
  ln -f -s ../code/compliance_test/$tst.dmem.dat tmp.dmem.dat
  ln -f -s ../code/compliance_test/$tst.imem.dat tmp.imem.dat

  echo "Running $tst compliance test"
  make run >> comp.log 

done

rm tmp.dmem.dat
rm tmp.imem.dat

echo ""
echo "---------------"
echo "      PASS     "
echo "---------------"
cat comp.log |grep "OK"

echo ""
echo "---------------"
echo "      FAIL     "
echo "---------------"
cat comp.log |grep "ERROR"

echo ""
