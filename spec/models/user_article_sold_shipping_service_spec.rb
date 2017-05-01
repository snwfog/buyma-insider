require_relative '../setup'

describe UserArticleSoldShippingService do
  let(:user) { get_user.tap(&:save!) }
  let(:article) { get_article.tap(&:save!) }
  let(:ex_rate) { get_exchange_rate.tap(&:save!) }
  let(:shipping_service) { get_shipping_service.tap(&:save!) }
  
  it 'should be unique per sold article' do
    us_article = UserArticleSold.create!(user:          user,
                                         article:       article,
                                         exchange_rate: ex_rate)
    
    expect { UserArticleSoldShippingService
               .create!(user_article_sold: us_article,
                        shipping_service:  shipping_service) }.to_not raise_error

    expect { UserArticleSoldShippingService
               .create!(user_article_sold: us_article,
                        shipping_service:  shipping_service) }.to raise_error NoBrainer::Error::DocumentInvalid
  end
end