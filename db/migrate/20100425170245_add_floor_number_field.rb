class AddFloorNumberField < ActiveRecord::Migration
  def self.up
    add_column :locations, :floor_number, :integer
  end

  def self.down
    remove_column :locations, :floor_number
  end
end
