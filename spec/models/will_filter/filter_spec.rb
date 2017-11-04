require File.expand_path('../../spec_helper', File.dirname(__FILE__))

describe WillFilter::Filter do
  describe 'creating new filter' do
    context 'when filter extensions are enabled' do
      context 'creating base filter' do
        it 'should raise an exception' do
          # WillFilter::Config.any_instance.stub(:require_filter_extensions?).and_return(true)
          # expect {WillFilter::Filter.new(User)}.should raise_error
        end
      end
      context 'creating extended filter' do
        it 'should be fine' do
          WillFilter::Config.any_instance.stub(:require_filter_extensions?).and_return(true)
          filter = UserFilter.new
          filter.should be_a(UserFilter)
          filter.model_class.should eq(User)
        end
      end
    end

    context 'when filter extensions are disabled' do
      it "should create a filter" do
        WillFilter::Config.any_instance.stub(:require_filter_extensions?).and_return(false)
        filter = WillFilter::Filter.new(User)
        filter.should be_a(WillFilter::Filter)
        filter.model_class_name.should eq('User')
        filter.model_class.should eq(User)
        filter.table_name.should eq('users')
      end
    end
  end

  describe 'filter methods' do
    before :all do
      @filter = WillFilter::Filter.new(User)
    end

    it 'definition should contain the right attributes' do
      @filter.definition.keys.should eq([:id, :first_name, :last_name, :birthday, :sex, :created_at, :updated_at])
    end

    context 'container_by_sql_type' do
      it 'should map the right containers' do
        ['bigint', 'numeric', 'smallint', 'integer', 'int'].each do |type|
          @filter.container_by_sql_type(type).should eq(["nil", "numeric", "numeric_range", "numeric_delimited"])
        end

        ['float', 'double'].each do |type|
          @filter.container_by_sql_type(type).should eq(["nil", "double", "double_range", "double_delimited"])
        end

        ['timestamp', 'datetime'].each do |type|
          @filter.container_by_sql_type(type).should eq(["nil", "date_time", "date_time_range", "single_date"])
        end

        ['date'].each do |type|
          @filter.container_by_sql_type(type).should eq(["nil", "date", "date_range"])
        end

        ['char', 'character', 'varchar', 'text', 'text[]', 'bytea'].each do |type|
          @filter.container_by_sql_type(type).should eq(["nil", "text", "text_delimited"])
        end

        ['boolean', 'tinyint'].each do |type|
          @filter.container_by_sql_type(type).should eq(["nil", "boolean"])
        end
      end
    end

    context 'default_condition_definition_for' do
      it 'should map the right containers' do
        @filter.default_condition_definition_for('id', 'int').should eq({
                                                                            :is_provided => "nil",
                                                                            :is_not_provided => "nil",
                                                                            :is => "numeric",
                                                                            :is_not => "numeric",
                                                                            :is_less_than => "numeric",
                                                                            :is_greater_than => "numeric",
                                                                            :is_in_the_range => "numeric_range",
                                                                            :is_in => "numeric_delimited",
                                                                            :is_filtered_by => :filter_list
                                                                        })

        @filter.default_condition_definition_for('first_name', 'varchar').should eq({
                                                                                        :is_provided => "nil",
                                                                                        :is_not_provided => "nil",
                                                                                        :is => "text",
                                                                                        :is_not => "text",
                                                                                        :contains => "text",
                                                                                        :does_not_contain => "text",
                                                                                        :starts_with => "text",
                                                                                        :ends_with => "text",
                                                                                        :is_in => "text_delimited",
                                                                                        :is_not_in => "text_delimited"
                                                                                    })
      end
    end

    context 'operator sorting' do
      it 'should sort the operators according to default sort' do
        WillFilter::Config.operator_order.should eq([
                                                        "is",
                                                        "is_not",
                                                        "is_on",
                                                        "is_in",
                                                        "is_provided",
                                                        "is_not_provided",
                                                        "is_after",
                                                        "is_before",
                                                        "is_in_the_range",
                                                        "contains",
                                                        "does_not_contain",
                                                        "starts_with",
                                                        "ends_with",
                                                        "is_greater_than",
                                                        "is_less_than",
                                                        "is_filtered_by"
                                                    ])

        @filter.sorted_operators({
                                     :is_provided => "nil",
                                     :is_not_provided => "nil",
                                     :is => "numeric",
                                     :is_not => "numeric",
                                     :is_less_than => "numeric",
                                     :is_greater_than => "numeric",
                                     :is_in_the_range => "numeric_range",
                                     :is_in => "numeric_delimited",
                                     :is_filtered_by => :filter_list
                                 }).should eq([
                                                  "is",
                                                  "is_not",
                                                  "is_in",
                                                  "is_provided",
                                                  "is_not_provided",
                                                  "is_in_the_range",
                                                  "is_greater_than",
                                                  "is_less_than",
                                                  "is_filtered_by"
                                              ])
      end
    end
  end

  describe 'serialization' do
    context 'serializing a default filter with no params' do
      before :all do
        @filter = WillFilter::Filter.new(User)
      end

      it 'should create a default filter hash' do
        @filter.to_params.should eq({"wf_type" => "WillFilter::Filter",
                                     "wf_match" => :all,
                                     "wf_model" => "User",
                                     "wf_order" => "id",
                                     "wf_order_type" => "desc",
                                     "wf_per_page" => 100,
                                     "wf_export_fields" => "",
                                     "wf_export_format" => :html}
                                 )
      end
    end

    context 'serializing a filter with conditions' do
      before :all do
        @filter = WillFilter::Filter.new(User)
        @filter.add_condition(:first_name, :is, "Alex")
        @filter.add_condition(:sex, :is, "male")
      end

      it 'should create a default filter hash' do
        @filter.to_params.should eq({
                                        "wf_type" => "WillFilter::Filter",
                                        "wf_match" => :all,
                                        "wf_model" => "User",
                                        "wf_order" => "id",
                                        "wf_order_type" => "desc",
                                        "wf_per_page" => 100,
                                        "wf_export_fields" => "",
                                        "wf_export_format" => :html,
                                        "wf_c0" => :first_name,
                                        "wf_o0" => :is,
                                        "wf_v0_0" => "Alex",
                                        "wf_c1" => :sex,
                                        "wf_o1" => :is,
                                        "wf_v1_0" => "male"
                                    })
      end
    end

    context 'serializing a default filter with params' do
      before :all do
        @filter = WillFilter::Filter.new(User)
      end

      it 'should create a default filter hash' do
        @filter.to_params(:extra => 'value').should eq({
                                                           "wf_type" => "WillFilter::Filter",
                                                           "wf_match" => :all,
                                                           "wf_model" => "User",
                                                           "wf_order" => "id",
                                                           "wf_order_type" => "desc",
                                                           "wf_per_page" => 100,
                                                           "wf_export_fields" => "",
                                                           "wf_export_format" => :html,
                                                           "extra" => "value"
                                                       })
      end
    end
  end

  describe 'deserialization' do

    context 'deserializing a filter with conditions' do
      before :all do
        @filter = WillFilter::Filter.new(User)
      end

      it 'should create a default filter hash' do
        @filter.from_params({
                                "wf_type" => "WillFilter::Filter",
                                "wf_match" => :all,
                                "wf_model" => "User",
                                "wf_order" => "first_name",
                                "wf_order_type" => "asc",
                                "wf_per_page" => 30,
                                "wf_export_fields" => "",
                                "wf_export_format" => :html,
                                "wf_c0" => :first_name,
                                "wf_o0" => :is,
                                "wf_v0_0" => "Alex",
                                "wf_c1" => :sex,
                                "wf_o1" => :is,
                                "wf_v1_0" => "male"
                            })

        @filter.order.should eq('first_name')
        @filter.order_type.should eq('asc')
        @filter.conditions.size.should eq(2)
        @filter.conditions.first.key.should eq(:first_name)
        @filter.conditions.first.operator.should eq(:is)
      end
    end

  end

end
