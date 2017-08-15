class CreateMerchantMetadata < ActiveRecord::Migration[5.0]
  def change
    create_table :merchant_metadata do |t|
      t.references :merchant, null: false

      t.string :domain, null: false, limit: 2000
      t.string :pager_css, limit: 1000
      t.string :item_css, limit: 1000
      t.boolean :ssl, default: false

      t.timestamps null: false
    end

    add_foreign_key :merchant_metadata, :merchants
  end
end
