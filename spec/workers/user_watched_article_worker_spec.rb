require_relative '../setup'

describe UserArticleWatchedWorker do
  let(:user) { user = get_user.tap(&:save!) }
  let(:article) { article = get_article.tap(&:save!) }
  
  it 'should notify' do
    user.watch_article!(article)
    article.update_price_history!
    
    current_price = article.price;
    article.price = current_price * 0.80
    article.save!
    article.update_price_history!
    
    UserArticleWatchedWorker.new.perform(article.id)
    
    user_notified_article = UserArticleNotified
                              .where(article: article,
                                     user:    user)
                              .where(_type: :UserArticleNotified)
    expect(user_notified_article.count).to eq(1)
  end
  
  it 'should unique notify article on user/article/notified_date' do
    user.watch_article!(article)
    article.update_price_history!
    
    article.price *= 0.80
    article.save!
    article.update_price_history!
    
    UserArticleWatchedWorker.new.perform(article.id)
    
    article.price *= 0.80
    article.save!
    
    UserArticleWatchedWorker.new.perform(article.id)
    
    user_notified_article = UserArticleNotified
                              .where(article: article,
                                     user:    user)
                              .where(_type: :UserArticleNotified)
    expect(user_notified_article.count).to eq(1)
  end
end