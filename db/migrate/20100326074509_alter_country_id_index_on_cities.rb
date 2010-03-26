class AlterCountryIdIndexOnCities < ActiveRecord::Migration
  def self.up
    execute 'DROP INDEX country_id ON cities'
    execute 'ALTER TABLE cities ADD INDEX(country_id,time_zone_id)' # this multi-index can be used for both country_id, and country_id,time_zone_id queries
  end

  def self.down
    execute 'DROP INDEX country_id_time_zone_id ON cities'
    #execute 'ALTER TABLE cities ADD INDEX(country_id)'
  end
end
