class ModelFilterCache
  
  def self.activate(data)
    @instance = ModelFilterCache.new(data) 
  end
  
  def self.active
    @instance
  end
  
  def initialize(data)
    @data = data
  end  
end