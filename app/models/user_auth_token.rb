class UserAuthToken
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  belongs_to :user, index:    true,
                    required: true,
                    unique:   true
  
  
  field :id,    primary_key: true
  
  field :token, type:        String,
                format:      %r{[0-9a-z]{32}}
end