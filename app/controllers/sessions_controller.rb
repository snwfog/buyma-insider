class SessionsController < ApplicationController
  options '/**' do; end
  # # For testing purpose
  # get '/' do
  #   call env.merge('REQUEST_METHOD' => 'POST')
  # end

  # Create the session
  post '/' do
    # param :username, String, required:  true,
    #                          transform: :downcase
    # param :password, String, required: true
    #
    # username, password = params.values_at('username', 'password')

    request.body.rewind
    payload            = JSON.parse(request.body.read)
    user_hash          = extract_attributes(payload)
    username, password = user_hash.values_at(:login, :password)

    begin
      user = User.where(username: username).first or raise UserNotFound
      user.validate_password!(password)
    rescue
      # error(400, { error: 'login.invalid_username_or_password' }.to_json)
      raise
    else
      session_token = post_authenticate!(user)
      status :created
      json session_token, include: ''
    end
  end
end
