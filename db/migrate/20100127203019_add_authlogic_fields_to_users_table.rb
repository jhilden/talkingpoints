class AddAuthlogicFieldsToUsersTable < ActiveRecord::Migration
  def self.up
    add_column :users, :persistence_token, :string, :null => false
    add_column :users, :crypted_password,  :string, :null => false
    add_column :users, :password_salt,     :string, :null => false
  end

  def self.down
    remove_column :users, :persistence_token
    remove_column :users, :crypted_password
    remove_column :users, :password_salt
  end
end
