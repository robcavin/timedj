class QueryController < ApplicationController

  auto_complete_for :city, :name

  def index
     @cities = City.find(:all)
     @countries = Country.find(:all)   
  end
  
end
