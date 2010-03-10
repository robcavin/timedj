class AddIndexToCitiesCountryId < ActiveRecord::Migration
  def self.up
    execute 'ALTER TABLE cities ADD INDEX(country_id)'
  end

  def self.down
    execute 'DROP INDEX country_id ON cities'
  end
end
