## Set your database name and credentials here.  Example:
## AppConfig[:db_url] = "jdbc:mysql://localhost:3306/archivesspace?user=as&password=as123&useUnicode=true&characterEncoding=UTF-8"
##
#AppConfig[:db_url] = proc { AppConfig.demo_db_url }
AppConfig[:db_url] = "jdbc:mysql://db:3306/archivesspace?user=as&password=as123&useUnicode=true&characterEncoding=UTF-8"

## The ArchivesSpace backend listens on port 8089 by default.  You can set it to
## something else below.
#AppConfig[:backend_url] = "http://localhost:8089"
AppConfig[:backend_url] = "http://app:8089"

## The ArchivesSpace staff interface listens on port 8080 by default.  You can
## set it to something else below.
#AppConfig[:frontend_url] = "http://localhost:8080"
AppConfig[:frontend_url] = "http://app:8080"

## The ArchivesSpace public interface listens on port 8081 by default.  You can
## set it to something else below.
#AppConfig[:public_url] = "http://localhost:8081"
AppConfig[:public_url] = "http://app:8081"

## The ArchivesSpace OAI server listens on port 8082 by default.  You can
## set it to something else below.
#AppConfig[:oai_url] = "http://localhost:8082"
AppConfig[:oai_url] = "http://app:8082"

## The ArchivesSpace Solr index url default.  You can set it to something else below.
#AppConfig[:solr_url] = "http://localhost:8983/solr/archivesspace"
AppConfig[:solr_url] = "http://solr:8983/solr/archivesspace"

## The ArchivesSpace indexer listens on port 8091 by default.  You can
## set it to something else below.
#AppConfig[:indexer_url] = "http://localhost:8091"
AppConfig[:indexer_url] = "http://app:8091"

## The ArchivesSpace API documentation listens on port 8888 by default.  You can
## set it to something else below.
#AppConfig[:docs_url] = "http://localhost:8888"
AppConfig[:docs_url] = "http://app:8888"

## Logging. By default, this will be output on the screen while the archivesspace
## command is running. When running as a daemon/service, this is put into a
## file in logs/archivesspace.out. You can change this file by changing the log
## value to a filepath that archivesspace has write access to.
## Log level values: (everything) debug, info, warn, error, fatal (severe only)

#AppConfig[:frontend_log] = "default"
AppConfig[:frontend_log] = "/archivesspace/logs/archivesspace.out"
#AppConfig[:frontend_log_level] = "debug"
AppConfig[:frontend_log_level] = "warn"

## Log level for the backend, values: (everything) debug, info, warn, error, fatal (severe only)
#AppConfig[:backend_log] = "default"
AppConfig[:backend_log] = "/archivesspace/logs/archivesspace.out"
#AppConfig[:backend_log_level] = "debug"
AppConfig[:backend_log_level] = "warn"

## Log level for the OAI-PMH server, values: (everything) debug, info, warn, error, fatal (severe only)
#AppConfig[:pui_log] = "default"
AppConfig[:pui_log] = "/archivesspace/logs/archivesspace.out"
#AppConfig[:pui_log_level] = "info"
AppConfig[:pui_log_level] = "info"

## Log level for the indexer, values: (everything) debug, info, warn, error, fatal (severe only)
#AppConfig[:indexer_log] = "default"
AppConfig[:indexer_log] = "/archivesspace/logs/archivesspace.out"
#AppConfig[:indexer_log_level] = "debug"
AppConfig[:indexer_log_level] = "info"
