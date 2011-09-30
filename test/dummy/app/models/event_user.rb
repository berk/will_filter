class EventUser < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  def self.generate_random_data(count = 500)
    0.upto(count) do 
      create(:user => User.random, :event => Event.random)      
    end
  end
end
