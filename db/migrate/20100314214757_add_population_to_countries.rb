class AddPopulationToCountries < ActiveRecord::Migration
  def self.up
    add_column(:countries, :population, :integer)
  end

  def self.down
    remove_column(:countries, :population)
  end
end
