#!/bin/bash
set -x
echo "INFO: BEGIN ${0}"

NEXUS_PASSWORD_FILE="${NEXUS_PASSWORD_FILE:-/nexus-data/admin.password}"
WAIT_COUNT=0
WAIT_MAX=360
echo "INFO: looping until NEXUS_PASSWORD_FILE='${NEXUS_PASSWORD_FILE}' is created or WAIT_COUNT > ${WAIT_MAX}"
while [ ! -e "${NEXUS_PASSWORD_FILE}" ]; do
  echo "INFO: WAIT_COUNT=${WAIT_COUNT}"
  WAIT_COUNT=$((WAIT_COUNT+1))
  if [ "${WAIT_COUNT}" -gt "${WAIT_MAX}" ];then
    echo "ERROR: WAIT_COUNT=${WAIT_COUNT} -gt ${WAIT_MAX}"
    exit 1
  fi
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
    curl -i -v -u "${NEXUS_USERNAME}:${NEXUS_PASSWORD}" \
      -X DELETE \
      "${NEXUS_URL}/service/rest/v1/repositories/${REPO}" || true
  done

echo "INFO: run scripts"
/scripts/run_scripts.sh

echo "INFO: make apt-local"
/scripts/make_apt-local.sh


echo "INFO: make groups"
/scripts/make_groups.sh

echo "INFO: END ${0}."

