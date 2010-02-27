class City < ActiveRecord::Base
  belongs_to :country
  def name_w_country
    self.name + "," + self.country.name
  end
end
