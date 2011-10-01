module Merchant
  class OrderItemFilter < WillFilter::Filter

    def inner_joins
      [:order]
    end

  end
end