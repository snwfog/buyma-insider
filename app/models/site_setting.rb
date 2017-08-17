# == Schema Information
#
# Table name: site_settings
#
#  id       :integer          not null, primary key
#  settings :text
#

class SiteSetting < ActiveRecord::Base
  include Singleton

  def settings
    settings_yaml = super
    @settings_h = settings_yaml.blank? ? nil : YAML.load(settings_yaml)
  end
end
