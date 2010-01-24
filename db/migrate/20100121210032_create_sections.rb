class CreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.string :name
      t.text :text
      t.integer :location_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sections
  end
end
