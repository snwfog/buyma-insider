require_relative '../setup'

describe UserWatchedArticle do
  let(:user) { get_user.tap(&:save!) }
  let(:article) { get_article.tap(&:save!) }
  
  it 'should respect uniqueness scope per article per user' do
    uw_article = UserWatchedArticle
                   .new(user:    user,
                        article: article)
  
    expect(uw_article.valid?).to be(true)
    uw_article.save!
  
    uw_article = UserWatchedArticle
                   .new(user:    user,
                        article: article)
    
    expect(uw_article.valid?).to be(false)
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
    expect(uw_article.all_criteria_applies?).to eq(false)
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
