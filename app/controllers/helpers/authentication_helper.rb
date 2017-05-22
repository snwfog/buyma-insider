module AuthenticationHelper
  SESSION_EXPIRE_TIME = 1.week # TODO: SiteSetting
  SESSION_KEY         = '_t'.freeze
  CURRENT_USER_KEY    = '_CURRENT_USER_KEY'.freeze
  
  UserNotFound     = Class.new(RuntimeError)
  InvalidPassword  = Class.new(RuntimeError)
  InvalidSession   = Class.new(RuntimeError)
  NotAuthenticated = Class.new(RuntimeError)
  
  def ensure_user_authenticated!
    unless authenticated?
      error(401, { error: 'session.unauthenticated' }.to_json)
    end
  end
  
  def authenticated?
    !!current_user
  end

  def current_user
    @current_user ||= begin
      unhashed_token = cookies[SESSION_KEY]
      raise InvalidSession unless unhashed_token
      session_cached_user
    end
  end
  
  def current_user?
    current_user
  rescue Exception => ex
    logger.error { ex }
    nil
  end

  def post_authenticate!(user)
    # @env        = Rack::Request.new(env)
    unhashed_token = SecureRandom.hex(16)
    hashed_token   = hash_token(unhashed_token)
    cookies.set(SESSION_KEY, cookie_hash(unhashed_token))
    session_cache do |redis|
      redis.set(hashed_token, user,
                expires_in: SESSION_EXPIRE_TIME.to_i)
    end
  
    UserAuthToken
      .create!(user:  user,
               token: hashed_token)
  end

  def destroy_session!
    unhashed_token = cookies[SESSION_KEY]
    raise InvalidSession unless unhashed_token
    session_cache do |redis|
      redis.del(hash_token(unhashed_token))
    end
  end
  
  private

  SECRET = SecureRandom.hex(64) # TODO: GlobalSettings
  def hash_token(token)
    # Escape string table
    # https://github.com/ruby/ruby/blob/trunk/doc/syntax/literals.rdoc#strings
    Digest::SHA1.base64digest(token + SECRET)
  end

  def session_cached_user
    session_cache do |redis|
      unhashed_token = cookies[SESSION_KEY]
      hashed_token   = hash_token(unhashed_token)
      user           = redis.get(hashed_token)
      raise UserNotFound unless !!user
      redis.expire(hashed_token, SESSION_EXPIRE_TIME.to_i)
      user
    end
  end
  
  def session_cache
    $redis.with do |redis_store|
      redis_store.with_namespace(:session) do |redis|
        yield redis
      end
    end
  end
  
  def cookie_hash(value)
    { value:    value,
      httponly: true,
      path:     '/',
      expires:  SESSION_EXPIRE_TIME.from_now,
      secure:   false }
  end
end



