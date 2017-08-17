class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.references :merchant, null: false

      t.string :sku, null: false, limit: 100
      t.string :name, null: false, limit: 500
      # t.decimal :price, null: false, precision: 18, scale: 5
      t.text :description, limit: 1000
      t.string :link, null: false, limit: 2000

      t.timestamps null: false
    end

    add_index :articles, [:merchant_id, :sku], unique: true
    add_index :articles, :name

    add_foreign_key :articles, :merchants
  end
end
