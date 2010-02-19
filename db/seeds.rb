# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

countries = Country.create([{ :name => 'USA' }, { :name => 'Japan' }, { :name => 'India' }])
City.create(:name => 'San Francisco', :country => Country.find(:first, :conditions => { :name => 'India' }) )
City.create(:name => 'New York', :country => Country.find(:first, :conditions => { :name => 'USA' }) )
City.create(:name => 'Tokyo', :country => Country.find(:first, :conditions => "name = 'Japan'") )

City.update(City.find(:first, :conditions => "name = 'San Francisco'"), :country => Country.find(:first, :conditions => { :name => 'USA' }))