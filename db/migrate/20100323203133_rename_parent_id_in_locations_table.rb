class RenameParentIdInLocationsTable < ActiveRecord::Migration
  def self.up
    rename_column :locations, :parent_id, :parent_location_id
  end

  def self.down
    rename_column :locations, :parent_location_id, :parent_id
  end
end
