class City < ActiveRecord::Base
  belongs_to :country
  belongs_to :time_zone
  
  def name_w_country
    self.name + "," + self.country.name
  end
end
