class Location < ActiveRecord::Base
  has_many :comments
  has_many :sections
  belongs_to :user
  belongs_to :location_type
  belongs_to :parent_location, :class_name => "Location"
  has_many :child_locations, :class_name => "Location", :foreign_key => "parent_location_id"
  
  acts_as_mappable
  attr_accessor :distance
  
  validates_presence_of :name, :location_type
  validates_associated :user, :location_type
end