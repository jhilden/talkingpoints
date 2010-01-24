class Location < ActiveRecord::Base
  has_many :comments
  has_many :sections
  belongs_to :user
  belongs_to :location_type
end