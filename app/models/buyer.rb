# == Schema Information
#
# Table name: buyers
#
#  id            :integer          not null, primary key
#  email_address :string(1000)
#  first_name    :string(500)
#  last_name     :string(500)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Buyer < ActiveRecord::Base
  # https://stackoverflow.com/questions/22993545/ruby-email-validation-with-regex
  SIMPLE_EMAIL_VALIDATION_REGEX = /\A[a-zA-Z0-9!#\$%&'*+\/=?\^_`{|}~\-]+(?:\.[a-zA-Z0-9!#\$%&'\*+\/=?\^_`{|}~\-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9\-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9\-]*[a-zA-Z0-9])?$\z/

  validates_format_of :email_address, with: SIMPLE_EMAIL_VALIDATION_REGEX
end
  
