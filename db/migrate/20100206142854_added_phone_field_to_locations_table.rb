class AddedPhoneFieldToLocationsTable < ActiveRecord::Migration
  def self.up
    add_column :locations, :phone, :string
  end

  def self.down
    remove_column :locations, :phone
  end
end
