class QueryController < ApplicationController

  auto_complete_for :city, :name
  auto_complete_for :city, :name_w_country

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
     temp = params[:city][:name].split(/\s*[;+]+\s*/, -1);

      @myinputs = []
      lookup_params = {}
      temp.each do |i|
        my_params = i.split(",",-1)
        lookup_params[:name] = my_params[0].strip.squeeze(' ')
        lookup_params[:country_id] = Country.find(:first, :conditions => {:name => my_params[1].gsub(/\(.*/,"").strip.squeeze(' ')}) if my_params[1];        
        @myinputs.push(City.find(:first,:conditions => lookup_params))
      end

      count = 0
      @myinputs.each do |city|
        if (!city.time_zone) 
          
          url = URI.parse("http://maps.google.com/maps/geo?q=#{ city.name.gsub(" ","+") },#{ city.country.name.gsub(" ","+") }&output=json&sensor=false&key=your_api_keyABQIAAAALnUIKv2c_PvAAo8iJhAfNBTZpUKzg8jOhOfiy-bfLwwLBS-ETBS3TEyv5VbbM1u2P8sqwqEuHG4X9w")
          response = Net::HTTP.get_response(url)
          jResponse = JSON.parse response.body
          url = URI.parse("http://ws.geonames.org/timezoneJSON?lat=#{jResponse['Placemark'][0]['Point']['coordinates'][1]}&lng=#{jResponse['Placemark'][0]['Point']['coordinates'][0]}")
          response = Net::HTTP.get_response(url)
          jResponse = JSON.parse response.body

          # Update the timezone in the db and update the active record object (else timezone still wont' be set below)
          @myinputs[count] = City.update(city, :time_zone => TimeZone.find(:first,:conditions => {:timezoneID => jResponse['timezoneId']}))
          
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
