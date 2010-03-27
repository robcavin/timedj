class ExpandCitiesData < ActiveRecord::Migration
  def self.up
    add_column(:cities, :region_id, :integer)
    add_column(:cities, :utf8_name, :string)
    add_column(:cities, :population, :integer)
    add_column(:cities, :lat, :float)
    add_column(:cities, :long, :float)
    execute 'ALTER TABLE cities MODIFY name VARCHAR(100)' # save some since and our data source has this limited at 100
    execute 'DROP INDEX name ON cities'
    execute 'ALTER TABLE cities ADD INDEX(name(10),country_id,region_id)' # this multi-index can be used for both name, name,country_id, and name,country_id,region_id queries
    execute 'ALTER TABLE cities ADD INDEX(utf8_name(10),country_id,region_id)' # this multi-index can be used for both utf8_name, utf8_name,country_id, utf8_name,country_id,region_id queries
    #execute 'ALTER TABLE cities MODIFY utf8_name varchar(255) CHARACTER SET utf8' # this should ensure the characters are stored correctly
  end

  def self.down
    remove_column(:cities, :utf8_name)
    remove_column(:cities, :region_id)
    remove_column(:cities, :population)
    remove_column(:cities, :lat)
    remove_column(:cities, :long)
    execute 'ALTER TABLE cities MODIFY name VARCHAR(255)'
    execute 'DROP INDEX name_country_id_region_id ON cities'
    #execute 'ALTER TABLE cities ADD INDEX(name(10))' # this will just be slow so I'm not going to do it
    execute 'DROP INDEX utf8_name_country_id_region_id ON cities'
  end
end
