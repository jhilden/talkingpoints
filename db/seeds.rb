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

location_type_names = ["Restaurant", "Store", "Public building"]
location_type_names.each do |location_type_name|
  LocationType.find_or_create_by_name(location_type_name)
end
coffee_shop = LocationType.find_or_create_by_name("Coffee shop")

###### Users ######

User.delete_all
users = User.create([
  {:username => "admin", :email => "admin@talking-points.org", :password => "tpoints", :password_confirmation => "tpoints"},
  {:username => "test", :email => "test@test.com", :password => "tpoints", :password_confirmation => "tpoints"}
])
johndoe = User.create(:username => "johndoe", :email => "john@doe.com", :password => "tpoints", :password_confirmation => "tpoints")
jhilden = User.create(:username => "jhilden", :email => "jakobhilden@gmail.com", :password => "tpoints", :password_confirmation => "tpoints")

###### Locations ######

Location.delete_all
espresso_royale = Location.create(
  :name => "Espresso Royale", :description => "A coffee shop",
  :location_type => coffee_shop, :user => jhilden,
  :street => "South University", :city => "Ann Arbor"
)

###### Comments ######

Comment.delete_all
Comment.create(
  :title => "A nice place",
  :text => "I went there the other day and they were very friendly",
  :user => johndoe,
  :location_id => 1
)

