#!/bin/sh
set -eu

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
  echo "Usage: ./deploy/azure/scripts/build-and-push-acr.sh <acr-name> <image-name> [tag]" >&2
  exit 1
fi

ACR_NAME="$1"
IMAGE_NAME="$2"
IMAGE_TAG="${3:-latest}"
ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)"
IMAGE_REF="${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${IMAGE_TAG}"

echo "Building image: ${IMAGE_REF}"
docker build -t "${IMAGE_REF}" -f "${ROOT_DIR}/src/StockerWebAPI.Api/Dockerfile" "${ROOT_DIR}"

echo "Logging in to ACR: ${ACR_NAME}"
az acr login --name "${ACR_NAME}"

echo "Pushing image: ${IMAGE_REF}"
docker push "${IMAGE_REF}"

echo "Completed: ${IMAGE_REF}"

