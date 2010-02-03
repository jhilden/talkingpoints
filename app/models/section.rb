class Section < ActiveRecord::Base
  belongs_to :location
  belongs_to :user
  
  validates_presence_of :name, :text, :location, :user
  validates_associated :location, :user
end
