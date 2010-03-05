class Country < ActiveRecord::Base
  has_many :cities

  # Yes, this is a cross model method, but it's specific to the model.  Maybe could put this in helper?
  def full_descriptor

    country_city_tz = []  # Empty array for text fields.  Given input USA, should be populated with "San Francisco, USA (PDT)" and "New York, USA (EST)" if all goes well
    cities_w_time_zone = City.find(:all, :select => "distinct time_zone_id, name", :conditions => {:country_id => self})

    cities_w_time_zone.each do |city_i|
      country_city_tz.push("#{city_i.name},#{self.name} (#{city_i.time_zone.name})")
    end

    # If there are no citiez with time zones for the country, just return the country name
    country_city_tz = country.name if (!cities_w_time_zone)

    country_city_tz  # The if statement above doesn't actually return the string, so make double sure we do here
    
  end

end
