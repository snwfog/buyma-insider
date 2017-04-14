require_relative '../setup'

describe User do
  let(:user) { get_user.tap(&:save!) }
  let(:article) { get_article.tap(&:save!) }
  
  describe '#watch!' do
    it 'should respect uniqueness' do
      user.watch!(article)
      expect { user.watch!(article) }.to raise_error(
                                           NoBrainer::Error::DocumentInvalid,
                                           /has already been taken/)
    end
    
    it 'should create with default criterium' do
      user.watch!(article)
      uw_article = user.user_watched_articles.first
      expect(uw_article.article_notification_criteria.length).to eq(1)
      
      article_criterium = uw_article
                            .article_notification_criteria
                            .first
      
      expect(article_criterium).to be_a(DiscountPercentArticleNotificationCriterium)
      expect(article_criterium).to eq(DiscountPercentArticleNotificationCriterium
                                        .where(threshold_pct: 20)
                                        .first)
    end
  end
  
  describe '#destroy articles' do
    it 'destroy user watched article' do
      uw_articles = Array.new(3) do
        UserWatchedArticle.create!(user:    user,
                                   article: get_article.tap(&:save))
      end
      
      expect(user.user_watched_articles.count).to eq(3)
      to_destroy_uw = uw_articles.sample
      user.destroy_user_watched_article!(to_destroy_uw.article)
      user.user_watched_articles.reload
      
      expect(user.user_watched_articles.count).to eq(2)
    end
  end
end