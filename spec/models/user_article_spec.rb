require_relative '../setup'

describe UserArticle do
  # This turns out to be a bad idea...
  # it 'should not be instantiable' do
  #   expect { UserArticle.new }.to raise_error('NonInstantiableDocument')
  # end
  
  describe UserWatchedArticle do
    it 'should respect uniqueness scope per article and per type' do
      user    = get_user.tap(&:save!)
      article = get_article.tap(&:save!)
      
      user.watch!(article)
      expect { user.watch!(article) }.to raise_error(NoBrainer::Error::DocumentInvalid, /has already been taken/)
    end
    
    it 'should eager load user' do
      user = get_user
      user.save
      
      article = get_article
      article.save
      
      UserWatchedArticle.create!(user:    user,
                                 article: article)
      
      expect(article).to include(user)
    end
    
    it 'should validates' do
      article = get_article
      user    = get_user
      
      article.save!
      user.save!
      
      user_wa = UserWatchedArticle.new(article: article, user: user)
      expect(user_wa.valid?).to be_falsey
      expect(user_wa.errors.full_messages.first).to match(/criteria can't be blank/)
    end
  end
  
  describe UserNotifiedArticle do
    it 'should enforce uniqueness per user/article/date' do
      user = get_user
      user.save!
      
      article = get_article
      article.save!
      
      user_notified_article = UserNotifiedArticle.new(user:    user,
                                                      article: article)
      
      expect(user_notified_article.valid?).to eq(true)
      user_notified_article.save!
      
      user_notified_article = UserNotifiedArticle.new(user:    user,
                                                      article: article)
      
      expect(user_notified_article.valid?).to eq(false)
      expect(user_notified_article.errors[:base].join).to match(/must be compositely unique/)
    end
  end
end