class CreateModelFilters < ActiveRecord::Migration
  def self.up
    create_table :model_filters do |t|
      t.string      :type
      t.string      :name
      t.text        :data
      t.string      :identity_type
      t.integer     :identity_id
      t.string      :model_class_name
      
      t.timestamps
    end
    
    add_index :model_filters, [:identity_type, :identity_id]
  end
  
  def self.down
    drop_table :model_filters
  end
end
