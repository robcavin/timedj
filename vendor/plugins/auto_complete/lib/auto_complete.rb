module AutoComplete      
  
  def self.included(base)
    base.extend(ClassMethods)
  end

  #
  # Example:
  #
  #   # Controller
  #   class BlogController < ApplicationController
  #     auto_complete_for :post, :title
  #   end
  #
  #   # View
  #   <%= text_field_with_auto_complete :post, title %>
  #
  # By default, auto_complete_for limits the results to 10 entries,
  # and sorts by the given field.
  # 
  # auto_complete_for takes a third parameter, an options hash to
  # the find method used to search for the records:
  #
  #   auto_complete_for :post, :title, :limit => 15, :order => 'created_at DESC'
  #
  # For help on defining text input fields with autocompletion, 
  # see ActionView::Helpers::JavaScriptHelper.
  #
  # For more examples, see script.aculo.us:
  # * http://script.aculo.us/demos/ajax/autocompleter
  # * http://script.aculo.us/demos/ajax/autocompleter_customized
  module ClassMethods
    def auto_complete_for(object, method, options = {})
      define_method("auto_complete_for_#{object}_#{method}") do
        
        @items = []
        
        # Find countries
        find_options = {
          #:select => 'id, name',
          :conditions => [ "#{method} LIKE ?", params[object][method].downcase + '%' ], 
          :order => 'countries.population DESC',
          :limit => 10 }.merge!(options)
        
        @items.concat(Country.find(:all, find_options));

        # Find cities
        entries = params[object][method].strip.squeeze(" ").split(/\s*,\s*/, -1)
        if (entries.length ==1)
          find_options = {
          #:select => 'id, name, utf8_name, country_id, time_zone_id',
          :conditions => [ "#{method} LIKE ?", params[object][method].downcase + '%' ], 
          :order => 'cities.population DESC',
          :limit => 10 }.merge!(options)
          @items.concat(object.to_s.camelize.constantize.find(:all, find_options))
          
        else 
          find_options = { 
          #:select => 'id, name, utf8_name, country_id, time_zone_id',
          :conditions => [ "cities.#{method} = ? AND countries.name LIKE ?", entries[0].downcase, entries[1].downcase + '%'], 
          :order => 'cities.population DESC',
          :include => :country,
          :limit => 5 }.merge!(options)          
          @items.concat(object.to_s.camelize.constantize.find(:all, find_options))

          find_options = { 
          #:select => 'id, name, utf8_name, country_id, time_zone_id',
          :conditions => [ "cities.#{method} = ? AND regions.name LIKE ?", entries[0].downcase, entries[1].downcase + '%'], 
          :order => 'cities.population DESC',
          :include => :region,
          :limit => 5 }.merge!(options)          
          @items.concat(object.to_s.camelize.constantize.find(:all, find_options))

       end        
       
       if (@items.length == 0) 
         @items.push("Can't find a city or country that matches \"#{params[object][method]}\".  Please try again...")
       end
        #render :inline => "<%= auto_complete_result @items, '#{method}' %>"
        render :inline => "<%= auto_complete_result @items, 'full_descriptor' %>"
      end
    end
  end
  
end