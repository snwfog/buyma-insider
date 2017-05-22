class UserAuthToken
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  
  SECRET = SecureRandom.hex(64) # TODO: GlobalSettings

  belongs_to :user, index:    true,
                    required: true
  
  field :id,      primary_key: true
  field :user_id, unique:      { scope: [:token] }
  # Base64 Digest::SHA1
  field :token,   type:        String,
                  format:      %r{[0-9A-z=]{28}},
                  unique:      true,
                  required:    true
end