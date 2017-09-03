# == Schema Information
#
# Table name: site_settings
#
#  id         :integer          not null, primary key
#  settings   :hstore           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SiteSetting < ActiveRecord::Base
  include Singleton
end
