# not used
class CreateOrderStatus < ActiveRecord::Migration[5.0]
  def change
    create_table :order_statuses do |t|
      t.string :status, null: false, limit: 20
    end
  end
end
