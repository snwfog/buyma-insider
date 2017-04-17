require_relative '../setup'

describe UserSessionToken do
  let(:user) { get_user.tap(&:save!) }
  
  it 'should allow different token per user' do
    expect do
      UserSessionToken.create!(user: user, token: SecureRandom.hex(16))
      UserSessionToken.create!(user: user, token: SecureRandom.hex(16))
    end.to_not raise_error
  end
  
  it 'should be unique per user per token' do
    token_key    = SecureRandom.hex(16)
    user_session = UserSessionToken.new(user: user, token: token_key)
    expect(user_session.valid?).to be(true)
    user_session.save!
    
    user_session = UserSessionToken.new(user: user, token: token_key)
    expect(user_session.valid?).to be(false)
    expect(user_session.errors.full_messages).to include('Token has already been taken')
  end
end