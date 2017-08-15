class CreateMerchants < ActiveRecord::Migration[5.0]
  def change
    create_table :merchants do |t|
      t.string :code, null: false, limit: 3
      t.string :name, null: false, limit: 500

      t.timestamps null: false
    end

    add_index :merchants, :code, unique: true
  end
end
