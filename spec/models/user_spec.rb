# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  username      :string(100)      not null
#  email_address :string(1000)     not null
#  password_hash :string(500)      not null
#  last_seen_at  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

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
      uw_article = user.user_article_watcheds.first
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
        UserArticleWatched.create!(user:    user,
                                   article: get_article.tap(&:save))
      end
      
      expect(user.user_article_watcheds.count).to eq(3)
      to_destroy_uw = uw_articles.sample
      user.destroy_user_article_watched!(to_destroy_uw.article)
      user.user_article_watcheds.reload
      
      expect(user.user_article_watcheds.count).to eq(2)
    end
  end
end
