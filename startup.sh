#!/bin/bash

DATA_TMP_DIR="${DATA_DIR:-"/archivesspace/data"}/tmp"

# clear out tmp pre-startup as it can build up if persisted
rm -rf $DATA_TMP_DIR/*

# substitute environment variables in AppConfig template file
envsubst < /archivesspace/app_config.rb > /archivesspace/config/config.rb

cat /archivesspace/config/config.rb

/archivesspace/scripts/setup-database.sh
if [[ "$?" != 0 ]]; then
  echo "Error running the database setup script."
  exit 1
fi

exec -c /archivesspace/archivesspace.sh
