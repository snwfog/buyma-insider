class UserSessionToken
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  belongs_to :user, index:    true,
                    required: true

  field :id,      primary_key: true
  
  field :user_id, unique:      { scope: [:token] }
  
  field :token,   type:        String,
                  format:      %r{[0-9a-z]{32}},
                  unique:      true,
                  required:    true
end