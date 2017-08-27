# == Schema Information
#
# Table name: site_settings
#
#  id       :integer          not null, primary key
#  settings :text
#

class SiteSetting < ActiveRecord::Base
  include Singleton
end
