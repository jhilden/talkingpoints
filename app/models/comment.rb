class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  
  validates_presence_of :title, :text, :location, :user
  validates_associated :location, :user
end