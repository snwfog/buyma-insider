class CreateJoinTableUserArticleSoldsBuyers < ActiveRecord::Migration[5.0]
  def change
    create_join_table :user_article_solds, :buyer,
                      table_name:     :user_article_sold_buyers,
                      column_options: { null: false } do |t|

      t.index [:user_article_sold_id, :buyer_id], unique: true, name: 'idx_ua_solds_buyers_ua_sold_id_buyer_id'
      t.index [:buyer_id, :user_article_sold_id], unique: true, name: 'idx_ua_solds_buyers_buyer_id_ua_sold_id'
      t.index :user_article_sold_id, unique: true

      t.timestamps null: false
    end

    add_foreign_key :user_article_sold_buyers, :user_article_solds
    add_foreign_key :user_article_sold_buyers, :buyers
  end
end
