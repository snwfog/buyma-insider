class BuyerSerializer < ActiveModel::Serializer
  attributes :id,
             :first_name,
             :last_name,
             :email_address
end