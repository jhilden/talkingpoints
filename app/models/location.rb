class Location < ActiveRecord::Base
  has_many :comments
  has_many :sections
  belongs_to :user
  belongs_to :location_type
  
  validates_presence_of :name, :location_type
  validates_associated :user, :location_type
end