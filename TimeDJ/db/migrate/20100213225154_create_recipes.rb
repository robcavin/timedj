class CreateRecipes < ActiveRecord::Migration
  def self.up
    create_table :recipes do |t|
      t.string :title
      t.string :author
      t.text :description

      t.timestamps
    end
 
    create_table :cities do |t|
      t.string :name
    end

    create_table :countries do |t|
      t.string :name
    end

  end

  def self.down
    drop_table :recipes
    drop_table :cities
    drop_table :countries
  end
end

