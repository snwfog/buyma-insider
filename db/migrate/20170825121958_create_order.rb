# not used
class CreateOrder < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.references :user_article_sold, null: false

      t.timestamps null: false
    end
  end
end
