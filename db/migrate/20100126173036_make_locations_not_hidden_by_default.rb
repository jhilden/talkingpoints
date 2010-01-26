class MakeLocationsNotHiddenByDefault < ActiveRecord::Migration
  def self.up
    change_column :locations, :hide, :boolean, :default => false
  end

  def self.down
  end
end
