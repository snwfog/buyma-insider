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

class UserAuthToken < ActiveRecord::Base
  SECRET      = ENV['APP_SECRET']
  SESSION_KEY = '_t'.freeze

  belongs_to :user

  # Lookup the user by the cookie SESSION_KEY
  def self.find_by_cookie(request)
    if unhashed_token = request.cookies[SESSION_KEY]
      where(token: hash_token(unhashed_token)).take
    end
  end

  def self.hash_token(unhashed_token)
    # Escape string table
    # https://github.com/ruby/ruby/blob/trunk/doc/syntax/literals.rdoc#strings
    Digest::SHA1.base64digest(unhashed_token + SECRET)
  end
end
