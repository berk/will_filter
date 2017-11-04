class OrdersController < ApplicationController
  def index
    @orders = Merchant::Order.filter(:params => params.permit!, :filter => Merchant::OrderFilter)
  end
  
  def items
    @order_items = Merchant::OrderItem.filter(:params => params.permit!, :filter => Merchant::OrderItemFilter)
  end
end
