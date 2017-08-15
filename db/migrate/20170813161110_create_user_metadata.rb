class CreateUserMetadata < ActiveRecord::Migration[5.0]
  def change
    create_table :user_metadata do |t|
      t.references :user, null: false

      t.string :first_name, limit: 500
      t.string :last_name, limit: 500

      t.timestamps null: false
    end

    # references create index by default
    # add_index :user_metadata, :user_id, unique: true

    add_foreign_key :user_metadata, :users
  end
end
