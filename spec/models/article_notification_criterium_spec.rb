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
      expect(percent_9.notify?(article)).to eq(true)
      
      percent_10 = DiscountPercentArticleNotificationCriterium.new(threshold_pct: 10)
      expect(percent_10.notify?(article)).to eq(true)

      percent_20 = DiscountPercentArticleNotificationCriterium.new(threshold_pct: 20)
      expect(percent_20.notify?(article)).to eq(false)
    end
  end
end