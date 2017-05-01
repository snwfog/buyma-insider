require_relative '../setup'

describe UserSoldArticleShippingService do
  let(:user) { get_user.tap(&:save!) }
  let(:article) { get_article.tap(&:save!) }
  let(:ex_rate) { get_exchange_rate.tap(&:save!) }
  let(:shipping_service) { get_shipping_service.tap(&:save!) }
  
  it 'should be unique per sold article' do
    us_article = UserSoldArticle.create!(user:          user,
                                         article:       article,
                                         exchange_rate: ex_rate)
    
    expect { UserSoldArticleShippingService
               .create!(user_sold_article: us_article,
                        shipping_service:  shipping_service) }.to_not raise_error
  end
end