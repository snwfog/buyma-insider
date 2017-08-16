# == Schema Information
#
# Table name: user_auth_tokens
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  token      :string(500)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserAuthTokenSerializer < ActiveModel::Serializer
  belongs_to :user do
    include_data true
  end
  
  attributes :id,
             :created_at,
             :updated_at
end
