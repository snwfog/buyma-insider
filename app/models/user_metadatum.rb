class UserMetadatum
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  
  belongs_to :user, index:    true,
                    required: true,
                    unique:   true

  field :id,            primary_key: true

  field :last_name,     type:        String,
                        required:    true,
                        max_length:  250
  
  field :first_name,    type:        String,
                        required:    true,
                        max_length:  250
  
  field :email_address, type:       String,
                        required:   true,
                        index:      true


  validate :email_address, :valid_email_address?
  
  def valid_email_address?
    Mail::Address.new(email_address)
  rescue
    errors.add(:base, 'Email address format is invalid')
  end
end