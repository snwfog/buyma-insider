class CreateUserArticleNotifiedsArticleNotificationCriteria < ActiveRecord::Migration[5.0]
  def change
    create_join_table :user_article_notifieds, :article_notification_criteria,
                      table_name:     :user_article_notifieds_article_notification_criteria,
                      column_options: { null: false } do |t|

      t.index [:user_article_notified_id, :article_notification_criterium_id], unique: true, name: 'idx_ua_notifieds_criteria_ua_notified_id_criterium_id'
      t.index [:article_notification_criterium_id, :user_article_notified_id], unique: true, name: 'idx_ua_notifieds_criteria_criterium_id_ua_notified_id'

      t.timestamps null: false
    end

    add_foreign_key :user_article_notifieds_article_notification_criteria, :user_article_notifieds
    add_foreign_key :user_article_notifieds_article_notification_criteria, :article_notification_criteria
  end
end
