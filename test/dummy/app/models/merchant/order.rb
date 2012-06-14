module Merchant
  class Order < ActiveRecord::Base
    self.table_name = :merchant_orders
    belongs_to :user
    has_many :order_items

	  def self.generate_random_data(count = 500)
	    0.upto(count) do 
	      create(:user_id => User.random, :amount => rand(5000))      
	    end
	  end

  end
end