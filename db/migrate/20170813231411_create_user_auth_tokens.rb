class CreateUserAuthTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :user_auth_tokens do |t|
      t.references :user, null: false

      t.string :token, null: false, limit: 500

      t.timestamps null: false
    end

    add_foreign_key :user_auth_tokens, :users
  end
end
