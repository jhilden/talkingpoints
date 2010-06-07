class ChangeHideToHidden < ActiveRecord::Migration
  def self.up
    rename_column :locations, :hide, :hidden
  end

  def self.down
    rename_column :locations, :hidden, :hide
  end
end
