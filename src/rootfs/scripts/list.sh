#!/bin/bash
set -x
echo "INFO: BEGIN ${0}"

NEXUS_USERNAME="${NEXUS_USERNAME:-admin}"
NEXUS_PASSWORD="${NEXUS_PASSWORD:-admin123}"
NEXUS_URL="${NEXUS_URL:-http://localhost:8081}"

curl -i -v -u "${NEXUS_USERNAME}:${NEXUS_PASSWORD}" \
  "${NEXUS_URL}/service/rest/v1/script"

echo "INFO: END ${0}."

