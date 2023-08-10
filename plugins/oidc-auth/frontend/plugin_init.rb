# frozen_string_literal: true

oidc_definition = AppConfig[:authentication_sources].find do |as|
  as[:model] == 'OIDCAuth'
end

if oidc_definition.nil?
  raise 'OIDCAuth plugin is enabled but no definition was found.'
end

# also used for ui
AppConfig[:oidc_definition] = oidc_definition
ArchivesSpace::Application.extend_aspace_routes(
  File.join(File.dirname(__FILE__), 'routes.rb')
)
require 'omniauth'
require 'omniauth_openid_connect'

# OmniAuth::AuthenticityTokenProtection.default_options(key: "csrf.token", authenticity_param: "_csrf")

Rails.application.config.middleware.use OmniAuth::Builder do
  config = oidc_definition[:config]
  provider oidc_definition[:provider], config
  $stdout.puts "REGISTERED #{oidc_definition[:provider]} PROVIDER WITH CONFIG: #{config}"
end
