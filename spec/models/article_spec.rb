require_relative '../setup'

describe Article do
  it 'should notify for price changes' do
    article = get_article
    article.save!
    
    prev_price = article.price
    
    article.price = prev_price + rand(100)
    article.save!
  end
end