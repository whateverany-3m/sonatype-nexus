#!/bin/sh
set -x

#
# Use our nexus.properties if required
#
NEXUS_PROPS_SRC="${NEXUS_PROPS_SRC:-/nexus.properties}"
NEXUS_PROPS_DEST="${NEXUS_PROPS_DEST:-/nexus-data/etc/nexus.properties}"
echo "INFO: checking for NEXUS_PROPS_DEST='${NEXUS_PROPS_DEST}'"
if [ ! -e "${NEXUS_PROPS_DEST}" ]; then
  echo "INFO: cp 'NEXUS_PROPS_SRC=${NEXUS_PROPS_SRC}' 'NEXUS_PROPS_DEST=${NEXUS_PROPS_DEST}'"
  NEXUS_PROPS_DIR=$(dirname "${NEXUS_PROPS_DEST}")
  if [ ! -d "${NEXUS_PROPS_DIR}" ] ; then
    mkdir -p "${NEXUS_PROPS_DIR}"
  fi
  cp "${NEXUS_PROPS_SRC}" "${NEXUS_PROPS_DEST}"
fi

#
# if NEXUS_INIT does not exist, run NEXUS_INIT_SCRIPT
#
NEXUS_INIT="${NEXUS_INIT:=/nexus-data/init.sh.nohup}"
echo "INFO: checking for NEXUS_INIT='${NEXUS_INIT}'"
if [ ! -e "${NEXUS_INIT}" ]; then
  NEXUS_INIT_SCRIPT="${NEXUS_INIT_SCRIPT:=/scripts/init.sh}"
  echo "INFO: running NEXUS_INIT_SCRIPT='${NEXUS_INIT_SCRIPT}'"
  nohup "${NEXUS_INIT_SCRIPT}" > "${NEXUS_INIT}" 2>&1 &
fi

exec "$@"
