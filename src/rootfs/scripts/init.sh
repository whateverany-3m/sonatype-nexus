#!/bin/bash
set -x
echo "INFO: BEGIN ${0}"

NEXUS_PASSWORD_FILE="${NEXUS_PASSWORD_FILE:-/nexus-data/admin.password}"
echo "INFO: looping until NEXUS_PASSWORD_FILE='${NEXUS_PASSWORD_FILE}' is created"
while [ ! -e "${NEXUS_PASSWORD_FILE}" ]; do
  echo "INFO: DATETIME=$(date '+%Y%m%d-%H%M%S')"
  sleep 1
done

NEXUS_INIT_PASSWORD=$(cat "${NEXUS_PASSWORD_FILE}")
NEXUS_LOG_FILE="${NEXUS_DATA}/log/nexus.log"

tail -99999f "${NEXUS_LOG_FILE}" | grep -m 1 "Started Sonatype Nexus OSS"
NEXUS_USERNAME="${NEXUS_USERNAME:-admin}"
NEXUS_PASSWORD="${NEXUS_PASSWORD:-admin123}"
NEXUS_URL="${NEXUS_URL:-http://localhost:8081}"
  
curl -ifu admin:"${NEXUS_INIT_PASSWORD}" \
  -XPUT -H 'Content-Type: text/plain' \
  --data "${NEXUS_PASSWORD}" \
  "${NEXUS_URL}/service/rest/v1/security/users/admin/change-password"

cd /scripts || exit

echo "INFO: remove default repos"
for REPO in \
  maven-central \
  maven-internal \
  maven-public \
  maven-releases \
  maven-snapshots  \
  nuget-group \
  nuget-hosted \
  nuget.org-proxy
  do
    ./delete-repository.sh "${REPO}" || true
  done

for TEMPLATE in json/*.json.template ;\
  do
    JSON="${TEMPLATE%.template}"
    echo "INFO: creating repo ${REPO}"
done

echo "INFO: create repos"
for JSON in json/*.json ;\
  do
    ./create-repository.sh "${REPO}"
done

echo "INFO: END ${0}."

