require File.expand_path('../../../../test_helper', __FILE__)

module WillFilter
  class FilterTest < ActiveSupport::TestCase

    test "boolean container" do
      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:admin,
                :wf_o0=>:is,
                :wf_v0_0=>"1"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 1, filter.conditions.size
      assert_equal 2, filter.sql_conditions.size
      assert_equal " users.admin = ? ", filter.sql_conditions.first
      assert_equal true, filter.sql_conditions.last
      
      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:admin,
                :wf_o0=>:is,
                :wf_v0_0=>"0"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 1, filter.conditions.size
      assert_equal 2, filter.sql_conditions.size
      assert_equal " users.admin = ? ", filter.sql_conditions.first
      assert_equal false, filter.sql_conditions.last
    end

    test "date range container" do
      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:birth_date,
                :wf_o0=>:is_in_the_range,
                :wf_v0_0=>"1971-11-09",
                :wf_v0_1=>"1974-11-09"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 1, filter.conditions.size
      assert_equal 3, filter.sql_conditions.size
      assert_equal " (users.birth_date >= ? and users.birth_date <= ?) ", filter.sql_conditions.first
    end

    test "date time range container" do
      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:created_at,
                :wf_o0=>:is_in_the_range,
                :wf_v0_0=>"1971-11-09 8:00",
                :wf_v0_1=>"1971-11-09 12:00"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 1, filter.conditions.size
      assert_equal 3, filter.sql_conditions.size
      assert_equal " (users.created_at >= ? and users.created_at <= ?) ", filter.sql_conditions.first
    end

    test "date time container" do
      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:created_at,
                :wf_o0=>:is,
                :wf_v0_0=>"1971-11-09 8:00"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 1, filter.conditions.size
      assert_equal 2, filter.sql_conditions.size
      assert_equal " users.created_at = ? ", filter.sql_conditions.first

      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:created_at,
                :wf_o0=>:is_not,
                :wf_v0_0=>"1971-11-09 8:00"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 1, filter.conditions.size
      assert_equal 2, filter.sql_conditions.size
      assert_equal " users.created_at <> ? ", filter.sql_conditions.first

      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:created_at,
                :wf_o0=>:is_after,
                :wf_v0_0=>"1971-11-09 8:00"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 1, filter.conditions.size
      assert_equal 2, filter.sql_conditions.size
      assert_equal " users.created_at > ? ", filter.sql_conditions.first

      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:created_at,
                :wf_o0=>:is_before,
                :wf_v0_0=>"1971-11-09 8:00"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 1, filter.conditions.size
      assert_equal 2, filter.sql_conditions.size
      assert_equal " users.created_at < ? ", filter.sql_conditions.first
    end

    test "date container" do
      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:birth_date,
                :wf_o0=>:is,
                :wf_v0_0=>"1971-11-09"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 1, filter.conditions.size
      assert_equal 2, filter.sql_conditions.size
      assert_equal " users.birth_date = ? ", filter.sql_conditions.first

      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:birth_date,
                :wf_o0=>:is_not,
                :wf_v0_0=>"1971-11-09 8:00"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 1, filter.conditions.size
      assert_equal 2, filter.sql_conditions.size
      assert_equal " users.birth_date <> ? ", filter.sql_conditions.first

      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:birth_date,
                :wf_o0=>:is_after,
                :wf_v0_0=>"1971-11-09 8:00"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 1, filter.conditions.size
      assert_equal 2, filter.sql_conditions.size
      assert_equal " users.birth_date > ? ", filter.sql_conditions.first

      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:birth_date,
                :wf_o0=>:is_before,
                :wf_v0_0=>"1971-11-09 8:00"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 1, filter.conditions.size
      assert_equal 2, filter.sql_conditions.size
      assert_equal " users.birth_date < ? ", filter.sql_conditions.first
    end

    test "numeric delimited container" do
      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:id,
                :wf_o0=>:is_in,
                :wf_v0_0=>"1,2,3,4,5,6"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 1, filter.conditions.size
      assert_equal 2, filter.sql_conditions.size
      assert_equal " users.id in (?) ", filter.sql_conditions.first
    end

    test "numeric range container" do
      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:id,
                :wf_o0=>:is_in_the_range,
                :wf_v0_0=>"1",
                :wf_v0_1=>"10"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 1, filter.conditions.size
      assert_equal 3, filter.sql_conditions.size
      assert_equal " (users.id >= ? and users.id <= ?) ", filter.sql_conditions.first
    end

    test "numeric container" do
      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:id,
                :wf_o0=>:is,
                :wf_v0_0=>"1"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 1, filter.conditions.size
      assert_equal 2, filter.sql_conditions.size
      assert_equal " users.id = ? ", filter.sql_conditions.first

      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:id,
                :wf_o0=>:is_not,
                :wf_v0_0=>"1"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 1, filter.conditions.size
      assert_equal 2, filter.sql_conditions.size
      assert_equal " users.id <> ? ", filter.sql_conditions.first

      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:id,
                :wf_o0=>:is_less_than,
                :wf_v0_0=>"1"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 1, filter.conditions.size
      assert_equal 2, filter.sql_conditions.size
      assert_equal " users.id < ? ", filter.sql_conditions.first

      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:id,
                :wf_o0=>:is_greater_than,
                :wf_v0_0=>"1"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 1, filter.conditions.size
      assert_equal 2, filter.sql_conditions.size
      assert_equal " users.id > ? ", filter.sql_conditions.first
    end

    test "single date container" do
      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:created_at,
                :wf_o0=>:is_on,
                :wf_v0_0=>"1971-11-09"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 1, filter.conditions.size
      assert_equal 3, filter.sql_conditions.size
      assert_equal " users.created_at >= ? and users.created_at < ? ", filter.sql_conditions.first

      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:created_at,
                :wf_o0=>:is_not_on,
                :wf_v0_0=>"1971-11-09"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 1, filter.conditions.size
      assert_equal 3, filter.sql_conditions.size
      assert_equal " users.created_at < ? and users.created_at >= ? ", filter.sql_conditions.first
    end
   
    test "text delimited container" do
      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:name,
                :wf_o0=>:is_in,
                :wf_v0_0=>"a,b,c,d,e,f,g"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 1, filter.conditions.size
      assert_equal 2, filter.sql_conditions.size
      assert_equal " users.name in (?) ", filter.sql_conditions.first

      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:name,
                :wf_o0=>:is_not_in,
                :wf_v0_0=>"a,b,c,d,e,f,g"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 1, filter.conditions.size
      assert_equal 2, filter.sql_conditions.size
      assert_equal " users.name not in (?) ", filter.sql_conditions.first
    end
  
    test "text container" do
      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:name,
                :wf_o0=>:is,
                :wf_v0_0=>"Mike"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 2, filter.sql_conditions.size
      assert_equal " users.name = ? ", filter.sql_conditions.first
      assert_equal "Mike", filter.sql_conditions.last

      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:name,
                :wf_o0=>:is_not,
                :wf_v0_0=>"Mike"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 2, filter.sql_conditions.size
      assert_equal " users.name <> ? ", filter.sql_conditions.first

      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:name,
                :wf_o0=>:contains,
                :wf_v0_0=>"Mike"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 2, filter.sql_conditions.size
      assert_equal " users.name like ? ", filter.sql_conditions.first

      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:name,
                :wf_o0=>:does_not_contain,
                :wf_v0_0=>"Mike"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 2, filter.sql_conditions.size
      assert_equal " users.name not like ? ", filter.sql_conditions.first

      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:name,
                :wf_o0=>:starts_with,
                :wf_v0_0=>"Mike"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 2, filter.sql_conditions.size
      assert_equal " users.name like ? ", filter.sql_conditions.first
      assert_equal "Mike%", filter.sql_conditions.last

      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:name,
                :wf_o0=>:ends_with,
                :wf_v0_0=>"Mike"}
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 2, filter.sql_conditions.size
      assert_equal " users.name like ? ", filter.sql_conditions.first
      assert_equal "%Mike", filter.sql_conditions.last
    end  
    
    test "compound filter" do
      params = {:wf_type=>"UserFilter", 
                :wf_c0=>:name,
                :wf_o0=>:is,
                :wf_v0_0=>"Mike",
                :wf_c1=>:birth_date,
                :wf_o1=>:is_before,
                :wf_v1_0=>"1971-11-09 8:00"
                }
      filter = WillFilter::Filter.deserialize_from_params(params)
      assert_equal 3, filter.sql_conditions.size
      assert_equal " users.name = ?  AND  users.birth_date < ? ", filter.sql_conditions.first
    end
    
  end
end