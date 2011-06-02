ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

# Dummy UserFilter object for testing filter containers
class UserFilter < WillFilter::Filter
  def table_name
    "users"
  end
  
  def definition
    {:id=>
      {:is_provided=>"nil",
       :is_not_provided=>"nil",
       :is=>"numeric",
       :is_not=>"numeric",
       :is_less_than=>"numeric",
       :is_greater_than=>"numeric",
       :is_in_the_range=>"numeric_range",
       :is_in=>"numeric_delimited",
       :is_filtered_by=>:filter_list},
     :name=>
      {:is_provided=>"nil",
       :is_not_provided=>"nil",
       :is=>"text",
       :is_not=>"text",
       :contains=>"text",
       :does_not_contain=>"text",
       :starts_with=>"text",
       :ends_with=>"text",
       :is_in=>"text_delimited",
       :is_not_in=>"text_delimited"},
     :admin=>
      {:is_provided=>"nil",
       :is_not_provided=>"nil",
       :is=>"boolean"
      },
     :birth_date =>
      {:is_provided=>"nil",
       :is_not_provided=>"nil",
       :is=>"date",
       :is_not=>"date",
       :is_after=>"date",
       :is_before=>"date",
       :is_in_the_range=>"date_range"
      },
    :created_at=>
      {:is_provided=>"nil",
       :is_not_provided=>"nil",
       :is=>"date_time",
       :is_not=>"date_time",
       :is_after=>"date_time",
       :is_before=>"date_time",
       :is_in_the_range=>"date_time_range",
       :is_on=>"single_date",
       :is_not_on=>"single_date"}
    }
  end
  
  
end
