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

WillFilter::Engine.routes.draw do

  match 'filter/index', :to => 'filter#index', via: [:get, :post]
  match 'filter/add_condition', :to => 'filter#add_condition', via: [:get, :post]
  match 'filter/update_condition', :to => 'filter#update_condition', via: [:get, :post]
  match 'filter/remove_condition', :to => 'filter#remove_condition', via: [:get, :post]
  match 'filter/remove_all_conditions', :to => 'filter#remove_all_conditions', via: [:get, :post]
  match 'filter/load_filter', :to => 'filter#load_filter', via: [:get, :post]
  match 'filter/save_filter', :to => 'filter#save_filter', via: [:get, :post]
  match 'filter/update_filter', :to => 'filter#update_filter', via: [:get, :post]
  match 'filter/delete_filter', :to => 'filter#delete_filter', via: [:get, :post]

  match 'calendar', :to => 'calendar#index', via: [:get, :post]
  match 'calendar/index', :to => 'calendar#index', via: [:get, :post]

  match 'exporter', :to => 'exporter#index', via: [:get, :post]
  match 'exporter/index', :to => 'exporter#index', via: [:get, :post]
  match 'exporter/export', :to => 'exporter#export', via: [:get, :post]

  root :to => 'filter#index'
end
