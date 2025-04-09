#!/bin/bash

echo "Waiting for deployment to settle..."
sleep 10  

if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

echo "Running test "
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$ENDPOINT")

if [ "$RESPONSE" -ne 200 ]; then
  echo "❌ Test failed: Expected 200, got $RESPONSE"
  exit 1
else
  echo "✅ Test passed: Got 200 OK"
fi
