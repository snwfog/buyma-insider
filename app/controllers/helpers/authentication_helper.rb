module AuthenticationHelper
  SESSION_EXPIRE_TIME = '120s'.to_i
  SESSION_KEY         = '_t'.freeze
  CURRENT_USER_KEY    = '_CURRENT_USER_KEY'.freeze
  
  class UserNotFound       < RuntimeError; end
  class InvalidPassword    < RuntimeError; end
  class InvalidSession     < RuntimeError; end
  class NotAuthenticated   < RuntimeError; end

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
      get_cached_session_user
    end
  end
  
  def current_user?
    current_user
  rescue Exception => ex
    logger.error { ex }
    nil
  end
  
  def post_authenticate!(user)
    @env        = Rack::Request.new(env)
    session_key = SecureRandom.hex(16)
    cookies.set(SESSION_KEY, cookie_hash(session_key))
    session_cache do |redis|
      redis.set(session_key, user, expires_in: SESSION_EXPIRE_TIME)
    end
  
    UserSessionToken
      .create!(user:  user,
               token: session_key)
  end
  
  private
  
  def get_cached_session_user
    session_cache do |redis|
      session_key = cookies[SESSION_KEY]
      redis.get(session_key)
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
      secure:   false }
  end
end



