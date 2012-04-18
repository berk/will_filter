module Merchant
  class Order < ActiveRecord::Base
    self.table_name = :merchant_orders
    belongs_to :user
    has_many :order_items
  end
end