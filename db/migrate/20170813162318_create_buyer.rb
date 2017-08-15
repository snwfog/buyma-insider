class CreateBuyer < ActiveRecord::Migration[5.0]
  def change
    create_table :buyers do |t|
      t.string :email_address, limit: 1000
      t.string :first_name, limit: 500
      t.string :last_name, limit: 500

      t.timestamps null: false
    end

    add_index :buyers, :email_address, unique: true
  end
end
