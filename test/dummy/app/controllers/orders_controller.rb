class OrdersController < ApplicationController
  def index
    @orders = Merchant::Order.filter(:params => params, :filter => Merchant::OrderFilter)
  end
  
  def items
    @order_items = Merchant::OrderItem.filter(:params => params, :filter => Merchant::OrderItemFilter)
  end
end
