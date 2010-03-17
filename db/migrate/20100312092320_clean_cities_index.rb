class CleanCitiesIndex < ActiveRecord::Migration
  def self.up
    # this index isn't used so we're basically just skipping this migration to save time
    #execute 'DROP INDEX name ON cities'
    #execute 'ALTER TABLE cities ADD INDEX(name(10),country_id,region_id)' # this multi-index can be used for both name, name,country_id, and name,country_id,region_id queries
  end

  def self.down
    #execute 'DROP INDEX name_country_id ON cities'
    #execute 'ALTER TABLE cities ADD INDEX(name(10))' # this will just be slow so I'm not going to do it
  end
end

