module Merchant
  class OrderFilter < WillFilter::Filter

	  def model_class
	    Merchant::Order
	  end

    # def inner_joins
    #   [:user]
    # end

  end
end