class CreateTimeZones < ActiveRecord::Migration
  def self.up
    create_table :time_zones do |t|
      t.column :name, :string
      t.column :offset, :integer
    end
    
    add_column(:cities, :time_zone_id, :integer)
  end

  def self.down
    drop_table :time_zones
    remove_column(:cities, :time_zone_id)
  end
end
