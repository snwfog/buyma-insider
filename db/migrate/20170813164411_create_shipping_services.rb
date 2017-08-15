class CreateShippingServices < ActiveRecord::Migration[5.0]
  def change
    create_table :shipping_services do |t|
      t.string :service_name, null: false, limit: 500
      t.decimal :rate, null: false, precision: 12, scale: 5
      t.float :weight_in_kg, null: false
      t.integer :arrival_in_days
      t.boolean :tracked, default: false

      t.timestamps null: false
    end

    add_index :shipping_services, :service_name, unique: true
  end
end
