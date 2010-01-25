class Section < ActiveRecord::Base
  belongs_to :location
  
  validates_presence_of :name, :text, :location_id
end
