class ModelFilterCondition

  attr_accessor :filter, :key, :operator_key, :container

  def initialize(filter, key, operator_key, container_class, values)
    super()

    @filter = filter
    @key = key
    @operator_key = operator_key
    container_klass = "#{container_class.to_s.camelcase}Container".constantize
    @container = container_klass.new(@filter, @key, @operator_key, values)
  end

  def validate
    @container.validate
  end

  def serialize_to_params(params, index)
    params["#{ModelFilter::HTML[:condition]}_#{index}"] = key
    params["#{ModelFilter::HTML[:operator]}_#{index}"] = operator_key
    container.serialize_to_params(params, index)
    params
  end

end
