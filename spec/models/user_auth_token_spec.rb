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

require_relative '../setup'

describe UserAuthToken do
  let(:user) { get_user.tap(&:save!) }
  
  it 'should allow different token per user' do
    expect do
      UserAuthToken.create!(user:  user,
                            token: Digest::SHA1.base64digest(SecureRandom.hex(16)))
      UserAuthToken.create!(user:  user,
                            token: Digest::SHA1.base64digest(SecureRandom.hex(16)))
    end.to_not raise_error
  end
  
  it 'should be unique per user per token' do
    hashed_token    = Digest::SHA1.base64digest(SecureRandom.hex(16))
    user_auth_token = UserAuthToken.new(user: user, token: hashed_token)
    expect(user_auth_token.valid?).to be(true)
    user_auth_token.save!
    
    user_auth_token = UserAuthToken.new(user: user, token: hashed_token)
    expect(user_auth_token.valid?).to be(false)
    expect(user_auth_token.errors.full_messages).to include('Token has already been taken')
  end
end
