class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :name
      t.text :description
      t.integer :location_type_id
      t.string :bluetooth_mac
      t.string :wifi_mac
      t.string :lat
      t.string :lng
      t.string :street
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.string :url
      t.boolean :hide

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
