# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

location_types = LocationType.create([
  {:name => "Restaurant"},
  {:name => "Store"},
  {:name => "Public building"},
  {:name => "misc"}
])
coffee_shop = LocationType.create(:name => "Coffee shop")

users = User.create([
  {:username => "admin", :email => "admin@talking-points.org"},
  {:username => "johndoe", :email => "john@doe.com"},
  {:username => "test", :email => "test@test.com"}
])
jakob = User.create(:username => "jhilden", :email => "jakobhilden@gmail.com")

espresso_royale = Location.create(
  :name => "Espresso Royale", :description => "A coffee shop",
  :location_type => coffee_shop, :user => jakob,
  :street => "South University", :city => "Ann Arbor"
)