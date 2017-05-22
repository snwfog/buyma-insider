class UserAuthToken
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
end