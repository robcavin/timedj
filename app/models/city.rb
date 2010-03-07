class City < ActiveRecord::Base
  belongs_to :country
  belongs_to :time_zone
  
  def full_descriptor
    city_country_tz = self.name
    
    # If the city has a country mapped in the db, print it out
    city_country_tz += ", #{self.country.name}" if (self.country)
    
    # If the city has a time zone mapped in the db, print it out
    city_country_tz += " (#{self.time_zone.name})" if (self.time_zone) 
    
    # Return the array
    city_country_tz
  end
  
end
