class AddWebCacheAtToIndexPages < ActiveRecord::Migration[5.0]
  def change
    add_column :index_pages, :web_cache_at, :datetime
  end
end
