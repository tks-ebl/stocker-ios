#!/bin/sh
set -eu

if [ "$#" -ne 7 ]; then
  echo "Usage: ./deploy/azure/scripts/deploy-containerapp.sh <resource-group> <container-app-name> <container-app-env-id> <image-ref> <db-connection-string> <jwt-signing-key> <location>" >&2
  exit 1
fi

RESOURCE_GROUP="$1"
CONTAINER_APP_NAME="$2"
CONTAINER_APP_ENV_ID="$3"
IMAGE_REF="$4"
DB_CONNECTION_STRING="$5"
JWT_SIGNING_KEY="$6"
LOCATION="$7"

TMP_FILE="$(mktemp)"
trap 'rm -f "${TMP_FILE}"' EXIT

cat > "${TMP_FILE}" <<EOF
location: ${LOCATION}
name: ${CONTAINER_APP_NAME}
type: Microsoft.App/containerApps
properties:
  managedEnvironmentId: ${CONTAINER_APP_ENV_ID}
  configuration:
    ingress:
      external: true
      targetPort: 8080
      transport: auto
    secrets:
      - name: connection-strings-default
        value: ${DB_CONNECTION_STRING}
      - name: jwt-signing-key
        value: ${JWT_SIGNING_KEY}
  template:
    containers:
      - image: ${IMAGE_REF}
        name: stockerwebapi-api
        env:
          - name: ASPNETCORE_ENVIRONMENT
            value: Production
          - name: ASPNETCORE_HTTP_PORTS
            value: "8080"
          - name: ConnectionStrings__Default
            secretRef: connection-strings-default
          - name: Jwt__Issuer
            value: StockerWebAPI
          - name: Jwt__Audience
            value: StockerClients
          - name: Jwt__SigningKey
            secretRef: jwt-signing-key
          - name: Seed__EnableDemoSeed
            value: "false"
        probes:
          - type: Liveness
            httpGet:
              path: /health
              port: 8080
            initialDelaySeconds: 15
            periodSeconds: 20
          - type: Readiness
            httpGet:
              path: /health
              port: 8080
            initialDelaySeconds: 10
            periodSeconds: 15
        resources:
          cpu: 0.5
          memory: 1Gi
    scale:
      minReplicas: 1
      maxReplicas: 2
EOF

az containerapp create \
  --resource-group "${RESOURCE_GROUP}" \
  --name "${CONTAINER_APP_NAME}" \
  --yaml "${TMP_FILE}"

echo "Deployment requested for ${CONTAINER_APP_NAME}."

