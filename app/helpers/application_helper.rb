require 'rss'
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def blog_feed
  	  RSS::Parser.parse(open('http://blog.talking-points.org/feed').read, false)
  end

end
