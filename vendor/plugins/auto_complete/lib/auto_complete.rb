module AutoComplete      
      Abbrev_to_region = {
'al' => 'alabama',
'ak' => 'alaska',
'az' => 'arizona',
'ar' => 'arkansas',
'ca' => 'california',
'co' => 'colorado',
'ct' => 'connecticut',
'dc' => 'district of columbia',
'de' => 'delaware',
'fl' => 'florida',
'ga' => 'georgia',
'hi' => 'hawaii',
'id' => 'idaho',
'il' => 'illinois',
'in' => 'indiana',
'ia' => 'iowa',
'ks' => 'kansas',
'ky' => 'kentucky',
'la' => 'louisiana',
'me' => 'maine',
'md' => 'maryland',
'ma' => 'massachusetts',
'mi' => 'michigan',
'mn' => 'minnesota',
'ms' => 'mississippi',
'mo' => 'missouri',
'mt' => 'montana',
'ne' => 'nebraska',
'nv' => 'nevada',
'nh' => 'new hampshire',
'nj' => 'new jersey',
'nm' => 'new mexico',
'ny' => 'new york',
'nc' => 'north carolina',
'nd' => 'north dakota',
'oh' => 'ohio',
'ok' => 'oklahoma',
'or' => 'oregon',
'pa' => 'pennsylvania',
'ri' => 'rhode island',
'sc' => 'south carolina',
'sd' => 'south dakota',
'tn' => 'tennessee',
'tx' => 'texas',
'ut' => 'utah',
'vt' => 'vermont',
'va' => 'virginia',
'wa' => 'washington',
'wv' => 'west virginia',
'wi' => 'wisconsin',
'wy' => 'wyoming' }

    Abbrev_to_country = {
'us'  => 'united states',
'usa'  => 'united states',
'uk'  => 'united kingdom',
'uae' => 'united arab emirates',
'au'  => 'australia'
}

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
                  
        # Find cities
        entries = params[object][method].strip.squeeze(" ").split(/\s*,\s*/, -1)
        if (entries.length ==1)
          # Find countries
          country = Abbrev_to_country[ params[object][method].downcase ] || params[object][method].downcase
          find_options = {
            #:select => 'id, name',
            :conditions => [ "#{method} LIKE ?", country + '%' ], 
            :order => 'countries.population DESC',
           :limit => 10 }.merge!(options)
        
          @items.concat(Country.find(:all, find_options));
          
          find_options = {
          #:select => 'id, name, utf8_name, country_id, time_zone_id',
          :conditions => [ "#{method} LIKE ?", params[object][method].downcase + '%' ], 
          :order => 'cities.population DESC',
          :limit => 10 }.merge!(options)
          @items.concat(object.to_s.camelize.constantize.find(:all, find_options))

        else 
        
          country = Abbrev_to_country[entries[1].downcase ] || entries[1].downcase
          find_options = { 
          #:select => 'id, name, utf8_name, country_id, time_zone_id',
          :conditions => [ "cities.#{method} = ? AND countries.name LIKE ?", entries[0].downcase, country + '%'], 
          :order => 'cities.population DESC',
          :include => :country,
          :limit => 5 }.merge!(options)          
          @items.concat(object.to_s.camelize.constantize.find(:all, find_options))

          region = Abbrev_to_region[entries[1].downcase ] || entries[1].downcase
          find_options = { 
          #:select => 'id, name, utf8_name, country_id, time_zone_id',
          :conditions => [ "cities.#{method} = ? AND regions.name LIKE ?", entries[0].downcase, region + '%'], 
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