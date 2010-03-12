class CleanCitiesIndex < ActiveRecord::Migration
  def self.up
    execute 'DROP INDEX name ON cities'
    execute 'ALTER TABLE cities ADD INDEX(name(10),country_id)' # this multi-index can be used for both name and name,country_id queries
  end

  def self.down
    execute 'DROP INDEX name_country_id ON cities'
    #execute 'ALTER TABLE cities ADD INDEX(name(10))' # this will just be slow so I'm not going to do it
  end
end

