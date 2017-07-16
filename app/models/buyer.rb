#
class Buyer
  # https://stackoverflow.com/questions/22993545/ruby-email-validation-with-regex
  SIMPLE_EMAIL_VALIDATION_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  
  field :first_name,    type:   String,
                        index:  true,
                        format: /[\w]+/
  field :last_name,     type:   String,
                        index:  true,
                        format: /[\w]+/
  field :email_address, type:   String,
                        index:  true,
                        unique: true,
                        format: SIMPLE_EMAIL_VALIDATION_REGEX
end