class Event < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => :creator_id
  has_many :event_users
  
  def self.random
    find(:first, :offset => rand(count - 1))
  end
  
  def self.generate_random_data(count = 500)
    0.upto(count) do |index|
      create(:creator => User.random, :name => "Event #{index}", :headline => "Event Headline #{index}", :start_time => (Time.now + rand(100).hours))      
    end
  end
  
end
