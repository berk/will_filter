require "will_filter" # Require all the real code
require "rails"

module WillFilter
  class Engine < Rails::Engine
    initializer "static assets" do |app|
      # app.middleware.use ActionDispatch::Static, "#{root}/public" # Old way, does not work in production
      app.middleware.insert_after ActionDispatch::Static, ActionDispatch::Static, "#{root}/public"
    end
  end
end
