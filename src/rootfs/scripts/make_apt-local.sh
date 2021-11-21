#!/bin/sh
set -x
GPG_BATCH=$(mktemp)
echo "INFO: GPG_BATCH=${GPG_BATCH}"
trap '{ rm -f -- "${GPG_BATCH}"; }' EXIT

SCRIPT_NAME="${SCRIPT_NAME:-myscript}"
APT_NAME="${APT_NAME:-apt-local}"
NEXUS_USERNAME="${NEXUS_USERNAME:-admin}"
NEXUS_PASSWORD="${NEXUS_PASSWORD:-admin123}"

echo "Key-Type: default
Subkey-Type: default
Name-Real: admin
Name-Email: root@localhost
Expire-Date: 0
Passphrase: ${NEXUS_PASSWORD}
%commit" >> "${GPG_BATCH}"

gpg --batch --generate-key "${GPG_BATCH}"

GPG_KEY=$(gpg --export-secret-key --armor --passphrase "${NEXUS_PASSWORD}" --pinentry-mode=loopback )
echo "GPG_KEY=${GPG_KEY}"

echo "INFO: delete ${APT_NAME}"
curl -i -v -u "${NEXUS_USERNAME}:${NEXUS_PASSWORD}" \
  -X DELETE \
  "${NEXUS_URL}/service/rest/v1/repositories/${APT_NAME}" || true

echo "INFO: delete ${SCRIPT_NAME}"
curl -i -v -u "${NEXUS_USERNAME}:${NEXUS_PASSWORD}" \
  -X DELETE \
  "${NEXUS_URL}/service/rest/v1/script/${SCRIPT_NAME}" || true

JSON="{
  \"name\": \"${SCRIPT_NAME}\",
  \"type\": \"groovy\",
  \"content\": \"repository.createAptHosted('${APT_NAME}','${APT_NAME}','${GPG_KEY}','${NEXUS_PASSWORD}')\"
}"

JSON_CLEAN=$(echo ${JSON} | jq -a '.')

echo "INFO: create ${SCRIPT_NAME}"
curl -i -v -u "${NEXUS_USERNAME}:${NEXUS_PASSWORD}" \
  --header "Content-Type: application/json" \
  "${NEXUS_URL}/service/rest/v1/script/" \
  -d "${JSON_CLEAN}"

