class CreateJoinTableUserArticleSoldsShippingServices < ActiveRecord::Migration[5.0]
  def change
    create_join_table :user_article_solds, :shipping_services,
                      table_name:     :user_article_solds_shipping_services,
                      column_options: { null: false } do |t|

      t.index [:user_article_sold_id, :shipping_service_id], unique: true, name: 'idx_ua_solds_shipping_services_ua_sold_id_shipping_service_id'
      t.index [:shipping_service_id, :user_article_sold_id], unique: true, name: 'idx_ua_solds_shipping_services_shipping_service_id_ua_sold_id'

      t.timestamps null: false
    end

    add_foreign_key :user_article_solds_shipping_services, :user_article_solds
    add_foreign_key :user_article_solds_shipping_services, :shipping_services
  end
end
