host_url = "$HOST_URL"

AppConfig[:db_url] = "$APPCONFIG_DB_URL"
AppConfig[:solr_url] = "$APPCONFIG_SOLR_URL"

AppConfig[:backend_url] = "#{host_url}:8089"
AppConfig[:frontend_url] = "#{host_url}:8080"
AppConfig[:public_url] = "#{host_url}:8081"
AppConfig[:oai_url] = "#{host_url}:8082"
AppConfig[:indexer_url] = "#{host_url}:8091"
AppConfig[:docs_url] = "#{host_url}:8888"

AppConfig[:frontend_log] = "/archivesspace/logs/archivesspace.out"
AppConfig[:frontend_log_level] = "warn"
AppConfig[:backend_log] = "/archivesspace/logs/archivesspace.out"
AppConfig[:backend_log_level] = "warn"
AppConfig[:pui_log] = "/archivesspace/logs/archivesspace.out"
AppConfig[:pui_log_level] = "info"
AppConfig[:indexer_log] = "/archivesspace/logs/archivesspace.out"
AppConfig[:indexer_log_level] = "info"

AppConfig[:authentication_sources] = [
  {
    model: 'ASOauth',
    label: 'U-M WebLogin',
    provider: :openid_connect,
    config: {
      issuer: "$OIDC_ISSUER",
      discovery: true,
      client_auth_method: 'jwks',
      scope: [:openid, :email, :profile],
      client_options: {
        identifier: "$OIDC_CLIENT_ID",
        secret: "$OIDC_CLIENT_SECRET",
        redirect_uri: "#{host_url}:8080/auth/openid_connect/callback"
      }
    }
  }
]

AppConfig[:plugins] << "aspace-oauth"
