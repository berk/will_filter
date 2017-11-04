#--
# Copyright (c) 2017 Michael Berkovich, theiceberk@gmail.com
#
#  __    __  ____  _      _          _____  ____  _     ______    ___  ____
# |  |__|  ||    || |    | |        |     ||    || |   |      |  /  _]|    \
# |  |  |  | |  | | |    | |        |   __| |  | | |   |      | /  [_ |  D  )
# |  |  |  | |  | | |___ | |___     |  |_   |  | | |___|_|  |_||    _]|    /
# |  `  '  | |  | |     ||     |    |   _]  |  | |     | |  |  |   [_ |    \
#  \      /  |  | |     ||     |    |  |    |  | |     | |  |  |     ||  .  \
#   \_/\_/  |____||_____||_____|    |__|   |____||_____| |__|  |_____||__|\_|
#
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

module WillFilter
  class Config
    def self.init(site_current_user, site_current_project = nil)
      Thread.current[:current_user] = site_current_user
      Thread.current[:current_project] = site_current_project
    end
    
    def self.current_user
      Thread.current[:current_user]
    end

    def self.current_project
      Thread.current[:current_project]
    end

    def self.reset!
      Thread.current[:current_user] = nil
      Thread.current[:current_project] = nil
    end
    
    def self.load_yml(file_path)
      yml = YAML.load_file("#{Rails.root}#{file_path}")[Rails.env]
      HashWithIndifferentAccess.new(yml)
    end
    
    def self.config
      @config ||= load_yml("/config/will_filter/config.yml")
    end
  
    def self.require_filter_extensions?
      config[:require_filter_extensions]
    end

    def self.disable_filter_saving?
      config[:disable_filter_saving]
    end

    def self.effects_options
      config[:effects_options]
    end
  
    def self.save_options
      config[:save_options]
    end
  
    def self.export_options
      config[:export_options]
    end
  
    def self.containers
      config[:containers]
    end
  
    def self.data_types
      config[:data_types]
    end
  
    def self.operators
      config[:operators]
    end
  
    def self.operator_order
      @operator_order ||= begin
        keys = operators.keys
        keys.sort! { |a,b| operators[a] <=> operators[b] }
        keys
      end
    end
  
    def self.saving_enabled?
      save_options[:enabled]
    end
  
    def self.user_filters_enabled?
      save_options[:user_filters_enabled]
    end
  
    def self.user_class_name
      save_options[:user_class_name]
    end
    
    def self.current_user_method
      save_options[:current_user_method]
    end

    def self.project_filters_enabled?
      save_options[:project_filters_enabled]
    end

    def self.project_class_name
      save_options[:project_class_name]
    end

    def self.current_project_method
      save_options[:current_project_method]
    end

    def self.exporting_enabled?
      export_options[:enabled]
    end
  
    def self.default_export_formats
      export_options[:default_formats]
    end
  end
end
