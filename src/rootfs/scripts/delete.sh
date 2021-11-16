#!/bin/bash
set -x
echo "INFO: BEGIN ${0}"

NEXUS_USERNAME="${NEXUS_USERNAME:-admin}"
NEXUS_PASSWORD="${NEXUS_PASSWORD:-admin123}"
NEXUS_URL="${NEXUS_URL:-http://localhost:8081}"

NAME="${1}"
echo "INFO: NAME=${NAME}"

curl -i -v -u "${NEXUS_USERNAME}:${NEXUS_PASSWORD}" \
  -X DELETE \
  "${NEXUS_URL}/service/rest/v1/script/${NAME}"

echo "INFO: END ${0}."

