# frozen_string_literal: true

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

    user_data = JSON.parse(File.read(pw_path))

    username_from_file = user_data["username"]
    return nil if username_from_file.nil?

    JSONModel(:user).from_hash(
      username: username,
      name: user_data["name"],
      email: user_data["email"],
      first_name: nil,
      last_name: nil,
      telephone: nil,
      additional_contact: nil
    )
  end
end
