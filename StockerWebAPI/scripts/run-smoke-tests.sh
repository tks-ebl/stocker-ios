#!/bin/sh
set -eu

BASE_URL="${BASE_URL:-http://api:8080}"
WAREHOUSE_ID="${WAREHOUSE_ID:-11111111-1111-1111-1111-111111111111}"

echo "Waiting for API health endpoint..."
i=0
until curl -fsS "${BASE_URL}/health" >/dev/null 2>&1; do
  i=$((i + 1))
  if [ "$i" -ge 30 ]; then
    echo "API did not become healthy in time." >&2
    exit 1
  fi
  sleep 2
done

echo "Health endpoint is ready."

LOGIN_RESPONSE="$(curl -fsS -X POST "${BASE_URL}/auth/login" \
  -H 'Content-Type: application/json' \
  -d '{"userCode":"worker01","password":"Passw0rd!"}')"

TOKEN="$(printf '%s' "$LOGIN_RESPONSE" | sed -n 's/.*"accessToken":"\([^"]*\)".*/\1/p')"
if [ -z "$TOKEN" ]; then
  echo "Failed to extract access token from login response." >&2
  exit 1
fi

echo "Login endpoint succeeded."

curl -fsS "${BASE_URL}/warehouses/${WAREHOUSE_ID}/inventory" \
  -H "Authorization: Bearer ${TOKEN}" >/dev/null

echo "Authorized inventory endpoint succeeded."

CREATE_RESPONSE="$(curl -fsS -X POST "${BASE_URL}/warehouses/${WAREHOUSE_ID}/shipping-results" \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer ${TOKEN}" \
  -d '{"shippingPlanId":"66666666-6666-6666-6666-666666666666","destinationCode":"DEST-001","results":[{"itemCode":"ITEM-001","itemName":"防災ライト","locationCode":"A-01-01","quantity":2}]}' )"

case "$CREATE_RESPONSE" in
  *'"createdCount":1'* ) ;;
  * )
    echo "Shipping result creation did not return the expected payload." >&2
    exit 1
    ;;
esac

echo "Shipping result creation endpoint succeeded."
