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
      # RDC - obviously a cleaner way to do the below...
      #temp = params[:city][:name].split('/\s*[;+]+\s*/', -1);
      temp = params[:city][:name].split(';',-1);
      
      @myinputs = []
      temp.each do |i|
        my_city = i.split(",").first.strip.squeeze(' ');
        @myinputs.push(City.find(:first,:conditions =>"name = '#{my_city}'"))
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
