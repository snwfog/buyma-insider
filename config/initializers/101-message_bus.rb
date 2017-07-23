# MessageBus

# setup redis
MessageBus.redis_config = BuymaInsider.configuration.redis[:message_bus]

# disable long polling for now, webrick does not support partial rack hijack
MessageBus.long_polling_enabled = false

MessageBus.extra_response_headers_lookup do |env|
  { 'Access-Control-Allow-Origin'      => BuymaInsider.base_url,
    'Access-Control-Allow-Methods'     => 'GET,POST',
    'Access-Control-Allow-Credentials' => 'true',
    'Access-Control-Allow-Headers'     => 'X-SILENCE-LOGGER,X-Shared-Session-Key,Dont-Chunk, Discourse-Visible' }
end

# ensure that if there is client
# then the middleware always appears top of the
# middleware chain