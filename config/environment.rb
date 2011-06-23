# Load the rails application
require File.expand_path('../application', __FILE__)

Rails.configuration.after_initialize do
  ["../lib",
   "../lib/core_ext/**",
   "../lib/will_filter",
   "../lib/will_filter/containers"].each do |dir|
      Dir[File.expand_path("#{File.dirname(__FILE__)}/#{dir}/*.rb")].sort.each do |file|
        require_or_load file
      end
  end
end

WillFilter::Application.initialize!