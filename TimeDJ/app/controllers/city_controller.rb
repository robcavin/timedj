class CityController < ApplicationController
  def index
     @cities = City.find(:all)
     @countries = Country.find(:all)   
  end
end
