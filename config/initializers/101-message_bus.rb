# MessageBus

# setup redis
MessageBus.redis_config = BuymaInsider.configuration.redis[:message_bus]

# disable long polling for now, webrick does not support partial rack hijack
MessageBus.long_polling_enabled = false

def setup_message_bus_env(env)
  hash = {
    extra_headers: {
      'Access-Control-Allow-Origin'      => BuymaInsider.base_url,
      'Access-Control-Allow-Methods'     => 'GET,POST',
      'Access-Control-Allow-Credentials' => 'true',
      'Access-Control-Allow-Headers'     => 'X-Silence-Logger,X-Shared-Session-Key,Dont-Chunk,Discourse-Visible,*'
    },
  }

  request = Rack::Request.new(env)
  if user_auth_token = UserAuthToken.find_by_cookie(request)
    hash['user_id'] = user_auth_token.user_id
  end

  env['__mb'] = hash
end

MessageBus.user_id_lookup do |env|
  setup_message_bus_env(env)
  env['__mb'][:user_id]
end

MessageBus.extra_response_headers_lookup do |env|
  setup_message_bus_env(env)
  env['__mb'][:extra_headers]
end

# ensure that if there is client
# then the middleware always appears top of the
# middleware chain