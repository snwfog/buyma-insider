require_relative '../setup'

describe UserArticleNotified do
  let(:user) { get_user.tap(&:save!) }
  let(:article) { get_article.tap(&:save!) }

  # This is due to implementation of nobrainer first_or_create
  # The where clause turns notified_at to Time instead of Date
  # thus mess up the type of the field when called first_or_create
  it 'would disallow first_or_create' do
    expect { UserArticleNotified
               .where(user:        user,
                      article:     article,
                      notified_at: Time.now.to_date)
               .first_or_create! }.to raise_error NoBrainer::Error::DocumentInvalid
  end
  
  it 'should enforce uniqueness per user/article/date' do
    user_notified_article = UserArticleNotified.new(user:        user,
                                                    article:     article,
                                                    notified_at: Time.now.to_date)
    
    expect(user_notified_article.valid?).to eq(true)
    user_notified_article.save!
    
    user_notified_article = UserArticleNotified.new(user:        user,
                                                    article:     article,
                                                    notified_at: Time.now.to_date)
    
    expect(user_notified_article.valid?).to eq(false)
    expect(user_notified_article.errors.full_messages).to include(/Notified at has already been taken/)
  end
end
