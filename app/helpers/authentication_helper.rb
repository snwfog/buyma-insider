module AuthenticationHelper
  SESSION_EXPIRE_TIME = 1.week # TODO: SiteSetting
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
  rescue InvalidSession, UserNotFound
    false
  end

  def current_user
    unhashed_token = cookies[UserAuthToken::SESSION_KEY]
    return nil unless unhashed_token
    current_user = session_cached_user
    # cache_user = session_cached_user
    # User.find(cache_user.id)

    if current_user.try(:persisted?)
      u = current_user
      Scheduler::Defer.later :update_last_seen do
        # u.update_column(last_seen_at: Time.now)
        u.touch(:last_seen_at)
      end
    end

    current_user
  end

  def post_authenticate!(user)
    # @env        = Rack::Request.new(env)
    unhashed_token = SecureRandom.hex(16)
    hashed_token   = UserAuthToken.hash_token(unhashed_token)
    cookies.set(UserAuthToken::SESSION_KEY, cookie_hash(unhashed_token))
    session_cache do |redis|
      redis.set(hashed_token,
                user,
                expires_in: SESSION_EXPIRE_TIME.to_i)
    end

    user.user_auth_tokens.create!(token: hashed_token)
  end

  def destroy_session!
    unhashed_token = cookies[UserAuthToken::SESSION_KEY]
    return nil unless unhashed_token
    session_cache do |redis|
      redis.del(UserAuthToken.hash_token(unhashed_token))
    end
  end

  private

  def session_cached_user
    session_cache do |redis|
      unhashed_token = cookies[UserAuthToken::SESSION_KEY]
      hashed_token   = UserAuthToken.hash_token(unhashed_token)
      user           = redis.get(hashed_token)
      if user
        redis.expire(hashed_token, SESSION_EXPIRE_TIME.to_i)
      end

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
