class AddRankToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :rank, :float
  end
end
