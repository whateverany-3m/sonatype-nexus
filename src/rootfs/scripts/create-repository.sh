#!/bin/bash
set -x
echo "INFO: BEGIN ${0}"

SCRIPT="${1}"
echo "INFO: SCRIPT=${SCRIPT}"


NEXUS_USERNAME="${NEXUS_USERNAME:-admin}"
NEXUS_PASSWORD="${NEXUS_PASSWORD:-admin123}"
NEXUS_URL="${NEXUS_URL:-http://localhost:8081}"
  
cd /scripts || exit

./delete.sh "${SCRIPT}" || true
./create.sh "${SCRIPT}.json"
./run.sh "${SCRIPT}"
./delete.sh "${SCRIPT}"

echo "INFO: END ${0}."

