# == Schema Information
#
# Table name: site_settings
#
#  id :integer          not null, primary key
#

class SiteSetting < ActiveRecord::Base
  include Singleton

  def settings
    setting_yaml = super
    YAML.parse(setting_yaml)
  end
end
