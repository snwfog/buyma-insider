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
end
  
