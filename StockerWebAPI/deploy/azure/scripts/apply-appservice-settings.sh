#!/bin/sh
set -eu

if [ "$#" -ne 3 ]; then
  echo "Usage: ./deploy/azure/scripts/apply-appservice-settings.sh <resource-group> <webapp-name> <settings-json-file>" >&2
  exit 1
fi

RESOURCE_GROUP="$1"
WEBAPP_NAME="$2"
SETTINGS_FILE="$3"

az webapp config appsettings set \
  --resource-group "${RESOURCE_GROUP}" \
  --name "${WEBAPP_NAME}" \
  --settings "@${SETTINGS_FILE}"

echo "Applied app settings to ${WEBAPP_NAME}."

