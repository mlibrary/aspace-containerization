# frozen_string_literal: true

class OidcController < ApplicationController
  skip_before_action :unauthorised_access
  skip_before_action :verify_authenticity_token
  
  # IMPLEMENTS: /auth/:provider/callback
  # Successful authentication populates the auth_hash with data
  # that is written to the system tmpdir. This is used to verify
  # the user for the backend and then deleted.
  def create
    p auth_hash
    $stdout.p auth_hash
    # pw = "oidc-auth-#{auth_hash[:provider]}-#{SecureRandom.uuid}"
    # pw_path = File.join(Dir.tmpdir, pw)
    # puts auth_hash

    #   backend_session = nil
    #   email = AspaceOauth.get_email(auth_hash)
    #   username = AspaceOauth.use_uid? ? auth_hash.uid : email

    #   puts "Received callback for user: #{username}"

    #   if email && username
    #     username = username.split('@').first unless AspaceOauth.username_is_email?
    #     auth_hash[:info][:username] = username.downcase # checked in backend
    #     auth_hash[:info][:email]    = email # ensure email is set in info
    #     File.open(pw_path, 'w') { |f| f.write(JSON.generate(auth_hash)) }
    #     backend_session = User.login(username, pw)
    #   end

    #   if backend_session
    #     User.establish_session(self, backend_session, username)
    #     load_repository_list
    #   else
    #     flash[:error] = 'Authentication error, unable to login.'
    #   end

    #   File.delete pw_path if File.exist? pw_path
    #   redirect_to controller: :welcome, action: :index
  end
  
  def failure
    flash[:error] = params[:message]
    redirect_to controller: :welcome, action: :index
  end

  def oidc_logout
    reset_session
    redirect_to "https://shibboleth.umich.edu/cgi-bin/logout?https://lib.umich.edu/"
  #   redirect_to AspaceOauth.saml_logout_url
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
