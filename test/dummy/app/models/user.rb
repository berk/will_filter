class User < ActiveRecord::Base
  has_many :events
  has_many :events_users
  
  def name
    "#{first_name} #{last_name}"  
  end
  
  def self.random
    User.offset(rand(User.count)).first
  end
  
  def self.generate_random_data(count = 500)
    male_names = File.read("config/data/male_names.txt").split("\n")
    female_names = File.read("config/data/female_names.txt").split("\n")
    last_names = File.read("config/data/last_names.txt").split("\n")

    0.upto(count) do 
      sex = (rand(2) == 1) ? "male" : "female"
      create(:first_name => random_name(sex, male_names, female_names), :last_name => last_names[rand(last_names.size)], :sex => sex, :birthday => random_birthday)      
    end
  end

  def self.random_name(sex, male_names, female_names)
    return male_names[rand(male_names.size)] if sex == "male"
    female_names[rand(female_names.size)]
  end
  
  def self.random_birthday
    birthday = nil
    while (not birthday)
      begin
        birthday = Date.new(rand(59) + 1950, rand(12), rand(31))
      rescue 
        birthday = nil
      end
    end
    
    birthday
  end
  
end
