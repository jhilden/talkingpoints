class AddParentIdToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :parent_id, :integer
  end

  def self.down
    remove_column :locations, :parent_id
  end
end
