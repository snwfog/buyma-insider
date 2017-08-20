class CreateArticleNotificationCriteria < ActiveRecord::Migration[5.0]
  def change
    create_table :article_notification_criteria do |t|

      t.string :name, null: false, limit: 500
      t.float :threshold_pct

      t.string :type, null: false
      t.timestamps null: false
    end

    add_index :article_notification_criteria, :name, unique: true
    add_index :article_notification_criteria, :threshold_pct, unique: true, where: "type = 'DiscountPercentArticleNotificationCriterium'"
  end
end
