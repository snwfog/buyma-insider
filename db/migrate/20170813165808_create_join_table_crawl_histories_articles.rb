class CreateJoinTableCrawlHistoriesArticles < ActiveRecord::Migration[5.0]
  def change
    create_join_table :crawl_histories, :articles,
                      table_name:     :crawl_histories_articles,
                      column_options: { null: false } do |t|

      t.index [:crawl_history_id, :article_id], unique: true, name: 'idx_crawl_histories_articles_crawl_history_id_article_id'
      t.index [:article_id, :crawl_history_id], unique: true, name: 'idx_crawl_histories_articles_article_id_crawl_history_id'

      t.integer :status, null: false
      t.timestamps null: false
    end

    add_index :crawl_histories_articles, :created_at, unique: true, order: { created_at: :desc }

    add_foreign_key :crawl_histories_articles, :articles
    add_foreign_key :crawl_histories_articles, :crawl_histories
  end
end
