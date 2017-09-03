class CreateGeoIpLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :geo_ip_locations do |t|
      t.cidr :begin_ip_address, null: false
      t.cidr :end_ip_address, null: false
      t.string :country_code, null: false
    end

    add_index :geo_ip_locations, [:begin_ip_address, :end_ip_address], unique: true
  end
end
