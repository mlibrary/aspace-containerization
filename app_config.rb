AppConfig[:db_url] = ENV.fetch('DB_URL')
AppConfig[:solr_url] = ENV.fetch('SOLR_URL')

AppConfig[:backend_url] = "#{ENV.fetch('HOST_URL')}:8089"
AppConfig[:frontend_url] = "#{ENV.fetch('HOST_URL')}:8080"
AppConfig[:public_url] = "#{ENV.fetch('HOST_URL')}:8081"
AppConfig[:oai_url] = "#{ENV.fetch('HOST_URL')}:8082"
AppConfig[:indexer_url] = "#{ENV.fetch('HOST_URL')}:8091"
AppConfig[:docs_url] = "#{ENV.fetch('HOST_URL')}:8888"

AppConfig[:frontend_log] = '/archivesspace/logs/archivesspace.out'
AppConfig[:frontend_log_level] = 'warn'
AppConfig[:backend_log] = '/archivesspace/logs/archivesspace.out'
AppConfig[:backend_log_level] = 'warn'
AppConfig[:pui_log] = '/archivesspace/logs/archivesspace.out'
AppConfig[:pui_log_level] = 'info'
AppConfig[:indexer_log] = '/archivesspace/logs/archivesspace.out'
AppConfig[:indexer_log_level] = 'info'
