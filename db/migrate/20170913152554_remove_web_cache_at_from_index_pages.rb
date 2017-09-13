class RemoveWebCacheAtFromIndexPages < ActiveRecord::Migration[5.0]
  def up
    remove_column :index_pages, :web_cache_at
  end

  def down
    add_column :index_pages, :web_cache_at, :datetime
  end
end
