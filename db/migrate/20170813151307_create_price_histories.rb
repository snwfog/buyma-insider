class CreatePriceHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :price_histories do |t|
      t.references :article, null: false

      # t.integer :currency, null: false
      t.decimal :price, null: false, precision: 18, scale: 5

      t.timestamps null: false
    end

    add_index :price_histories, [:article_id, :price], order: { article_id: :asc, price: :asc }
    add_index :price_histories, [:article_id, :created_at], order: { article_id: :asc, created_at: :desc }

    add_foreign_key :price_histories, :articles
  end
end
