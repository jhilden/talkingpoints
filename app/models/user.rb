class User < ActiveRecord::Base
  has_many :locations
  has_many :sections
  has_many :comments
end