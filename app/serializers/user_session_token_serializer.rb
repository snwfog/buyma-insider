class UserSessionTokenSerializer < ActiveModel::Serializer
  belongs_to :user do
    include_data true
  end
  
  attributes :id,
             :created_at,
             :updated_at
end