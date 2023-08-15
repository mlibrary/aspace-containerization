# frozen_string_literal: true

class OidcController < ApplicationController
  skip_before_action :unauthorised_access
  skip_before_action :verify_authenticity_token

  # IMPLEMENTS: /auth/:provider/callback
  # Successful authentication populates the auth_hash with data
  # that is written to the system tmpdir. This is used to verify
  # the user for the backend and then deleted.
  def create
    pw = "oidc-auth-#{auth_hash[:provider]}-#{SecureRandom.uuid}"
    pw_path = File.join(Dir.tmpdir, pw)

    backend_session = nil
    username = auth_hash["uid"]
    email = auth_hash[:info][:email]
    name = auth_hash[:info][:name]
    puts "Received callback for user: #{username}"

    if username && email
      username = username.downcase
      user_data = {username: username, email: email, name: name}
      File.write(pw_path, JSON.generate(user_data))
      backend_session = User.login(username, pw)
    end

    if backend_session
      User.establish_session(self, backend_session, username)
      load_repository_list
    else
      flash[:error] = "Authentication error, unable to login."
    end

    File.delete pw_path if File.exist? pw_path
    redirect_to controller: :welcome, action: :index
  end

  def failure
    flash[:error] = params[:message]
    redirect_to controller: :welcome, action: :index
  end

  def logout
    reset_session
    redirect_to "https://shibboleth.umich.edu/cgi-bin/logout?https://lib.umich.edu/"
  end

  protected

  def auth_hash
    request.env["omniauth.auth"]
  end
end
