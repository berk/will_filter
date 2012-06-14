module Merchant
  class OrderItemFilter < WillFilter::Filter

	  def model_class
	    Merchant::OrderItem
	  end

    # def inner_joins
    #   [:order]
    # end

  end
end