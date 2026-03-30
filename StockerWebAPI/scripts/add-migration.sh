#!/bin/sh
set -eu

if [ "$#" -ne 1 ]; then
  echo "Usage: ./scripts/add-migration.sh <MigrationName>" >&2
  exit 1
fi

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
MIGRATION_NAME="$1"

docker run --rm \
  -v "${ROOT_DIR}:/workspace" \
  -w /workspace \
  mcr.microsoft.com/dotnet/sdk:8.0 \
  sh -lc "dotnet tool restore && dotnet tool run dotnet-ef migrations add ${MIGRATION_NAME} --project src/StockerWebAPI.Api/StockerWebAPI.Api.csproj --startup-project src/StockerWebAPI.Api/StockerWebAPI.Api.csproj --output-dir Data/Migrations"

