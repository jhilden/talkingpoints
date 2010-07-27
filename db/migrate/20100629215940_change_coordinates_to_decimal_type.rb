class ChangeCoordinatesToDecimalType < ActiveRecord::Migration
  def self.up
    change_column :locations, :lat, :decimal, :precision => 19, :scale => 15
    change_column :locations, :lng, :decimal, :precision => 19, :scale => 15
  end

  def self.down
    change_column :locations, :lat, :string
    change_column :locations, :lat, :string
  end
end
