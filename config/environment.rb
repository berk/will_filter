# Load the rails application
require File.expand_path('../application', __FILE__)

["../lib/core_ext/**",
 "../lib/will_filter",
 "../lib/will_filter/containers"].each do |dir|
    Dir[File.expand_path("#{File.dirname(__FILE__)}/#{dir}/*.rb")].sort.each do |file|
      require file
    end
end

# Initialize the rails application
WillFilter::Application.initialize!