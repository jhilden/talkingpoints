class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :locations
  has_many :sections
  has_many :comments
  
  validates_uniqueness_of :username, :email
  
  def is_admin?
    return self.role == "admin"
  end
end