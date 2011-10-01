module Merchant
  class Order < ActiveRecord::Base
    set_table_name :merchant_orders
    belongs_to :user
    has_many :order_items
  end
end