class Country < ActiveRecord::Base
  has_many :cities

  # Yes, this is a cross model method, but it's specific to the model.  Maybe could put this in helper?
  def full_descriptor

    country_city_tz = []  # Empty array for text fields.  Given input USA, should be populated with "San Francisco, USA (PDT)" and "New York, USA (EST)" if all goes well
    # modified the condtions to ignore null value time zones, big speed up for the undefined cites
    cities_w_time_zone = City.find(:all, :select => "distinct time_zone_id, name", :conditions => "cities.country_id = #{self.id} AND time_zone_id IS NOT NULL")

    if (cities_w_time_zone) # Make sure there are any cities in this country

      cities_w_time_zone.each do |city_i|
        if (city_i.time_zone)  # Watch out as NULL is a distinct time zone!! 
          country_city_tz.push("#{city_i.name},#{self.name} (#{city_i.time_zone.name})") 
        end
      end
      
    else
      # If there are no cities with time zones for the country, just return the country name
      country_city_tz = country.name
    end
  
    # Return array of countries
    country_city_tz  
    
  end

end
