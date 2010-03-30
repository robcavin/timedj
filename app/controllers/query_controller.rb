class QueryController < ApplicationController

  auto_complete_for :city, :name

  def index
     #@cities = City.find(:all)
     #@countries = Country.find(:all)   
  end

    # GET new_message_url
    def new
      # return an HTML form for describing a new message
    end

    # POST messages_url
    def create
      # create a new message
    end

    # GET message_url(:id => 1)
    def show
     require 'net/http'
     require 'json'
     require 'nokogiri'
     require 'date'
     temp = params[:city][:name].split(/\s*[;+]+\s*/, -1)
     temp.delete_if {|x| x == ""} # remove blank entries

      @myinputs = []
      lookup_params = {}
      temp.each do |i|
        my_params = i.split(",",-1)
        # check how many params we got:
        # if 3 then it's city, region, country
        # if 2 then it's city, country
        # if 1 then it's city
        ordering = nil   # ordering ensures that if they specify a city that is in other countries we pick the most populated one first
        lookup_params = {}
        case my_params.size
          when 3
            city = my_params[0]
            region = my_params[1]
            country = my_params[2]
          when 2
            city = my_params[0]
            region = nil
            country = my_params[1]
            ordering = "population DESC"
          when 1
            city = my_params[0]
            region = nil
            country = nil
            ordering = "population DESC"
          else
            # we need to do something if the params are bad
        end
        lookup_params[:name] = city.strip.squeeze(' ')
        lookup_params[:region_id] = Region.find(:first, :conditions => {:name => region.strip.squeeze(' ')}) if region        
        lookup_params[:country_id] = Country.find(:first, :conditions => {:name => country.gsub(/\(.*/,"").strip.squeeze(' ')}) if country
        city = City.find(:first, :conditions => lookup_params, :order => ordering)

        if !city && my_params.size == 2
          # Try one more time assuming only city and region
          city = my_params[0]
          region = my_params[1]
          country = nil
          ordering = "population DESC"
          lookup_params = {}
          lookup_params[:name] = city.strip.squeeze(' ')
          lookup_params[:region_id] = Region.find(:first, :conditions => {:name => region.strip.squeeze(' ')}) if region        
          lookup_params[:country_id] = Country.find(:first, :conditions => {:name => country.gsub(/\(.*/,"").strip.squeeze(' ')}) if country
          city = City.find(:first, :conditions => lookup_params, :order => ordering)          
        end

        # check if we were able to find this city
        # if the user didn't use autocomplete chances are we may have a problem processing the result
        if !city
          flash[:error] = "Sorry, we didn't understand the following city/country you entered:<br>#{i}"
          redirect_to :action => 'index' and return
        end
        @myinputs.push(city)
      end

      count = 0
      @myinputs.each do |city|
        if (!city.time_zone) 
          # first check if we aleady the lat/long in our db
          if city.lat and city.long
            lat = city.lat
            long = city.long
          else
            # get the lat and long from google
            url = URI.parse("http://maps.google.com/maps/geo?q=#{ city.name.gsub(" ","+") },#{ city.country.name.gsub(" ","+") }&output=json&sensor=false&key=your_api_keyABQIAAAALnUIKv2c_PvAAo8iJhAfNBTZpUKzg8jOhOfiy-bfLwwLBS-ETBS3TEyv5VbbM1u2P8sqwqEuHG4X9w")
            response = Net::HTTP.get_response(url)
            jResponse = JSON.parse response.body
            lat = jResponse['Placemark'][0]['Point']['coordinates'][1]
            long = jResponse['Placemark'][0]['Point']['coordinates'][0]
          end
          
          # get the time zone based on the lat and long via geonames.org webservice
          # first try their xml api since it seems to be more stable
          url = URI.parse("http://ws.geonames.org/timezone?lat=#{lat}&lng=#{long}")
          response = Net::HTTP.get_response(url)
          doc = Nokogiri::XML(response.body)
          timezoneId = doc.xpath("//geonames/timezone/timezoneId").children.to_s
          if timezoneId == ""
            # either there wasn't data for this lat/long or the xml api is down, try the JSON one
            url = URI.parse("http://ws.geonames.org/timezoneJSON?lat=#{lat}&lng=#{long}")
            response = Net::HTTP.get_response(url)
            jResponse = JSON.parse response.body        
            timezoneId = jResponse['timezoneId']
          end
          # check if we got any answer
          if !(timezoneId) or timezoneId == ""
            # render an error page  
          else
            # Update the timezone in the db and update the active record object (else timezone still wont' be set below)
            @myinputs[count] = City.update(city, :time_zone => TimeZone.find(:first,:conditions => {:timezoneID => timezoneId}))
          end
        end        
        count += 1
      end
      
      @tzdeltas = []
      my_date = `zdump #{@myinputs[0].time_zone.timezoneID}`.split(/\s+/)
      my_hr_min_sec = my_date[4].split(":")
      datetime0 = DateTime.new(my_date[5].to_i, Date::ABBR_MONTHNAMES.index(my_date[2]), my_date[3].to_i, my_hr_min_sec[0].to_i, my_hr_min_sec[1].to_i, my_hr_min_sec[2].to_i)
      
      @myinputs.each do |i|
        my_date = `zdump #{i.time_zone.timezoneID}`.split(/\s+/)
        my_hr_min_sec = my_date[4].split(":")
        my_datetime = DateTime.new(my_date[5].to_i, Date::ABBR_MONTHNAMES.index(my_date[2]), my_date[3].to_i, my_hr_min_sec[0].to_i, my_hr_min_sec[1].to_i, my_hr_min_sec[2].to_i)
        hours,minutes,seconds = Date.day_fraction_to_time(my_datetime - datetime0)
        @tzdeltas.push(hours) 
      end
      
      @min_good_hour = 8
      @max_good_hour = 17
      
      @tzdeltas[1..(@tzdeltas.length-1)].each do |i|
        min_hour = (8 - i)%24
        if (min_hour > 17) then min_hour -= 24 end
        max_hour = (min_hour + 9)
        @min_good_hour = [min_hour, @min_good_hour].max;
        @max_good_hour = [max_hour, @max_good_hour].min;
      end
      #if @max_good_hour < @min_good_hour then @max_good_hour = 17 end
        
      # find and return a specific message
    end

    # GET edit_message_url(:id => 1)
    def edit
      # return an HTML form for editing a specific message
    end

    # PUT message_url(:id => 1)
    def update
      # find and update a specific message
    end

    # DELETE message_url(:id => 1)
    def destroy
      # delete a specific message
  end
  
 end
