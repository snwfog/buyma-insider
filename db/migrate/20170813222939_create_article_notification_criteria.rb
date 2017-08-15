class CreateArticleNotificationCriteria < ActiveRecord::Migration[5.0]
  def change
    create_table :article_notification_criteria do |t|
      t.string :name, null: false, limit: 500

      t.timestamps null: false
    end

    add_index :article_notification_criteria, :name, unique: true
  end
end
