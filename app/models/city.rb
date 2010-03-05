class City < ActiveRecord::Base
  belongs_to :country
  belongs_to :time_zone
  
  def full_descriptor
    city_country_tz = self.name + ", " + self.country.name
    
    # If the city has a time zone mapped in the db, print it out
    city_country_tz += " (#{self.time_zone.name})" if (self.time_zone) 
  end
  
end
