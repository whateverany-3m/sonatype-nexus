#!/bin/bash
set -x
echo "INFO: BEGIN ${0}"

SCRIPT_NAME=myscript


for GROUP_METHOD in docker:createDockerGroup go:createGolangGroup maven2:createMavenGroup npm:createNpmGroup nuget:createNugetGroup pypi:createPypiGroup raw:createRawGroup rubygems:createRubygemsGroup yum:createYumGroup ;\
  do
    GROUP=${GROUP_METHOD/:*}
    METHOD=${GROUP_METHOD#*:}

    REPOS=$(curl -s -u "${NEXUS_USERNAME}:${NEXUS_PASSWORD}" \
      -X 'GET' \
      --header "accept: application/json" \
      "${NEXUS_URL}/service/rest/v1/repositories" | \
      jq '.[] | select (.format == "'${GROUP}'") | select (.type == "proxy") | .name' | \
      sed -e ':a' -e '$!N;s/\n/ /;ta' -e "s/\" \"/','/g" -e "s/\"/'/g")
    if [ "${GROUP}" = "docker" ] ; then
      SCRIPT="repository.${METHOD}('${GROUP}',null,null,[${REPOS}])"
    else
      SCRIPT="repository.${METHOD}('${GROUP}',[${REPOS}])"
    fi

    echo "INFO: GROUP=${GROUP}"
    echo "INFO: METHOD=${METHOD}"
    echo "INFO: REPOS=${REPOS}"
    echo "INFO: SCRIPT=${SCRIPT}"

    echo "INFO: delete ${GROUP}"
    curl -i -v -u "${NEXUS_USERNAME}:${NEXUS_PASSWORD}" \
      -X DELETE \
      "${NEXUS_URL}/service/rest/v1/repositories/${GROUP}" || true

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

