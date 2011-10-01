module Merchant
  class OrderItem < ActiveRecord::Base
    set_table_name :merchant_order_items
    belongs_to :order, :class_name => "Merchant::Order"
  end
end