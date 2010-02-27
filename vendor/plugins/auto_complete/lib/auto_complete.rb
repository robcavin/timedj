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
        
        # RDC - In timedj's case, the AJAX javascript controller will pass in a GET request to this method
        #  with the URL looking like city[name]=<what is in the text box>
        # We could change the autocomplete macro to pass in a paramName to the Ajax_Autocompleter script and it  
        #  would then use that for the name rather than this bs
        #  I think in this case, the % means don't replace text here - defer it to later.  Verify
        # Another problem... We are going to need to define a parse method in the controller that 
        #  handles the 
        #text = params[object][method].split(%r{\s*(and|plus|[^,\w\d\s]\s*});
        text = params[object][method].split(" AND ");
        text2 = text ? text.last : params[object][method];
        find_options = { 
          #:conditions => [ "LOWER(#{method}) LIKE ?", '%' + text2.downcase + '%' ], 
          :conditions => [ "name LIKE ?", '%' + text2.downcase + '%' ],
          #:order => "#{method} ASC",
          :order => "name ASC",
          :limit => 10 }.merge!(options)
        
        @items = object.to_s.camelize.constantize.find(:all, find_options)
        
        #RDC - adding country names
#        @items_w_countries = [];
#        @items.each do |i| 
#          @items_w_countries.push(i.name + "," + i.country.name);
#        end

        render :inline => "<%= my_auto_complete_result @items, '#{method}' %>"
      end
    end
  end
  
end