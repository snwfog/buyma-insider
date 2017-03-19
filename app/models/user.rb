class User
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  has_one :user_auth_token,   dependent: :destroy
  
  has_one :user_metadatum,    dependent: :destroy

  field :id,            primary_key: true

  field :username,      type:        String,
                        required:    true,
                        max_length:  60

  field :password_hash, type:        String,
                        required:    true,
                        length:      (60..60)

  before_save :ensure_password_is_hashed
  
  def password=(password)
    unless password.blank?
      @raw_password = password
    end
  end
  
  def ensure_password_is_hashed
    if @raw_password
      self.password_hash = BCrypt::Password.new(@raw_password)
    end
  end
end