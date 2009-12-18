require 'csv'

class ModelFilterController < ApplicationController
  
  def update
    @model_filter = ModelFilter.deserialize_from_params(params)
    
    if params[:filter_action]=="clear"
      @model_filter.remove_all
      
    elsif params[:filter_action]=="addConditionLast"
      @model_filter.add_default_condition_at(@model_filter.size)
      
    elsif params[:filter_action].include?("addConditionAfter")
      vals = params[:filter_action].split('_')
      @model_filter.add_default_condition_at(vals[1].to_i + 1)
      
    elsif params[:filter_action].include?("removeConditionAt")
      vals = params[:filter_action].split('_')
      @model_filter.remove_condition_at(vals[1].to_i)
      
    elsif params[:filter_action].include?("changedConditionAt")
      vals = params[:filter_action].split('_')
      condition = @model_filter.condition_at(vals[1].to_i)
      condition.container.reset_values
      
    elsif params[:filter_action] == 'export'
      
    end
    
    render :partial => 'filter_conditions', :layout=>false
  end

  def load_filter
    @model_filter = params[:mf_type].constantize.load_filter(@own_profile, params[:mf_key])
    render :partial => 'filter_conditions', :layout=>false
  end

  def save_filter
    params.delete(:mf_id)
    
    @model_filter = ModelFilter.deserialize_from_params(params)
    @model_filter.validate!
    
    unless @model_filter.errors?
      @model_filter.id = nil
      @model_filter.identity = @own_profile
      @model_filter.save
    end
    
    @model_filter.key= @model_filter.id.to_s 
    
    render :partial => 'filter_conditions', :layout=>false
  end

  def update_filter
    @model_filter = ModelFilter.find_by_id(params[:mf_id])
    params.delete(:mf_id)
    
    @model_filter.deserialize_from_params(params)
    @model_filter.validate!
    
    unless @model_filter.errors?
      @model_filter.identity = @own_profile
      @model_filter.save
    end
    
    @model_filter.key= @model_filter.id.to_s 
    
    render :partial => 'filter_conditions', :layout=>false
  end

  def change_filter_model
    @model_filter = ModelFilter.deserialize_from_params(params)
    @model_filter.remove_all
    
    @model_filter.id = nil
    @model_filter.key = nil
    
    render :partial => 'filter_conditions', :layout=>false
  end

  def delete_filter
    filter = ModelFilter.find_by_id(params[:mf_id])
    filter.destroy if filter

    @model_filter = ModelFilter.deserialize_from_params(params)
    @model_filter.id=nil
    @model_filter.key=nil
    @model_filter.remove_all
    
    render :partial => 'filter_conditions', :layout=>false
  end
  
  def calendar_dialog
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
  
  def export_dialog
    @model_filter = ModelFilter.deserialize_from_params(params)
    
    render :layout => false
  end
  
  def export_data
    @model_filter = ModelFilter.deserialize_from_params(params)
    
    if @model_filter.custom_format?
      send_data(@model_filter.process_custom_format, :type => 'text', :charset => 'utf-8')
      return
    end
    
    unless @model_filter.valid_format?
      render :text => "The export format is not supported (#{@model_filter.format})"
      return     
    end
    
    @objects = @model_filter.model_class.find(:all, :conditions => @model_filter.sql_conditions, :order => @model_filter.order_clause)
    
    if @model_filter.format == :xml
      return send_xml_data(@model_filter, @objects)
    end  

    if @model_filter.format == :json
      return send_json_data(@model_filter, @objects)
    end  
    
    if @model_filter.format == :csv
      return send_csv_data(@model_filter, @objects)
    end  

    render :layout => false
  end  

private

  def send_xml_data(model_filter, objects)
    class_name = model_filter.model_class_name.underscore
    
    result = ""
    xml = Builder::XmlMarkup.new(:target => result, :indent => 1)
    xml.instruct!
    xml.tag!(class_name.pluralize) do
      objects.each do |obj|
        xml.tag!(class_name.underscore) do
          model_filter.fields.each do |field|
            xml.tag!(field.to_s, obj.send(field).to_s) 
          end    
        end
      end
    end
    
    send_data(result, :type => 'text/xml', :charset => 'utf-8')
  end  

  def send_json_data(model_filter, objects)
    result = []
    
    objects.each do |obj|
      hash = {}
      model_filter.fields.each do |field|
        hash[field] = obj.send(field).to_s 
      end  
      result << hash
    end
    
    send_data(result.to_json, :type => 'text', :charset => 'utf-8')
  end  
  
  def send_csv_data(model_filter, objects)
    result = StringIO.new
    CSV::Writer.generate(result) do |csv|
      csv << model_filter.fields
      objects.each do |obj|
        row = []
        model_filter.fields.each do |field|
          row << obj.send(field).to_s 
        end    
        csv << row
      end
    end
    
    send_data(result.string, :type => 'text/csv', :charset => 'utf-8')
  end
  
end
