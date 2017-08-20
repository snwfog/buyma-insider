# == Schema Information
#
# Table name: price_histories
#
#  id               :integer          not null, primary key
#  article_id       :integer          not null
#  exchange_rate_id :integer          not null
#  price            :decimal(18, 5)   not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require_relative '../setup'

describe 'price_history' do
  let(:article) do
    article = get_article
    article.save!
    article
  end
  
  it 'should compute price stats upon price update' do
    article = get_article
    article.save!
    
    price_history = PriceHistory.new(article: article)
    price_history.save!
    
    price_history.add_price_history!(24.3)
    price_history.add_price_history!(25.3)
  end
  
  it 'should know when its on sale' do
    current_price = article.price
    new_price     = current_price + 1 # Increase price
    
    article.price = new_price
    article.save!
    article.update_price_history!
    
    expect(article.on_sale?).to be_falsey
    
    article.price = new_price - 1
    article.save!
    article.update_price_history!
    
    article.reload
    expect(article.on_sale?).to be_truthy
  end
end
