class AddUserIdFieldToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :user_id, :integer
  end

  def self.down
  end
end