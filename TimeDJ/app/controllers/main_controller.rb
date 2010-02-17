class MainController < CityController

  def list
    @cities = City.find(:all)
    @countries = Country.find(:all)
  end

end