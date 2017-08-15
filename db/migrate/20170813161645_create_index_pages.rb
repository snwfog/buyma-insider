class CreateIndexPages < ActiveRecord::Migration[5.0]
  def change
    create_table :index_pages do |t|
      t.references :merchant, null: false
      t.references :index_page # self reference for sub-index-pages

      t.string :relative_path, null: false, limit: 2000

      t.timestamps null: false
    end

    add_index :index_pages, :relative_path, unique: true

    add_foreign_key :index_pages, :merchants
  end
end
