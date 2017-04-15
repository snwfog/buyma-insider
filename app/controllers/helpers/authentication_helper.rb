module AuthenticationHelper
  SESSION_KEY      ||= '_t'.freeze
  CURRENT_USER_KEY ||= '_CURRENT_USER_KEY'.freeze
  
  class UserNotFound < RuntimeError; end
  class InvalidPassword < RuntimeError; end
  
  def post_authenticate!(user)
    @env        = Rack::Request.new(env)
    session_key = SecureRandom.hex(16)
    
    cookies[SESSION_KEY] = session_key
  end
end
  
  
  
