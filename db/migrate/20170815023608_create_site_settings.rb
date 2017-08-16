class CreateSiteSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :site_settings do |t|
      t.text :settings, limit: 5000
    end
  end
end
