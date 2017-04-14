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
end