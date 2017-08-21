class CreateUserArticleSolds < ActiveRecord::Migration[5.0]
  def change
    create_table :user_article_solds do |t|
      t.references :user, null: false
      t.references :article, null: false
      t.references :exchange_rate, null: false
      t.references :price_history, null: false
      t.references :buyer

      t.decimal :price_sold, precision: 18, scale: 5
      t.integer :status, null: false
      t.text :notes, limit: 5000

      t.timestamps null: false
    end

    add_index :user_article_solds, [:user_id, :article_id], unique: true

    add_foreign_key :user_article_solds, :users
    add_foreign_key :user_article_solds, :articles
    add_foreign_key :user_article_solds, :exchange_rates
    add_foreign_key :user_article_solds, :price_histories
  end
end
