class QueryController < ApplicationController

  auto_complete_for :city, :name, {:order => 'population DESC'}

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
        case my_params.size
          when 3
            city = my_params[0]
            region = my_params[1]
            country = my_params[2]
          when 2
            city = my_params[0]
            country = my_params[1]
            ordering = "population DESC"
          when 1
            city = my_params[0]
            ordering = "population DESC"
          else
            # we need to do something if the params are bad
        end
        lookup_params[:name] = city.strip.squeeze(' ')
        lookup_params[:region_id] = Region.find(:first, :conditions => {:name => region.strip.squeeze(' ')}) if region        
        lookup_params[:country_id] = Country.find(:first, :conditions => {:name => country.gsub(/\(.*/,"").strip.squeeze(' ')}) if country
        city = City.find(:first, :conditions => lookup_params, :order => ordering)
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
      @myinputs.each do |i|
        @tzdeltas.push(i.time_zone.offset - @myinputs[0].time_zone.offset) if i.time_zone
      end
      
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
