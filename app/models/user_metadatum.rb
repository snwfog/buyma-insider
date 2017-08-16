# == Schema Information
#
# Table name: user_metadata
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  first_name :string(500)
#  last_name  :string(500)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserMetadatum < ActiveRecord::Base
end
