AppConfig[:host_url] = ENV["HOST_URL"]
AppConfig[:db_url] = ENV["DB_URL"]
AppConfig[:solr_url] = ENV["SOLR_URL"]
AppConfig[:frontend_proxy_url] = "#{ENV["FRONTEND_PROXY_URL"].delete_suffix('/')}/"

AppConfig[:backend_url] = "#{AppConfig[:host_url]}:8089"
AppConfig[:frontend_url] = "#{AppConfig[:host_url]}:8080"
AppConfig[:public_url] = "#{AppConfig[:host_url]}:8081"
AppConfig[:oai_url] = "#{AppConfig[:host_url]}:8082"
AppConfig[:indexer_url] = "#{AppConfig[:host_url]}:8091"
AppConfig[:docs_url] = "#{AppConfig[:host_url]}:8888"

AppConfig[:session_expire_after_seconds] = 28800

AppConfig[:frontend_log] = "/archivesspace/logs/archivesspace.out"
AppConfig[:frontend_log_level] = "warn"
AppConfig[:backend_log] = "/archivesspace/logs/archivesspace.out"
AppConfig[:backend_log_level] = "warn"
AppConfig[:pui_log] = "/archivesspace/logs/archivesspace.out"
AppConfig[:pui_log_level] = "warn"
AppConfig[:indexer_log] = "/archivesspace/logs/archivesspace.out"
AppConfig[:indexer_log_level] = "warn"

## Plug-ins to load. They will load in the order specified
#AppConfig[:plugins] = ['local', 'lcnaf'] (default)

AppConfig[:allow_password_reset] = false
AppConfig[:allow_user_registration] = false
AppConfig[:authentication_restricted_by_source] = true
AppConfig[:plugins] << "aspace-oauth"
oidc_issuer = ENV["OIDC_ISSUER"]
oidc_client_id = ENV["OIDC_CLIENT_ID"]
oidc_client_secret = ENV["OIDC_CLIENT_SECRET"]
oidc_end_session_endpoint = ENV["OIDC_END_SESSION_ENDPOINT"]
if oidc_issuer && oidc_client_id && oidc_client_secret && oidc_end_session_endpoint
  puts "OIDC settings were found; adding them to the configuration"
  AppConfig[:authentication_sources] = [
    {
      model: "ASOauth",
      label: "U-M WebLogin",
      provider: "openid_connect",
      config: {
        issuer: oidc_issuer,
        discovery: true,
        client_auth_method: "jwks",
        scope: [:openid, :email, :profile],
        uid_field: "preferred_username",
        client_options: {
          identifier: oidc_client_id,
          secret: oidc_client_secret,
          redirect_uri: "#{AppConfig[:frontend_proxy_url]}auth/openid_connect/callback",
          end_session_endpoint: "#{oidc_end_session_endpoint}?#{AppConfig[:frontend_proxy_url]}"
        }
      }
    }
  ]
end

AppConfig[:plugins] = AppConfig[:plugins] + ENV.fetch("PLUGINS", "").split(",").map { |x| x.strip }
