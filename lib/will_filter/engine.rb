require "will_filter" # Require all the real code
require "rails"

module WillFilter
  class Engine < Rails::Engine
    config.autoload_paths << File.expand_path("../../lib", __FILE__)
    config.autoload_paths << File.expand_path("../../lib/core_ext/**", __FILE__)
    config.autoload_paths << File.expand_path("../../lib/will_filter", __FILE__)
    config.autoload_paths << File.expand_path("../../lib/will_filter/containers", __FILE__)
    
    [
     "../../lib/core_ext/**",
     "../../lib/will_filter",
     "../../lib/will_filter/containers"
    ].each do |dir|
        Dir[File.expand_path("#{File.dirname(__FILE__)}/#{dir}/*.rb")].sort.each do |file|
          require(file)
        end
    end

    require(File.expand_path("#{File.dirname(__FILE__)}/../../lib/application_helper.rb"))

    initializer "static assets" do |app|
      # app.middleware.use ActionDispatch::Static, "#{root}/public" # Old way, does not work in production
      app.middleware.insert_after ActionDispatch::Static, ActionDispatch::Static, "#{root}/public"
    end
  end
end
