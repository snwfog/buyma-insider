class CreateUserArticleWatcheds < ActiveRecord::Migration[5.0]
  def change
    create_table :user_article_watcheds do |t|
      t.references :user, null: false
      t.references :article, null: false

      t.timestamps null: false
    end

    add_index :user_article_watcheds, [:user_id, :article_id], unique: true

    add_foreign_key :user_article_watcheds, :users
    add_foreign_key :user_article_watcheds, :articles
  end
end
