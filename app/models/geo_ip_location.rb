# == Schema Information
#
# Table name: geo_ip_locations
#
#  id               :integer          not null, primary key
#  begin_ip_address :cidr             not null
#  end_ip_address   :cidr             not null
#  country_code     :string           not null
#

class GeoIpLocation < ActiveRecord::Base
  def self.random_canadian
    where(country_code: :CA).offset(rand(10000)).take
  end

  def to_range
    begin_ip_address..end_ip_address
  end
end
