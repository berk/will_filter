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

require 'rails'
require 'pp'

[
 '.',
 './containers'
].each do |dir|
    Dir[File.expand_path("#{File.dirname(__FILE__)}/#{dir}/*.rb")].sort.each do |file|
      require(file)
    end
end

require File.join(File.dirname(__FILE__), 'extensions/array_extension')
require File.join(File.dirname(__FILE__), 'extensions/action_view_extension')
require File.join(File.dirname(__FILE__), 'extensions/active_record_extension')
require File.join(File.dirname(__FILE__), 'extensions/active_record_relation_extension')
require File.join(File.dirname(__FILE__), 'extensions/action_controller_extension')

module WillFilter
  class Railtie < ::Rails::Railtie #:nodoc:
    initializer 'will_filter' do |app|
      ActiveSupport.on_load(:active_record) do
        ::ActiveRecord::Base.send :include, WillFilter::ActiveRecordExtension
      end
      ActiveSupport.on_load(:action_view) do
        ::ActionView::Base.send :include, WillFilter::ActionViewExtension
      end
      ActiveSupport.on_load(:action_controller) do
        include WillFilter::ActionControllerExtension
      end
    end
  end
end