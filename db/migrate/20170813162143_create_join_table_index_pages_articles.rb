class CreateJoinTableIndexPagesArticles < ActiveRecord::Migration[5.0]
  def change
    create_join_table :index_pages, :articles,
                      table_name:     :index_pages_articles,
                      column_options: { null: false } do |t|

      t.index [:index_page_id, :article_id], unique: true
      t.index [:article_id, :index_page_id], unique: true

      t.timestamps null: false
    end

    add_foreign_key :index_pages_articles, :index_pages
    add_foreign_key :index_pages_articles, :articles
  end
end
