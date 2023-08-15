# frozen_string_literal: true

oidc_definition = AppConfig[:authentication_sources].find do |as|
  as[:model] == "OIDCAuth"
end

if oidc_definition.nil?
  raise "OIDCAuth plugin is enabled but no definition was found."
end

# This is used in UI template files
AppConfig[:oidc_definition] = oidc_definition
ArchivesSpace::Application.extend_aspace_routes(
  File.join(File.dirname(__FILE__), "routes.rb")
)

require "omniauth"
require "omniauth_openid_connect"

Rails.application.config.middleware.use OmniAuth::Builder do
  config = oidc_definition[:config]
  provider oidc_definition[:provider], config
  $stdout.puts "Registered #{oidc_definition[:provider]} provider with config: #{config}"
end
