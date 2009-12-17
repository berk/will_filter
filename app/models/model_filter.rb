class ModelFilter < ActiveRecord::Base
  
  OPERATOR_ORDER = [  :is, :is_not, :is_on, :is_in, 
                      :is_provided,     :is_not_provided,
                      :is_after,        :is_before,       :is_in_the_range,
                      :contains,        :does_not_contain, 
                      :starts_with,     :ends_with, 
                      :is_greater_than, :is_less_than,
                      :is_filtered_by, 
  ]
  
  CONTAINERS_BY_SQL_TYPE = {
    ["bigint", "numeric", "smallint", "integer", "int", "double"]   => [:nil, :numeric, :numeric_range, :numeric_delimited],
    ["timestamp", "datetime"]                             => [:nil, :date_time, :date_time_range, :single_date],
    ["date"]                                              => [:nil, :date, :date_range],
    ["character", "varchar", "text", "text[]", "bytea"]   => [:nil, :text, :text_delimited],
    ["text"]                                              => [:nil, :text],
    ["boolean", "tinyint"]                                => [:nil, :boolean],
  }
  
  FORMATS = [:html, :table, :csv, :xml, :json]
  
  HTML = {
    :condition      => 'mf_c',
    :operator       => 'mf_co',
    :value          => 'mf_cv',
    :match          => 'mf_match',
    :type           => 'mf_type',
    :name           => 'mf_name',
    :format         => 'mf_format',
    :fields         => 'mf_fields',
    :model          => 'mf_model',
    :id             => 'mf_id',
    :key            => 'mf_key',
    :order          => 'mf_order',
    :order_type     => 'mf_order_type',
    :per_page       => 'mf_per_page',
    :identity_type  => 'mf_identity_type',
    :identity_id    => 'mf_identity_id',
  }
  
  DEFAULT_HTML_LABELS = {
    :title                => "Filter Conditions",
    :order                => "Sort By:",
    :per_page             => "Page Size:",
    :msg_empty            => "You haven't added any filter conditions, so all of the results were returned. Use the \"Add\" button in the bottom left corner to add a new condition or select a predefined filter from a drop-down list above. ", 
    :msg_loading          => "Loading...",
    :msg_filter_changed   => "(filter has been modified and must be re-submitted before it can be saved)",
    :msg_match_before     => "Match",
    :msg_match_after      => "of the following conditions:",
    
    :msg_predefined_filters  => "-- Select Predefined Filter --",
    :msg_saved_filters       => "-- Select Saved Filter --",
    
    :msg_prompt_name      => "Please provide the name for the filter:",
    :msg_prompt_delete    => "Are you sure you want to delete this filter?",
    
    :btn_add_condition    => "+ Add",
    :btn_clear            => "- Clear",
    :btn_delete           => "Delete Filter",
    :btn_update           => "Update Filter",
    :btn_save             => "Save As New...",
    :btn_search           => "Submit Filter",
  }
  
  belongs_to  :identity, :polymorphic => :subclass
  serialize   :data
  
  attr_accessor :conditions, :match, :key, :errors
  attr_accessor :per_page
  attr_accessor :order, :order_type
  attr_accessor :fields, :format
  
  def initialize(new_model_class_name = nil, new_identity = nil)
    super()
    
    self.model_class_name = new_model_class_name
    self.identity = new_identity
    
    @conditions = []
    @match = :all
    @key = ''
    @errors = {}
    
    @per_page = default_per_page
    @page = 1
    @order_type = default_order_type
    @order = default_order
    
    @exportable = true
    @format = :html
    @fields = []
  end
  
  def exportable?
    @exportable
  end

  def show_save_options?
    true
  end
  
  def valid_format?
    FORMATS.include?(format)
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
    CONTAINERS_BY_SQL_TYPE.each do |types, containers|
      return containers if types.include?(type)    
    end
    raise Exception.new("Unsupported data type #{type}")
  end
  
  def default_condition_definition_for(name, sql_data_type)
    type = sql_data_type.split(" ").first.split("(").first.downcase
    containers = container_by_sql_type(type)
    operators = {}
    containers.each do |c|
      container_klass = "#{c.to_s.camelcase}Container".constantize
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
   (OPERATOR_ORDER.collect{|o| o.to_s}) & (opers.keys.collect{|o| o.to_s}).sort
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
  
  def add_condition(condition_key, operator_key, values=nil)
    add_condition_at(size, condition_key, operator_key, values)
  end
  
  def valid_operator?(condition_key, operator_key)
    condition_key = condition_key.to_sym if condition_key.is_a?(String)
    opers = definition[condition_key]
    return false unless opers
    opers[operator_key]!=nil
  end
  
  def add_condition_at(index, condition_key, operator_key, values=nil)
    values = [values] unless values.instance_of?(Array)
    values = values.collect{|v| v.to_s}

    condition_key = condition_key.to_sym if condition_key.is_a?(String)
    
    unless valid_operator?(condition_key, operator_key)
      opers = definition[condition_key]
      operator_key = first_sorted_operator(opers)
    end
    
    condition = ModelFilterCondition.new(self, condition_key, operator_key, container_for(condition_key, operator_key), values)
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
    '30'
  end
  
  def condition_at(index)
    @conditions[index]
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
    params[HTML[:type]] = self.class.name
    params[HTML[:match]] = match
    params[HTML[:model]] = model_class_name
    params[HTML[:order]] = order
    params[HTML[:order_type]] = order_type
    params[HTML[:per_page]] = per_page
    
    0.upto(size - 1) do |index|
      condition = condition_at(index)
      condition.serialize_to_params(params, index)
    end
    params
  end
  
  def self.deserialize_from_params(params)
    params[HTML[:type]] = self.name unless params[HTML[:type]]
    identity = nil
    unless params[HTML[:identity_type]].blank?
      identity = params[HTML[:identity_type]].constantize.find(params[HTML[:identity_id]])
    end
    
    if params[HTML[:type]] == 'ModelFilter'
      filter = params[HTML[:type]].constantize.new(params[HTML[:model]], identity)
    else
      filter = params[HTML[:type]].constantize.new(identity)
    end
    
    filter.deserialize_from_params(params)
    filter
  end
  
  def deserialize_from_params(params)
    @conditions = []
    @match                = params[HTML[:match]]  || :all
    @key                  = params[HTML[:key]]    || self.id.to_s
    self.model_class_name = params[HTML[:model]] if params[HTML[:model]]
    
    @per_page             = params[HTML[:per_page]]   || default_per_page
    @order_type           = params[HTML[:order_type]] || default_order_type
    @order                = params[HTML[:order]]      || default_order
    
    self.id=    params[HTML[:id]].to_i  unless params[HTML[:id]].blank?
    self.name=  params[HTML[:name]]     unless params[HTML[:name]].blank?
    
    self.fields = []
    unless params[HTML[:fields]].blank?
      params[HTML[:fields]].split(",").each do |fld|
        self.fields << fld.to_sym
      end
    end

    if params[HTML[:format]].blank?
      self.format = :html
    else  
      self.format = params[HTML[:format]].to_sym
    end
    
    unless params["model_changed"]
      i = 0
      while params["#{HTML[:condition]}_#{i}"] do
        conditon_key = params["#{HTML[:condition]}_#{i}"]
        operator_key = params["#{HTML[:operator]}_#{i}"]
        values = []
        j = 0
        while params["#{HTML[:value]}_#{i}_#{j}"] do
          values << params["#{HTML[:value]}_#{i}_#{j}"]
          j += 1
        end
        i += 1
        add_condition(conditon_key, operator_key.to_sym, values)
      end
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
          filters.insert(0, [label_for(:msg_predefined_filters), "-1"])
        end
      end

      if identity
        identity_filters = ModelFilter.find(:all, :conditions=>["identity_type = ? AND identity_id = ? AND model_class_name = ?", identity.class.name, identity.id, self.model_class_name])
      else
        identity_filters = ModelFilter.find(:all, :conditions=>["model_class_name = ?", self.model_class_name])
      end
      
      if identity_filters.size > 0
        filters << [label_for(:msg_saved_filters), "-2"] if include_predefined
        
        identity_filters.each do |filter|
          filters << [filter.name, filter.id.to_s]
        end
      end
        
      filters
    end
  end
    
  def label_for(key)
    DEFAULT_HTML_LABELS[key]    
  end
  
  def predefined_filters(identity)
    []
  end
  
  def self.load_predefined_filter(identity, key)
    nil
  end
  
  def self.load_filter(profile, key)
    filter = load_predefined_filter(profile, key)
    filter = ModelFilter.find_by_id(key.to_i) unless filter
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
    ModelFilter::FORMATS.each do |frmt|
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
