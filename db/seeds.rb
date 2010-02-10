# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

###### Location types ######

#making sure that id=1 is always 'misc'
type1 = LocationType.find_by_id(1)
if type1 == nil
  misc = LocationType.create(:id => 1, :name => "misc")
elsif type1.name != "misc"
  misc = type1.update_attributes(:name => "misc")
else
  misc = type1
end

location_type_names = ["Restaurant", "Store"]
location_type_names.each do |location_type_name|
  LocationType.find_or_create_by_name(location_type_name)
end
coffee_shop = LocationType.find_or_create_by_name("Coffee shop")
public_building = LocationType.find_or_create_by_name("Public building")

###### Users ######

User.delete_all
users = User.create([
  {:username => "admin", :email => "admin@talking-points.org", :password => "tpoints", :password_confirmation => "tpoints"},
  {:username => "test", :email => "test@test.com", :password => "tpoints", :password_confirmation => "tpoints"}
])
johndoe = User.create(:username => "johndoe", :email => "john@doe.com", :password => "tpoints", :password_confirmation => "tpoints")
jhilden = User.create(:username => "jhilden", :email => "jakobhilden@gmail.com", :password => "tpoints", :password_confirmation => "tpoints")
ckaufman = User.create(:username => "ckaufman", :email => "kaufmanc@umich.edu", :password => "tpoints", :password_confirmation => "tpoints")

###### Locations ######

Location.delete_all
espresso_royale = Location.create(
  :name => "Espresso Royale",
  :description => "Free wi-fi. Inside there are several distinct seating areas to chat and study. \r\n$2 latte special for any size latte on Wednesday.",
  :location_type => coffee_shop,
  :user => jhilden,
  :lat => '42.275082', :lng => '-83.735580',
  :street => "1101 S. University St.",
  :city => "Ann Arbor",
  :state => "MI",
  :postal_code => "48104",
  :url => 'http://www.espressoroyale.com/location.php?id=20',
  :phone => '734.327.0740',
  :bluetooth_mac => '00194fa4e272'
)
west_hall = Location.create(
  :name => 'West Hall',
  :description => 'West Hall is home of the School of Information''s central administrative offices, classrooms, and some faculty.\r\n\r\nIt''s one of the oldest Building at the University of Michigan, Ann Arbor.\r\n',
  :location_type => public_building,
  :user => johndoe,
  :lat => '42.275309', :lng => '-83.736012',
  :street => '1085 South University Ave.',
  :city => 'Ann Arbor',
  :state => 'MI',
  :postal_code => '48109',
  :country => 'US',
  :url => 'http://si.umich.edu/',
  :phone => '(734) 647-3576'
)
white_house = Location.create(
  :name => 'The White House',
  :description => 'Home of President Obama.',
  :location_type => public_building,
  :user => johndoe,
  :street => '1600 Pennsylvania Ave NW',
  :city => 'Washington',
  :state => 'DC',
  :postal_code => '20500',
  :country => 'US',
  :url => 'http://www.whitehouse.gov/',
  :phone => '(202) 456-1414'
)

###### Comments ######

Comment.delete_all
espresso_royale.comments.create(
  :title => "A nice place",
  :text => "I went there the other day and they were very friendly",
  :user => johndoe
)
espresso_royale.comments.create(
  :title => "Horrible service",
  :text => "I went there the other day and the service was horrible",
  :user => ckaufman
)
west_hall.comments.create(
	:title => "Test Comment",
	:text => "This is a test comment",
	:user => johndoe
)
