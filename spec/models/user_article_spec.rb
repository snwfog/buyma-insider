require_relative '../setup'

describe UserArticle do
  it 'should not be instantiable' do
    expect { UserArticle.new }.to raise_error('NonInstantiableDocument')
  end
  
  describe UserWatchedArticle do
    it 'should be instantiable' do
      expect { UserWatchedArticle.new }.not_to raise_error 'NonInstantiableDocument'
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
      expect(user_wa.errors.full_messages.first).to match(/Watched criteria can't be blank/)
    end
  end
end