class ModifyTimeZones < ActiveRecord::Migration
  def self.up
    add_column(:time_zones, :timezoneID, :string, :limit => 64) # these names are short so no need to make 255 chars
    execute 'ALTER TABLE time_zones ADD INDEX(timezoneID(10))'
    execute 'ALTER TABLE time_zones MODIFY offset TINYINT' # offset can never be > 24 or < -24 so fine to keep it a tinyint
    execute 'ALTER TABLE time_zones MODIFY name VARCHAR(16)' # no need to have this be 255 chars since the max length is 7
  end

  def self.down
    remove_column(:time_zones, :timezoneID)
    execute 'DROP INDEX timezoneID ON time_zones'
    execute 'ALTER TABLE time_zones MODIFY offset INT'
    execute 'ALTER TABLE time_zones MODIFY name VARCHAR(255)'
  end
end
