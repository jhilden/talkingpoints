class LocationType < ActiveRecord::Base
  has_many :locations
  
  validates_uniqueness_of :name
end