# frozen_string_literal: true

class AsOIDCException < StandardError
end

class OIDCAuth
  include JSONModel

  def initialize opts
  end

  def name
    "ArchivesSpace OIDC Authentication"
  end

  def authenticate(username, password)
    return nil unless password.start_with?("oidc-auth-")

    pw_path = File.join(Dir.tmpdir, password)
    return nil unless File.exist? pw_path

    user_data_str = File.open(pw_path) do |f|
      f.read
    end
    user_data = JSON.parse(user_data_str)

    return nil if username != info['username'].downcase

    JSONModel(:user).from_hash(
      username: username,
      name: info['name'],
      email: info['email'],
      first_name: info['first_name'],
      last_name: info['last_name'],
      telephone: info['phone'],
      additional_contact: info['description']
    )
  end
end
