class SessionsController < ApplicationController
  # Create the session
  get '/' do
    param :username, String, required:  true,
                             transform: :downcase
    param :password, String, required: true

    username, password = params.values_at('username', 'password')
    begin
      user = User.where(username: username).first
      raise UserNotFound unless user
      raise InvalidPassword unless BCrypt::Password.new(user.password_hash) == password
    rescue
      { error: 'login.invalid_username_or_password' }.to_json
    else
      post_authenticate!(user)
      json user
    end
  end
end