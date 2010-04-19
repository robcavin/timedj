class Country < ActiveRecord::Base
  has_many :cities

  # Yes, this is a cross model method, but it's specific to the model.  Maybe could put this in helper?
  def full_descriptor

    country_city_tz = []  # Empty array for text fields.  Given input USA, should be populated with "San Francisco, USA (PDT)" and "New York, USA (EST)" if all goes well
    # modified the condtions to ignore null value time zones, big speed up for the undefined cites
    cities_w_time_zone = City.find(:all, :select => "distinct time_zone_id", :conditions => "cities.country_id = #{self.id} AND time_zone_id IS NOT NULL")    

    if (cities_w_time_zone) # Make sure there are any cities in this country

      cities_w_time_zone.each do |city_i|
        if (city_i.time_zone)  # Watch out as NULL is a distinct time zone!! (this probably isn't needed anymore
          # we just have the timezone so find the city the greatest population for that timezone
          top_pop_city_w_time_zone = City.find(:all, :conditions => "cities.country_id = #{self.id} AND time_zone_id = #{city_i.time_zone_id}", :order => "population DESC", :limit => 1).first
          if (top_pop_city_w_time_zone)
            thing_to_push = "<img src='/images/flags/#{top_pop_city_w_time_zone.country.country_code.downcase}.png' /> #{top_pop_city_w_time_zone.utf8_name}, "
            thing_to_push += "#{top_pop_city_w_time_zone.region.name}, " if (top_pop_city_w_time_zone.region)
            thing_to_push += "#{self.name} (#{city_i.time_zone.name})"
            country_city_tz.push(thing_to_push)
            #country_city_tz.push("#{top_pop_city_w_time_zone.utf8_name}, #{top_pop_city_w_time_zone.region.name}, #{self.name} (#{city_i.time_zone.name})")
          end          
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
