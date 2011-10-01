class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :merchant_orders do |t|
      t.integer   :user_id
      t.integer   :amount
      t.timestamps
    end
  end

  def self.down
    drop_table :merchant_orders
  end
end
