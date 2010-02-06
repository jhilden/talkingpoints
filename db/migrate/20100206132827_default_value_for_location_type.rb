class DefaultValueForLocationType < ActiveRecord::Migration
  def self.up
    change_column :locations, :location_type_id, :integer, :default => 1
  end

  def self.down
  end
end
