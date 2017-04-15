class UserSerializer < ActiveModel::Serializer
  attributes :username,
             :created_at,
             :updated_at
end