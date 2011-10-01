class CreateOrderItems < ActiveRecord::Migration
  def self.up
    create_table :merchant_order_items do |t|
      t.integer   :order_id
      t.string    :name
      t.integer   :price
      t.timestamps
    end
  end

  def self.down
    drop_table :merchant_order_items
  end
end
