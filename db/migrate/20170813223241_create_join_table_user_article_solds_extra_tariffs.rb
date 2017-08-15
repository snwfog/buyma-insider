class CreateJoinTableUserArticleSoldsExtraTariffs < ActiveRecord::Migration[5.0]
  def change
    create_join_table :user_article_solds, :extra_tariffs,
                      table_name:     :user_article_solds_extra_tariffs,
                      column_options: { null: false } do |t|

      t.index [:user_article_sold_id, :extra_tariff_id], unique: true, name: 'idx_ua_solds_extra_tariffs_ua_sold_id_extra_tariff_id'
      t.index [:extra_tariff_id, :user_article_sold_id], unique: true, name: 'idx_ua_solds_extra_tariffs_extra_tariff_id_ua_sold_id'

      t.timestamps null: false
    end

    add_foreign_key :user_article_solds_extra_tariffs, :user_article_solds
    add_foreign_key :user_article_solds_extra_tariffs, :extra_tariffs
  end
end
