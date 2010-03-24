require 'rss'

class InfoController < ApplicationController
  def about
  end
  
  def blog 
    @feed = RSS::Parser.parse(open('http://blog.talking-points.org/feed').read, false)
  end
  
  def team
  end
  
  def inthenews
  end
  
  def contact
  end
end
