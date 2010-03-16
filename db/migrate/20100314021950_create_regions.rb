class CreateRegions < ActiveRecord::Migration
  def self.up
    create_table :regions do |t|
      t.column :name, :string
      t.column :region_code, :string, :limit => 2 # we probably would only want to print this for US,CA
      t.column :country_code, :string, :limit => 2 # this is mainly needed to link this data do the maxmind list
    end
    execute 'ALTER TABLE regions ADD INDEX(name(10))'
  end

  def self.down
    drop_table :regions
  end
end
