class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  
  validates_presence_of :title, :text, :location_id, :user_id
end