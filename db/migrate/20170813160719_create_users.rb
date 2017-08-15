class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :username, null: false, limit: 100
      t.string :email_address, null: false, limit: 1000
      t.string :password_hash, null: false, limit: 500
      t.datetime :last_seen_at

      t.timestamps null: false
    end

    add_index :users, :username, unique: true
    add_index :users, :email_address, unique: true
  end
end
