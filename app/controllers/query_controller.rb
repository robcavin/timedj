class QueryController < ApplicationController

  auto_complete_for :city, :name

  def index
     @cities = City.find(:all)
     @countries = Country.find(:all)   
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
      temp = params[:city][:name].split(" AND ");
      @myinputs = [];
      temp.each do |i|
        @myinputs.push(City.find(:first,:conditions =>"name = '#{i}'"))
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
