module AuthenticationHelper
  SESSION_EXPIRE_TIME = 1.week.to_i # TODO: SiteSetting
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
      session_key = cookies[SESSION_KEY]
      raise InvalidSession unless session_key
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
    session_key = SecureRandom.hex(16)
    cookies.set(SESSION_KEY, cookie_hash(session_key))
    session_cache do |redis|
      redis.set(session_key, user, expires_in: SESSION_EXPIRE_TIME)
    end
    
    UserSessionToken
      .create!(user:  user,
               token: session_key)
  end
  
  def destroy_session!
    session_key = cookies[SESSION_KEY]
    raise InvalidSession unless session_key
    session_cache do |redis|
      redis.del(session_key)
    end
  end
  
  private
  
  def session_cached_user
    session_cache do |redis|
      session_key = cookies[SESSION_KEY]
      user        = redis.get(session_key)
      raise UserNotFound unless !!user
      redis.expire(session_key, SESSION_EXPIRE_TIME)
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
      expires:  SESSION_EXPIRE_TIME,
      secure:   false }
  end
end



