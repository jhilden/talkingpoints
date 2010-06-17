require 'rss'

class InfoController < ApplicationController
  def index
    @locations = Location.find(:all, :order => 'created_at', :limit => 5, :conditions => 'hidden = 0')
  end
  
  def about
  end
  
  def blog 
    @feed = RSS::Parser.parse(open('http://blog.talking-points.org/feed').read, false)
  end
  
  def team
  end
  
  def news
  end
  
  def contact
  end
  
  def howitworks
  end
  
  def features
  end
  
  def gestures
  end
  
  def service
  end
  
  def getinvolved
  end
  
  def volunteer
  end
  
  def donate
  end
  
end
