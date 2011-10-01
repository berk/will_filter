module Merchant
  class OrderFilter < WillFilter::Filter

    def inner_joins
      [:user]
    end

  end
end