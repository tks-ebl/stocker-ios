#!/bin/sh
set -eu

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

cleanup() {
  docker compose -f "${ROOT_DIR}/docker-compose.yml" down -v >/dev/null 2>&1 || true
}

trap cleanup EXIT

cleanup

echo "Starting API and PostgreSQL..."
docker compose -f "${ROOT_DIR}/docker-compose.yml" up -d --build postgres api

echo "Running unit tests in Docker..."
docker compose -f "${ROOT_DIR}/docker-compose.yml" --profile test build unit-tests
docker compose -f "${ROOT_DIR}/docker-compose.yml" --profile test run --rm unit-tests

echo "Running smoke tests in Docker..."
docker compose -f "${ROOT_DIR}/docker-compose.yml" --profile test run --rm smoke-tests

echo "All Docker tests completed successfully."
