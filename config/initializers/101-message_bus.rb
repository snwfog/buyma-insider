# MessageBus
# Setup Redis
MessageBus.redis_config = BuymaInsider
                            .configuration
                            .redis[:message_bus]

# Ensure that if there is client
# then the middleware always appears top of the
# middleware chain