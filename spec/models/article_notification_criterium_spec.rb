require_relative '../setup'

describe ArticleNotificationCriterium do
  describe 'Base' do
    it 'should not be instantiable' do
      expect { ArticleNotificationCriterium.create }.to raise_error(/not allowed to be instantiated/)
    end
  end
  
  describe DiscountPercentArticleNotificationCriterium do
    let(:article) do
      article = get_article(price: 100.0)
      article.save!
      article.update_price_history!
      article
    end
    
    it 'should validate discount percent' do
      article.price = 90.0
      article.save!
      article.update_price_history!

      percent_9 = DiscountPercentArticleNotificationCriterium.new(threshold_pct: 9)
      expect(percent_9.applicable?(article)).to eq(true)
      
      percent_10 = DiscountPercentArticleNotificationCriterium.new(threshold_pct: 10)
      expect(percent_10.applicable?(article)).to eq(true)

      percent_20 = DiscountPercentArticleNotificationCriterium.new(threshold_pct: 20)
      expect(percent_20.applicable?(article)).to eq(false)
    end
    
    it 'should be cacheable'do
      pct_9_1 = DiscountPercentArticleNotificationCriterium.create!(threshold_pct: 9)
      pct_9_2 = DiscountPercentArticleNotificationCriterium.create!(threshold_pct: 9)
      
      expect(pct_9_1).to equal(pct_9_2)
    end
  end
end