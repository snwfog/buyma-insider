require_relative '../setup'

describe UserArticle do
  describe UserWatchedArticle do
    it 'should eager load user' do
      user = get_user
      user.save
      
      article = get_article
      article.save
      
      UserWatchedArticle.create!(user:    user,
                                 article: article)
      
      expect(article).to include(user)
    end
  end
end