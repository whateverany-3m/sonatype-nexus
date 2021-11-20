#!/bin/bash
set -x
echo "INFO: BEGIN ${0}"

IFS=# read -ra NEXUS_SCRIPT_ARRAY <<< "${NEXUS_SCRIPTS}"

SCRIPT_NAME=myscript

for SCRIPT in ${NEXUS_SCRIPT_ARRAY[@]} ;\
  do
    echo "INFO: delete ${SCRIPT_NAME}"
    curl -i -v -u "${NEXUS_USERNAME}:${NEXUS_PASSWORD}" \
      -X DELETE \
      "${NEXUS_URL}/service/rest/v1/script/${SCRIPT_NAME}" || true

    echo "INFO: create ${SCRIPT_NAME}"
    curl -i -v -u "${NEXUS_USERNAME}:${NEXUS_PASSWORD}" \
      --header "Content-Type: application/json" \
      "${NEXUS_URL}/service/rest/v1/script/" \
      -d "{
  \"name\": \"${SCRIPT_NAME}\",
  \"type\": \"groovy\",
  \"content\": \"${SCRIPT}\"
}"

    echo "INFO: run ${SCRIPT_NAME}"
    curl -i -v -u "${NEXUS_USERNAME}:${NEXUS_PASSWORD}" \
      -X POST \
      --header "Content-Type: text/plain" \
      "${NEXUS_URL}/service/rest/v1/script/${SCRIPT_NAME}/run"

done

echo "INFO: END ${0}."

