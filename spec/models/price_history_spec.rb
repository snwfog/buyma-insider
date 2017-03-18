require_relative '../setup'

describe 'price_history' do
  it 'should compute price stats upon price update' do
    article = get_article
    article.save!
    
    price_history = PriceHistory.new(article: article)
    price_history.save!
    
    price_history.add_price_history!(24.3)
    price_history.add_price_history!(25.3)
  end
end
