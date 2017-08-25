class CreateUserArticleSoldStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :user_article_sold_statuses do |t|
      t.references :user_article_sold, null: false
      t.integer :status, null: false, default: 0
      t.timestamps null: false
    end

    add_index :user_article_sold_statuses, [:user_article_sold_id, :status], unique: true,
              name: :idx_user_article_sold_user_article_sold_id_status


    add_foreign_key :user_article_sold_statuses, :user_article_solds
  end
end
