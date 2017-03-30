require_relative '../setup'

describe UserWatchedArticleWorker do
  let(:article) { article = get_article; article.save!; article }
  let(:user) { user = get_user; user.save!; user }
  
  it 'should notify' do
    user.watch!(article,
                [DiscountPercentArticleNotificationCriterium
                   .where(threshold_pct: 20)
                   .first_or_create!])
    current_price = article.price;
    article.price = current_price * 0.80
    article.save!
    article.update_price_history!
    
    user_notified_article = UserNotifiedArticle
                              .where(article: article, user: user)
                              .where(_type: :UserNotifiedArticle)
                              .to_a
    
    expect(user_notified_article.count).to be = 1
  end
end