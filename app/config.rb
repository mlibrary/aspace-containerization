AppConfig[:host_url] = ENV["HOST_URL"]
AppConfig[:db_url] = ENV["DB_URL"]
AppConfig[:solr_url] = ENV["SOLR_URL"]

AppConfig[:backend_url] = "#{AppConfig[:host_url]}:8089"
AppConfig[:frontend_url] = "#{AppConfig[:host_url]}:8080"
AppConfig[:public_url] = "#{AppConfig[:host_url]}:8081"
AppConfig[:oai_url] = "#{AppConfig[:host_url]}:8082"
AppConfig[:indexer_url] = "#{AppConfig[:host_url]}:8091"
AppConfig[:docs_url] = "#{AppConfig[:host_url]}:8888"

AppConfig[:frontend_log] = "/archivesspace/logs/archivesspace.out"
AppConfig[:frontend_log_level] = "warn"
AppConfig[:backend_log] = "/archivesspace/logs/archivesspace.out"
AppConfig[:backend_log_level] = "warn"
AppConfig[:pui_log] = "/archivesspace/logs/archivesspace.out"
AppConfig[:pui_log_level] = "info"
AppConfig[:indexer_log] = "/archivesspace/logs/archivesspace.out"
AppConfig[:indexer_log_level] = "info"

oidc_issuer = ENV["OIDC_ISSUER"]
oidc_client_id = ENV["OIDC_CLIENT_ID"]
oidc_client_secret = ENV["OIDC_CLIENT_SECRET"]

if oidc_issuer && oidc_client_id && oidc_client_secret
  puts "OIDC settings were found; adding OIDC authentication to the configuration"

  AppConfig[:authentication_sources] = [
    {
      model: 'ASOauth',
      label: 'U-M WebLogin',
      provider: :openid_connect,
      config: {
        issuer: ENV["OIDC_ISSUER"],
        discovery: true,
        client_auth_method: 'jwks',
        scope: [:openid, :email, :profile],
        client_options: {
          identifier: ENV["OIDC_CLIENT_ID"],
          secret: ENV["OIDC_CLIENT_SECRET"],
          redirect_uri: "#{ENV["PUBLIC_URL"]}/auth/openid_connect/callback"
        }
      }
    }
  ]

  AppConfig[:plugins] << "aspace-oauth"
  AppConfig[:allow_user_registration] = false
end
