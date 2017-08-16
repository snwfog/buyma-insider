# == Schema Information
#
# Table name: user_article_watcheds
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  article_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require_relative '../setup'

describe UserArticleWatched do
  let(:user) { get_user.tap(&:save!) }
  let(:article) { get_article.tap(&:save!) }
  let(:pct_criterium) { get_discount_percent_article_notification_criterium }
  
  it 'should respect uniqueness scope per article per user' do
    ua_watched = UserArticleWatched.new(user:    user,
                                        article: article)
    
    expect(ua_watched.valid?).to be(true)
    ua_watched.save!
    
    ua_watched = UserArticleWatched.new(user:    user,
                                        article: article)
    
    expect(ua_watched.valid?).to be(false)
    expect(ua_watched.errors.full_messages).to include('User is already taken')
  end
  
  it 'should #notify' do
    ua_watched = user.watch!(article, get_discount_percent_article_notification_criterium)
    expect(ua_watched.all_criteria_apply?).to eq(false)
  end
end
