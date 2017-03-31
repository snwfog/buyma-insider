require_relative '../setup'

describe UserWatchedArticleWorker do
  let(:user) { user = get_user.tap(&:save!) }
  let(:article) { article = get_article.tap(&:save!) }
  
  it 'should notify' do
    user.watch!(article)
    article.update_price_history!
    
    current_price = article.price;
    article.price = current_price * 0.80
    article.save!
    article.update_price_history!
    
    UserWatchedArticleWorker.new.perform(article.id)
    
    user_notified_article = UserNotifiedArticle
                              .where(article: article,
                                     user:    user)
                              .where(_type: :UserNotifiedArticle)
    expect(user_notified_article.count).to eq(1)
  end
  
  it 'should unique notify article on user/article/notified_date' do
    user.watch!(article)
    article.update_price_history!
    
    article.price *= 0.80
    article.save!
    article.update_price_history!
    
    UserWatchedArticleWorker.new.perform(article.id)
    
    article.price *= 0.80
    article.save!
    
    UserWatchedArticleWorker.new.perform(article.id)
    
    user_notified_article = UserNotifiedArticle
                              .where(article: article,
                                     user:    user)
                              .where(_type: :UserNotifiedArticle)
    expect(user_notified_article.count).to eq(1)
  end
end