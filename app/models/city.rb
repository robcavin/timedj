class City < ActiveRecord::Base
  belongs_to :country
  belongs_to :time_zone
  belongs_to :region
  
  # construct the full text you want to print out on an auto_complete
  # name, country, (time_zone)
  def full_descriptor
    city_country_tz = "<img src='/images/flags/#{self.country.country_code.downcase}.png' /> #{self.utf8_name}" # we will search on the ascii name but display the UTF8 one
    
    # if city has a region mapped in the db, print it out
    city_country_tz += ", #{self.region.name}" if (self.region)
    
    # If the city has a country mapped in the db, print it out
    city_country_tz += ", #{self.country.name}" if (self.country)
    
    # If the city has a time zone mapped in the db, print it out
    city_country_tz += " (#{self.time_zone.name})" if (self.time_zone) 
    
    # this is a bad hack to make sure the seperator value is include
    # need to figure out how auto-complete can append this once a selection is selected
    city_country_tz += "; "
    
    # Return the array
    city_country_tz
  end
  
end
