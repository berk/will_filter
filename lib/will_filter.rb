module WillFilter
  [
   "core_ext/**",
   "will_filter",
   "will_filter/containers",
   "../app/models/will_filter"
  ].each do |dir|
      Dir[File.expand_path("#{File.dirname(__FILE__)}/#{dir}/*.rb")].sort.each do |file|
        require(file)
      end
  end

  require 'application_helper'
  
end
