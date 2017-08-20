class CreateExchangeRates < ActiveRecord::Migration[5.0]
  def change
    create_table :exchange_rates do |t|
      t.integer :base, null: false
      t.datetime :timestamp, null: false
      t.text :rates, null: false, limit: 5000

      t.timestamps null: false
    end

    add_index :exchange_rates, :timestamp, unique: true, order: { timestamp: :desc }
  end
end
