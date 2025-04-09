#!/bin/bash

echo "Waiting for deployment to settle..."
sleep 10  # You may want to adjust this depending on your deployment time.

# Load environment variables if present
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo "⚠️ .env file not found! Ensure environment variables are set."
fi

# Ensure ENDPOINT variable is set
if [ -z "$ENDPOINT" ]; then
  echo "❌ ENDPOINT environment variable is not set. Please check your .env file."
  exit 1
fi

# Test: Create or update item (PUT /items)
echo "Testing PUT /items (Create or update item)"
CREATE_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X PUT "$ENDPOINT/items" -H "Content-Type: application/json" -d '{"id": "1", "name": "netzence", "price": 500}')
if [ "$CREATE_RESPONSE" -ne 200 ]; then
  echo "❌ Test failed: PUT /items. Expected 200, got $CREATE_RESPONSE"
  exit 1
else
  echo "✅ Test passed: PUT /items"
fi

# Test: Read all items (GET /items)
echo "Testing GET /items (Read all items)"
GET_ALL_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X GET "$ENDPOINT/items")
if [ "$GET_ALL_RESPONSE" -ne 200 ]; then
  echo "❌ Test failed: GET /items. Expected 200, got $GET_ALL_RESPONSE"
  exit 1
else
  echo "✅ Test passed: GET /items"
fi

# Test: Read specific item by ID (GET /items/{id})
echo "Testing GET /items/1 (Read item by ID)"
GET_ITEM_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X GET "$ENDPOINT/items/1")
if [ "$GET_ITEM_RESPONSE" -ne 200 ]; then
  echo "❌ Test failed: GET /items/1. Expected 200, got $GET_ITEM_RESPONSE"
  exit 1
else
  echo "✅ Test passed: GET /items/1"
fi

# Test: Update item (PUT /items)
echo "Testing PUT /items (Update item)"
UPDATE_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X PUT "$ENDPOINT/items" -H "Content-Type: application/json" -d '{"id": "1", "name": "netzence", "price": 600}')
if [ "$UPDATE_RESPONSE" -ne 200 ]; then
  echo "❌ Test failed: PUT /items. Expected 200, got $UPDATE_RESPONSE"
  exit 1
else
  echo "✅ Test passed: PUT /items (Update)"
fi

# Test: Delete item by ID (DELETE /items/{id})
echo "Testing DELETE /items/1 (Delete item by ID)"
DELETE_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE "$ENDPOINT/items/1")
if [ "$DELETE_RESPONSE" -ne 200 ]; then
  echo "❌ Test failed: DELETE /items/1. Expected 200, got $DELETE_RESPONSE"
  exit 1
else
  echo "✅ Test passed: DELETE /items/1"
fi

echo "All tests completed!"
