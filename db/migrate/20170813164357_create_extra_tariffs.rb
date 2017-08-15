class CreateExtraTariffs < ActiveRecord::Migration[5.0]
  def change
    create_table :extra_tariffs do |t|
      t.string :tariff_name, null: false, limit: 500
      t.decimal :rate, null: false, precision: 12, scale: 5
      t.integer :rate_type, null: false
      t.integer :flow_direction, null: false
      t.text :description, null: false, limit: 2000

      t.timestamps null: false
    end

    add_index :extra_tariffs, :tariff_name, unique: true
  end
end
