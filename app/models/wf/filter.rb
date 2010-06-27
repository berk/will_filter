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

class Wf::Filter < ActiveRecord::Base
  set_table_name :wf_filters

  belongs_to  :identity, :polymorphic => :subclass
  serialize   :data
  
  def initialize(new_model_class_name = nil, new_identity = nil)
    super()
    
    self.model_class_name = new_model_class_name
    self.identity = new_identity
  end
  
  def exportable?
    true
  end

  def show_save_options?
    true
  end

  def match 
    @match ||= :all
  end

  def key 
    @key ||= ''
  end

  def errors 
    @errors ||= {}
  end
  
  def format
    @format ||= :html
  end

  def fields
    @fields ||= []
  end
  
  def valid_format?
    Wf::Config.export_formats.include?(format.to_s)
  end
  
  def dup
    super.tap {|ii| ii.conditions = self.conditions.dup}
  end
  
  def model_class
    return nil unless model_class_name
    model_class_name.constantize
  end
  
  def table_name
    model_class.table_name
  end
  
  def key=(new_key)
    @key = new_key
  end
  
  def match=(new_match)
    @match = new_match
  end
  
  def definition
    @definition ||= begin
      defs = {}
      model_class.columns.each do |col|
        defs[col.name.to_sym] = default_condition_definition_for(col.name, col.sql_type)
      end
      defs
    end
  end
  
  def container_by_sql_type(type)
    raise Exception.new("Unsupported data type #{type}") unless Wf::Config.mapping[type]
    Wf::Config.mapping[type]
  end
  
  def default_condition_definition_for(name, sql_data_type)
    type = sql_data_type.split(" ").first.split("(").first.downcase
    containers = container_by_sql_type(type)
    operators = {}
    containers.each do |c|
      raise Excpetion.new("Unsupported container implementation for #{c}") unless Wf::Config.containers[c]
      container_klass = Wf::Config.containers[c].constantize
      container_klass.operators.each do |o|
        operators[o] = c
      end
    end
    
    if name == "id"
      operators[:is_filtered_by] = :filter_list 
    elsif (name.length - 3) == name.index("_id")
      begin
        name[0..-4].camelcase.constantize
        operators[:is_filtered_by] = :filter_list 
      rescue  
      end
    end
    
    operators
  end
  
  def sorted_operators(opers)
    (Wf::Config.operator_order.collect{|o| o.to_s}) & (opers.keys.collect{|o| o.to_s}).sort
  end
  
  def first_sorted_operator(opers)
    sorted_operators(opers).first.to_sym
  end
  
  # Match Options
  def match_options
    [["all", "all"], ["any", "any"]]
  end
  
  # Order Options
  def order_type_options
    [["desc", "desc"], ["asc", "asc"]]
  end
  
  # Page Size Options
  def per_page_options
    @per_page_options ||= [10, 20, 30, 40, 50, 100].collect{ |n| [n.to_s, n.to_s] }
  end
  
  def order_clause
    "#{order} #{order_type}"
  end
  
  # Condition Options
  def condition_options
    @condition_options ||= begin
      opts = []
      definition.keys.each do |cond|
        opts << [cond.to_s.capitalize.gsub('_', ' ').gsub('.', ' - '), cond.to_s]
      end
      opts.sort_by{ |i| i[0] }
    end
  end
  
  # Operator Options
  def operator_options_for(condition_key)
    condition_key = condition_key.to_sym if condition_key.is_a?(String)
    
    opers = definition[condition_key]
    raise Exception.new("Invalid condition #{condition_key} for filter #{self.class.name}") unless opers
    sorted_operators(opers).collect{|o| [o.to_s.gsub('_', ' '), o]}
  end
  
  # called by the list container, should be overloaded in a subclass
  def value_options_for(condition_key)
    []
  end
  
  def container_for(condition_key, operator_key)
    condition_key = condition_key.to_sym if condition_key.is_a?(String)

    opers = definition[condition_key]
    raise Exception.new("Invalid condition #{condition_key} for filter #{self.class.name}") unless opers
    oper = opers[operator_key]
    
    # if invalid operator_key was passed, use first operator
    oper = opers[first_sorted_operator(opers)] unless oper
    oper
  end
  
  def add_condition(condition_key, operator_key, values = [])
    add_condition_at(size, condition_key, operator_key, values)
  end
  
  def valid_operator?(condition_key, operator_key)
    condition_key = condition_key.to_sym if condition_key.is_a?(String)
    opers = definition[condition_key]
    return false unless opers
    opers[operator_key]!=nil
  end
  
  def add_condition_at(index, condition_key, operator_key, values = [])
    values = [values] unless values.instance_of?(Array)
    values = values.collect{|v| v.to_s}

    condition_key = condition_key.to_sym if condition_key.is_a?(String)
    
    unless valid_operator?(condition_key, operator_key)
      opers = definition[condition_key]
      operator_key = first_sorted_operator(opers)
    end
    
    condition = Wf::FilterCondition.new(self, condition_key, operator_key, container_for(condition_key, operator_key), values)
    @conditions.insert(index, condition)
  end
  
  # options always go in [NAME, KEY] format
  def default_condition_key
    condition_options.first.last
  end
  
  # options always go in [NAME, KEY] format
  def default_operator_key(condition_key)
    operator_options_for(condition_key).first.last
  end
  
  def default_order
    'id'
  end
  
  def default_order_type
    'desc'
  end

  def default_per_page
    30
  end
  
  def per_page
    @per_page ||= default_per_page
  end

  def page
    @page ||= 1
  end
  
  def order
    @order ||= default_order
  end
  
  def order_type
    @order_type ||= default_order_type
  end
  
  def conditions
    @conditions ||= []
  end
  
  def condition_at(index)
    conditions[index]
  end
  
  def condition_by_key(key)
    @conditions.each do |c|
      return c if c.key==key
    end
    nil
  end
  
  def size
    @conditions.size
  end
  
  def add_default_condition_at(index)
    add_condition_at(index, default_condition_key, default_operator_key(default_condition_key))
  end
  
  def remove_condition_at(index)
    @conditions.delete_at(index)
  end
  
  def remove_all
    @conditions = []
  end

  def serialize_to_params
    params = {}
    params[:wf_type]        = self.class.name
    params[:wf_match]       = match
    params[:wf_model]       = model_class_name
    params[:wf_order]       = order
    params[:wf_order_type]  = order_type
    params[:wf_per_page]    = per_page
    
    0.upto(size - 1) do |index|
      condition = condition_at(index)
      condition.serialize_to_params(params, index)
    end
    params
  end
  
  # allows to create a filter from params only
  # used for dynamic filter selector
  def self.deserialize_from_params(params)
    params[:wf_type] = self.name unless params[:wf_type]
    identity = nil
    unless params[:mf_identity_type].blank?
      identity = params[:mf_identity_type].constantize.find(params[:wf_identity_id])
    end
    
    if params[:wf_type] == 'Wf::Filter'
      filter = params[:wf_type].constantize.new(params[:wf_model], identity)
    else
      filter = params[:wf_type].constantize.new(identity)
    end
    
    filter.deserialize_from_params(params)
    filter
  end
  
  def deserialize_from_params(params)
    @conditions = []
    @match                = params[:wf_match]       || :all
    @key                  = params[:wf_key]         || self.id.to_s
    self.model_class_name = params[:wf_model]       if params[:wf_model]
    
    @per_page             = params[:wf_per_page]    || default_per_page
    @order_type           = params[:wf_order_type]  || default_order_type
    @order                = params[:wf_order]       || default_order
    
    self.id   =  params[:wf_id].to_i  unless params[:wf_id].blank?
    self.name =  params[:wf_name]     unless params[:wf_name].blank?
    
    @fields = []
    unless params[:wf_export_fields].blank?
      params[:wf_export_fields].split(",").each do |fld|
        @fields << fld.to_sym
      end
    end

    if params[:wf_export_format].blank?
      @format = :html
    else  
      @format = params[:wf_export_format].to_sym
    end
    
    i = 0
    while params["wf_c#{i}"] do
      conditon_key = params["wf_c#{i}"]
      operator_key = params["wf_o#{i}"]
      values = []
      j = 0
      while params["wf_v#{i}_#{j}"] do
        values << params["wf_v#{i}_#{j}"]
        j += 1
      end
      i += 1
      add_condition(conditon_key, operator_key.to_sym, values)
    end

    return self
  end
  
  def errors?
   (@errors and @errors.size > 0)
  end
  
  def empty?
    size == 0
  end
  
  def validate!
    @errors = {}
    0.upto(size - 1) do |index|
      condition = condition_at(index)
      err = condition.validate
      @errors[index] = err if err
    end
    
    errors?
  end
  
  def sql_conditions
    @sql_conditions  ||= begin
      validate!
      
      if errors?
        all_sql_conditions = [" 1 = 2 "] 
      else
        all_sql_conditions = [""]
        0.upto(size - 1) do |index|
          condition = condition_at(index)
          sql_condition = condition.container.sql_condition
          unless sql_condition
            raise Exception.new("Unsupported operator #{condition.operator_key} for container #{condition.container.class.name}")
          end
          
          if all_sql_conditions[0].size > 0
            all_sql_conditions[0] << ( match.to_sym == :all ? " AND " : " OR ")
          end
          
          all_sql_conditions[0] << sql_condition[0]
          sql_condition[1..-1].each do |c|
            all_sql_conditions << c
          end
        end
      end
      
      all_sql_conditions
    end
  end
  
  def debug_conditions(conds)
    all_conditions = []
    conds.each_with_index do |c, i|
      cond = ""
      if i == 0
        cond << "\"<b>#{c}</b>\""
      else  
        cond << "<br>&nbsp;&nbsp;&nbsp;<b>#{i})</b>&nbsp;"
        if c.is_a?(Array)
          cond << "["
          cond << (c.collect{|v| "\"#{v.strip}\""}.join(", "))
          cond << "]"
        elsif c.is_a?(Date)  
          cond << "\"#{c.strftime("%Y-%m-%d")}\""
        elsif c.is_a?(Time)  
          cond << "\"#{c.strftime("%Y-%m-%d %H:%M:%S")}\""
        elsif c.is_a?(Integer)  
          cond << c.to_s
        else  
          cond << "\"#{c}\""
        end
      end
      
      all_conditions << cond
    end
    all_conditions
  end

  def debug_sql_conditions
    debug_conditions(sql_conditions)
  end

  def saved_filters(include_predefined = true)
    @saved_filters ||= begin
      filters = []
    
      if include_predefined
        filters = predefined_filters(identity)
        if (filters.size > 0)
          filters.insert(0, ["-- Select Predefined Filter --", "-1"])
        end
      end

      if identity
        identity_filters = Wf::Filter.find(:all, :conditions=>["identity_type = ? AND identity_id = ? AND model_class_name = ?", identity.class.name, identity.id, self.model_class_name])
      else
        identity_filters = Wf::Filter.find(:all, :conditions=>["model_class_name = ?", self.model_class_name])
      end
      
      if identity_filters.size > 0
        filters << ["-- Select Saved Filter --", "-2"] if include_predefined
        
        identity_filters.each do |filter|
          filters << [filter.name, filter.id.to_s]
        end
      end
        
      filters
    end
  end
    
  def predefined_filters(identity)
    []
  end
  
  def self.load_predefined_filter(identity, key)
    nil
  end
  
  def self.load_filter(profile, key)
    filter = load_predefined_filter(profile, key)
    filter = Wf::Filter.find_by_id(key.to_i) unless filter
    filter
  end
  
  def before_save
    self.data = serialize_to_params
    self.type = self.class.name
  end
  
  def after_find
    @errors = {}
    deserialize_from_params(self.data)
  end

  def export_formats
    formats = []
    formats << ["-- Generic Formats --", -1]
    Wf::Config.export_formats.each do |frmt|
      formats << [frmt, frmt]
    end
    if custom_formats.size > 0
      formats << ["-- Custom Formats --", -2]
      custom_formats.each do |frmt|
        formats << frmt
      end
    end
    formats
  end

  def custom_format?
    custom_formats.each do |frmt|
      return true if frmt[1].to_sym == format
    end
    false
  end
  
  def custom_formats
    []
  end
  
  def process_custom_format
    ""
  end
end
