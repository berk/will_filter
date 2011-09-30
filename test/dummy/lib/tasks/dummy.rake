namespace :samples do 

  desc 'Initialize database with random data'
  task :init => :environment do
    [User, Event, EventUser].each do |cls| 
        cls.delete_all
        cls.generate_random_data
    end
  end
  
end



