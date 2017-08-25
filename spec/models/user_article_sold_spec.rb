# == Schema Information
#
# Table name: user_article_solds
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  article_id       :integer          not null
#  exchange_rate_id :integer          not null
#  price_history_id :integer          not null
#  buyer_id         :integer
#  price_sold       :decimal(18, 5)
#  notes            :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require_relative '../setup'

describe UserArticleSold do
  let(:user) { get_user.tap(&:save!) }
  let(:article) { get_article.tap(&:save!) }
  let(:ex_rate) { get_exchange_rate.tap(&:save!) }
  let(:shipping_service) { get_shipping_service.tap(&:save!) }
  
  it 'should update status with timestamp' do
    us_article = UserArticleSold.create!(user:          user,
                                         article:       article,
                                         exchange_rate: ex_rate)
    
    (UserArticleSold::STATUS - [:confirmed]).each do |status|
      us_article.status = status
      expect(us_article.__send__("#{status}_at")).to be_a(Time)
    end
  end
  
  it 'should update status with timestamp on status bang and attrs' do
    us_article = UserArticleSold.create!(user:          user,
                                         article:       article,
                                         exchange_rate: ex_rate)

    (UserArticleSold::STATUS - [:confirmed]).each do |status|
      us_article.__send__("#{status}!")
      expect(us_article.status).to be(status)
      expect(us_article.__send__("#{status}_at")).to be_a(Time)
    end
  end

  it 'should include current article price' do
    article.price = 100.00
    article.save
    
    us_article = UserArticleSold.create!(user:          user,
                                         article:       article,
                                         exchange_rate: ex_rate)
    expect(us_article.price).to eq(article.price)
  end
  
  it 'should validate_presence_of shipping_services shipped' do
    us_article = UserArticleSold.new(user:          user,
                                     article:       article,
                                     exchange_rate: ex_rate)
    
    expect(us_article.valid?).to be(true)
    
    us_article.shipped!
    expect(us_article.valid?).to be(false)
    expect(us_article.errors.full_messages).to include('Shipping service can\'t be blank')
  end
end
