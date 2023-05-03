#!/bin/bash

DATA_TMP_DIR="${DATA_DIR:-"/archivesspace/data"}/tmp"

# clear out tmp pre-startup as it can build up if persisted
rm -rf $DATA_TMP_DIR/*

# substitute environment variables in AppConfig template file
export APPCONFIG_DB_URL="${DB_URL:="jdbc:mysql://db:3306/archivesspace?user=as&password=as123&useUnicode=true&characterEncoding=UTF-8"}"
export APPCONFIG_SOLR_URL="${SOLR_URL:="http://solr:8983/solr/archivesspace"}"
export APPCONFIG_HOST_URL="${HOST_URL:="http://app"}"
envsubst < /archivesspace/app_config.rb > /archivesspace/config/config.rb

/archivesspace/scripts/setup-database.sh
if [[ "$?" != 0 ]]; then
  echo "Error running the database setup script."
  exit 1
fi

exec -c /archivesspace/archivesspace.sh
