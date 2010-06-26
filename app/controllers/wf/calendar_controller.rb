#--
# Copyright (c) 2010 Michael Berkovich, Geni Inc
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

require 'csv'

class Wf::CalendarController < ApplicationController

  def index
    @months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    @days = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat']
    
    @show_time = (params[:show_time] == 'true')
    if @show_time
      @hour_options = []
      0.upto(23){ |i| @hour_options << [(i < 10 ? "0#{i}" : "#{i}"), i] }
      @minute_options = []
      @second_options = []
      0.upto(59) do |i| 
        @minute_options << [(i < 10 ? "0#{i}" : "#{i}"), i] 
        @second_options << [(i < 10 ? "0#{i}" : "#{i}"), i] 
      end
    end
      
    @month_options = []
    @months.each_with_index do |m, i|
      @month_options << [m, i+1]
    end
    
    @year_options = []
    (Date.today.year - 100).upto(Date.today.year + 30) do |year|
      @year_options << [year, year]
    end
  
    begin
      @time = Time.parse(params[:date])
    rescue 
      @time = Time.now
    end

    @date = @time.to_date
    @month = @date.month
    @year = @date.year
    
    @hour = @time.hour
    @minute = @time.min
    @second = @time.sec
  
    @next_month = @time + 1.month
    @prev_month = @time - 1.month
  
    @days_in_month = ((Date.new(@year, 12, 31).to_date<<(12 - @month)).day)
    @start_date = Date.new(@year, @month, 1)
    @end_date = Date.new(@year, @month, @days_in_month)
    
    render :layout => false
  end
  
end
