
class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.string :name
    end

    create_table :countries do |t|
      t.string :name
    end

  end

  def self.down
    drop_table :cities
    drop_table :countries
  end
end
