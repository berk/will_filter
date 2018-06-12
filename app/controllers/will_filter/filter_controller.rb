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
  class FilterController < ApplicationController

    def index
      @filters = WillFilter::Filter.new(WillFilter::Filter).deserialize_from_params(params.permit!).results
    end

    def update_condition
      @wf_filter = WillFilter::Filter.deserialize_from_params(params.permit!)

      condition = @wf_filter.condition_at(params[:at_index].to_i)
      condition.container.reset_values

      render_filter_conditions
    end

    def remove_condition
      @wf_filter = WillFilter::Filter.deserialize_from_params(params.permit!)
      @wf_filter.remove_condition_at(params[:at_index].to_i)

      render_filter_conditions
    end

    def add_condition
      @wf_filter = WillFilter::Filter.deserialize_from_params(params.permit!)
      index = params[:after_index].to_i
      if index == -1
        @wf_filter.add_default_condition_at(@wf_filter.size)
      else
        @wf_filter.add_default_condition_at(params[:after_index].to_i + 1)
      end

      render_filter_conditions
    end

    def remove_all_conditions
      @wf_filter = WillFilter::Filter.deserialize_from_params(params.permit!)
      @wf_filter.remove_all

      render_filter_conditions
    end

    def load_filter
      @wf_filter = WillFilter::Filter.deserialize_from_params(params.permit!)
      @wf_filter = @wf_filter.load_filter!(params[:wf_key])

      render_filter_conditions
    end

    def save_filter
      unless WillFilter::Config.saving_enabled?
        raise WillFilter::FilterException.new("Saving functions are disabled")
      end

      params.delete(:wf_id)

      @wf_filter = WillFilter::Filter.deserialize_from_params(params.permit!)
      @wf_filter.validate!

      unless @wf_filter.errors?
        @wf_filter.save
      end

      @wf_filter.key = @wf_filter.id.to_s

      render_filter_conditions
    end

    def update_filter
      unless WillFilter::Config.saving_enabled?
        raise WillFilter::FilterException.new("Update functions are disabled")
      end

      @wf_filter = WillFilter::Filter.find_by_id(params.delete(:wf_id))
      @wf_filter.deserialize_from_params(params.permit!)
      @wf_filter.validate!

      unless @wf_filter.errors?
        @wf_filter.save
      end

      @wf_filter.key = @wf_filter.id.to_s

      render_filter_conditions
    end

    def delete_filter
      raise WillFilter::FilterException.new("Delete functions are disabled") unless WillFilter::Config.saving_enabled?

      @wf_filter = WillFilter::Filter.find_by_id(params[:wf_id])
      if @wf_filter
        @wf_filter.destroy
      end

      @wf_filter = WillFilter::Filter.deserialize_from_params(params.permit!)
      @wf_filter.id = nil
      @wf_filter.key = nil
      @wf_filter.remove_all

      render_filter_conditions
    end

    protected

    def render_filter_conditions
      style = params[:wf_style] || 'default'
      render(:partial => "/will_filter/filter/#{style}/conditions", :locals => {:wf_filter => @wf_filter})
    end

  end
end