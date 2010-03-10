class AddIndexesToCitiesCountries < ActiveRecord::Migration
  def self.up
    execute 'ALTER TABLE cities ADD INDEX(name(10))'
    execute 'ALTER TABLE countries ADD INDEX(name(10))'
  end

  def self.down
    execute 'DROP INDEX name ON cities'
    execute 'DROP INDEX name ON countries'
  end
end
