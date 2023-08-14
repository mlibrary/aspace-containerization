#!/bin/bash

DATA_TMP_DIR="${DATA_DIR:-"/archivesspace/data"}/tmp"

# clear out tmp pre-startup as it can build up if persisted
rm -rf $DATA_TMP_DIR/*

# export APPCONFIG prefixed environment variables
export APPCONFIG_DB_URL="${DB_URL}"
export APPCONFIG_SOLR_URL="${SOLR_URL}"
export APPCONFIG_HOST_URL="${HOST_URL}"

export APPCONFIG_BACKEND_URL="${HOST_URL}:8089"
export APPCONFIG_FRONTEND_URL="${HOST_URL}:8080"
export APPCONFIG_PUBLIC_URL="${HOST_URL}:8081"
export APPCONFIG_OAI_URL="${HOST_URL}:8082"
export APPCONFIG_INDEXER_URL="${HOST_URL}:8091"
export APPCONFIG_DOCS_URL="${HOST_URL}:8888"

export APPCONFIG_FRONTEND_LOG="/archivesspace/logs/archivesspace.out"
export APPCONFIG_FRONTEND_LOG_LEVEL="warn"
export APPCONFIG_BACKEND_LOG="/archivesspace/logs/archivesspace.out"
export APPCONFIG_BACKEND_LOG_LEVEL="warn"
export APPCONFIG_PUI_LOG="/archivesspace/logs/archivesspace.out"
export APPCONFIG_PUI_LOG_LEVEL="info"
export APPCONFIG_INDEXER_LOG="/archivesspace/logs/archivesspace.out"
export APPCONFIG_INDEXER_LOG_LEVEL="info"

/archivesspace/scripts/setup-database.sh
if [[ "$?" != 0 ]]; then
  echo "Error running the database setup script."
  exit 1
fi

exec /archivesspace/archivesspace.sh
