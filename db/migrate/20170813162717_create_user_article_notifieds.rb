class CreateUserArticleNotifieds < ActiveRecord::Migration[5.0]
  def change
    create_table :user_article_notifieds do |t|
      t.references :user, null: false
      t.references :article, null: false

      t.datetime :read_at

      t.timestamps null: false
    end

    add_index :user_article_notifieds, [:user_id, :article_id], unique: true

    add_foreign_key :user_article_notifieds, :users
    add_foreign_key :user_article_notifieds, :articles
  end
end
