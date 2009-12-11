class FqlFilter < ModelFilter

  attr_accessor :facebook_session
  
  def initialize(facebook_session = nil)
    super
    
    @facebook_session = facebook_session
  end

  def fql_conditions
    @fql_conditions  ||= begin
      validate!
      
      if errors?
        all_conditions = [" 1 = 2 "] 
      else
        all_conditions = [""]
        
        0.upto(size - 1) do |index| 
          cond = condition_at(index) 
          next unless fql_condition?(cond)
          
          condition = cond.container.fql_condition 
          raise Exception.new("Unsupported condition #{condition}") if condition == nil
         
          if all_conditions[0].size > 0
             all_conditions[0] << ( match == "all" ? " AND " : " OR ") 
          end
           
          all_conditions[0] << condition[0]
          condition[1..-1].each do |c|
            all_conditions << c
          end  
        end
      end
      all_conditions
    end
  end  

  def fql_condition?(cond)
    true
  end
  
  def condition_met?(cond, record)
    true
  end
  
  def post_process_conditions(records)
    filtered = []
    records.each do |record|
      conditions_met = []
      
      0.upto(size - 1) do |index|
        cond = condition_at(index) 
        conditions_met << condition_met?(cond, record)
      end
      
      if conditions_met.size > 0
        next if match == "all" and conditions_met.include?(false)
        next unless conditions_met.include?(true)        
      end  
      
      filtered << record 
    end
    filtered
  end
  
  def fql_table_fields
    ["uid", "first_name", "last_name", "profile_url", "birthday", "sex"]
  end
  
  def fql_table_name
    "user"
  end
  
  def required_condition(uid)
    " uid IN (SELECT uid2 FROM friend WHERE uid1=#{uid}) "
  end
  
  def fql_query(uid)
    fql = "SELECT #{fql_table_fields.join(", ")} FROM #{fql_table_name} WHERE "

    conditions = fql_conditions
    
    fql_str = conditions[0]
    has_params = fql_str.index('?')

    param_index = 1
    while has_params do 
      param_value = conditions[param_index]
      
      if param_value.is_a?(String)
        fql_str.sub!('?', "\"#{normalized_value(param_value)}\"")
      elsif param_value.is_a?(Array)
        vals = []
        param_value.each do |v|
          if v.is_a?(String)
            vals << "\"#{normalized_value(v)}\""  
          else
            vals << "#{v}"  
          end
        end
        fql_str.sub!('?', vals.join(", "))
      else
        fql_str.sub!('?', "#{param_value}")
      end
      
      param_index += 1
      has_params = fql_str.index('?', has_params)
    end
    
    if fql_str.strip.size > 0
      fql << "(" << fql_str << ")"
      fql << " AND "
    end  
    
    fql << required_condition(uid)
    fql
  end  
  
  def normalized_value(value)
    value.strip.sub("\"","\\\"")
  end
  
  def debug_fql_conditions
    debug_conditions(fql_conditions)
  end
  
end
