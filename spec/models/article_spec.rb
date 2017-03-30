require_relative '../setup'

describe Article do
  it 'should notify for price changes' do
    article = get_article
    article.save!
    
    prev_price = article.price
    
    article.price = prev_price + rand(100)
    article.save!
  end

  it 'should create price history if nil price history' do
    article = get_article
    expect(article.price_history).to be_nil
    article.save!
    expect(article.reload.price_history).to be_a(PriceHistory)
  end
  
  it 'should not create price history if exists' do
    article       = get_article.tap(&:save!)
    price_history = article.price_history
    article.name  = 'Updated name'
    article.save!
    expect(article.price_history).to equal(price_history)
  end
end