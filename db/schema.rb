# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100326074509) do

  create_table "cities", :force => true do |t|
    t.string  "name",         :limit => 100
    t.integer "country_id"
    t.integer "time_zone_id"
    t.integer "region_id"
    t.string  "utf8_name"
    t.integer "population"
    t.float   "lat"
    t.float   "long"
  end

  add_index "cities", ["country_id", "time_zone_id"], :name => "country_id"
  add_index "cities", ["name", "country_id", "region_id"], :name => "name"
  add_index "cities", ["utf8_name", "country_id", "region_id"], :name => "utf8_name"

  create_table "countries", :force => true do |t|
    t.string  "name"
    t.string  "country_code", :limit => 2
    t.integer "population"
  end

  add_index "countries", ["name"], :name => "name"

  create_table "regions", :force => true do |t|
    t.string "name"
    t.string "region_code",  :limit => 2
    t.string "country_code", :limit => 2
  end

  add_index "regions", ["name"], :name => "name"

  create_table "time_zones", :force => true do |t|
    t.string  "name",       :limit => 16
    t.integer "offset",     :limit => 1
    t.string  "timezoneID", :limit => 64
  end

  add_index "time_zones", ["timezoneID"], :name => "timezoneID"

end
