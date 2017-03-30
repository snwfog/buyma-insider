require_relative '../setup'

describe UserArticle do
  # This turns out to be a bad idea...
  # it 'should not be instantiable' do
  #   expect { UserArticle.new }.to raise_error('NonInstantiableDocument')
  # end
  
  describe UserWatchedArticle do
    let(:user) { get_user.tap(&:save!) }
    let(:article) { get_article.tap(&:save!) }
  
    it 'should respect uniqueness scope per article and per type' do
      user.watch!(article)
      expect { user.watch!(article) }.to(raise_error(
                                           NoBrainer::Error::DocumentInvalid,
                                           /has already been taken/))
    end
    
    it 'should have many watched criteria' do
      user.watch!(article)
      uw_article = user.user_watched_articles.first
      expect(uw_article.article_notification_criteria.count).to eq(1)
      expect(uw_article.article_notification_criteria.first).to be_a(ArticleNotificationCriterium)
    end
    
    it 'should #notify' do
      user.watch!(article)
      uw_article = user.user_watched_articles.first
      expect(uw_article.should_notify?).to eq(false)
    end
    
    it 'should eager load user' do
      UserWatchedArticle.create!(user: user, article: article)
      expect(article).to include(user)
    end
    
    it 'should validates' do
      user_wa = UserWatchedArticle.new(article: article, user: user)
      expect(user_wa.valid?).to be_falsey
      expect(user_wa.errors.full_messages.first).to match(/criteria can't be blank/)
    end
  end
  
  describe UserNotifiedArticle do
    it 'should enforce uniqueness per user/article/date' do
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