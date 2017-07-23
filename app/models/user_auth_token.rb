class UserAuthToken
  SECRET      = ENV['APP_SECRET']
  SESSION_KEY = '_t'.freeze

  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  belongs_to :user, index:    true,
                    required: true
  
  field :id,      primary_key: true
  field :user_id, unique:      { scope: [:token] }
  # Base64 Digest::SHA1
  field :token,   type:        String,
                  format:      %r{[A-Za-z0-9+/=]{28}},
                  unique:      true,
                  required:    true

  # Lookup the user by the cookie SESSION_KEY
  def self.find_by_cookie(request)
    unhashed_token = request.cookies[SESSION_KEY]
    if unhashed_token
      where(token: hash_token(unhashed_token)).first
    end
  end
  
  def self.hash_token(unhashed_token)
    # Escape string table
    # https://github.com/ruby/ruby/blob/trunk/doc/syntax/literals.rdoc#strings
    Digest::SHA1.base64digest(unhashed_token + SECRET)
  end
end