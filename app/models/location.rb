class Location < ActiveRecord::Base
  has_many :comments
  has_many :sections
  belongs_to :user
  belongs_to :location_type
  belongs_to :parent_location, :class_name => "Location"
  has_many :child_locations, :class_name => "Location", :foreign_key => "parent_location_id"
  
  acts_as_mappable
  
  validates_presence_of :name, :location_type
  validates_associated :user, :location_type
  
  if RAILS_ENV == 'production'
    define_index do
      indexes :name
      indexes description
      indexes sections.name
      indexes sections.text
      indexes street
      indexes city
      indexes url
      indexes location_type.name
      indexes comments.title
      indexes comments.text
      indexes user.username
    end
  end
  
  def address_empty?
    if !self.street.blank? or !self.city.blank? or !self.state.blank? or !self.postal_code.blank?
      return false
    else
      return true
    end
  end
  
  # automatically detects which id (TPID, bluetooth MAC, ...) was passed in and finds the corresponding location
  def self.find_by_automatic(id, args = {})
    if id.match(/^([0-9a-f]{2}([:]|$)){6}$/)
      args[:conditions] = ["bluetooth_mac = ? OR bluetooth_mac = ?", id, id.tr(':', '')]
      @location = Location.find(:first, args)
       
    else
      @location = Location.find_by_id(id, args)
    end
    
    return @location
  end
end
