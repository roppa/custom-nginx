#!bin/bash

echo "##############################################################"
echo "Running Nginx container tests"
echo "##############################################################"

#nginx test config:
# /usr/bin/nginx -t

let "passing=0"
let "failing=0"

echo ""
echo "--------------------------------------------------------------"
echo "Test: Index page at root / "
echo "--------------------------------------------------------------"

HOME=$(curl -s http://172.17.0.1:8800/ | grep '<h1>')

if [[ $HOME =~ "Default site!" ]]; then
  echo "exists - PASS"
  let "passing=passing+1"
else
  echo "does not exist - FAIL"
  let "failing=failing+1"
fi

echo ""
echo "--------------------------------------------------------------"
echo "Test: Test page at /test "
echo "--------------------------------------------------------------"

TEST=$(curl -s http://172.17.0.1:8800/test)

if [[ $TEST = "test.conf home page" ]]; then
  echo "exists - PASS"
  let "passing=passing+1"
else
  echo "does not exist - FAIL"
  let "failing=failing+1"
fi

echo ""
echo "--------------------------------------------------------------"
echo "Test: Test error page at /error "
echo "--------------------------------------------------------------"

ERROR=$(curl -s -o /dev/null -w "%{http_code}" http://172.17.0.1:8800/error)

if [[ $ERROR = 500 ]]; then
  echo "exists - PASS"
  let "passing=passing+1"
else
  echo "does not exist - FAIL"
  let "failing=failing+1"
fi

echo ""
echo "--------------------------------------------------------------"
echo "Test: Test included file page at /included "
echo "--------------------------------------------------------------"

INCLUDED=$(curl -s http://172.17.0.1:8800/included)

if [[ $INCLUDED = "includedfile.conf test page" ]]; then
  echo "exists - PASS"
  let "passing=passing+1"
else
  echo "does not exist - FAIL"
  let "failing=failing+1"
fi

echo ""
echo "##############################################################"
echo  "Total passing: $passing"
echo  "Total failing: $failing"
echo "##############################################################"
echo ""

if (($failing > 0)); then
  exit 1
else
  exit 0
fi
