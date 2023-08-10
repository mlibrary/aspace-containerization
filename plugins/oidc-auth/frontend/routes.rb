# frozen_string_literal: true

ArchivesSpace::Application.routes.draw do
  scope AppConfig[:frontend_proxy_prefix] do
    # OMNIAUTH GENERATED ROUTES:
    # OMNIAUTH:      /auth/:provider

    get '/auth/:provider/callback', to: 'oidc#create'
    post '/auth/:provider/callback', to: 'oidc#create'
    get '/auth/failure', to: 'oidc#failure'
    # get  '/auth/logout'
  end
end