class ChangeCoordinatesPrecision < ActiveRecord::Migration
  def self.up
    # because google maps is providing coordinates with up to 13 decimal places
    change_column :locations, :lat, :decimal, :precision => 17, :scale => 13
    change_column :locations, :lng, :decimal, :precision => 17, :scale => 13
  end

  def self.down
    change_column :locations, :lat, :decimal, :precision => 15, :scale => 10
    change_column :locations, :lng, :decimal, :precision => 15, :scale => 10
  end
end
