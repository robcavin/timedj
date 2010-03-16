# loads the cities table with data from the maxamind cities data file
# this requires that you've loaded the countries data into the countries table
# and that you've loaded the regions data into the regions table

require 'rubygems'
require 'fastercsv'
require 'mysql'
require 'singleton'

# set to true for production server
PRODUCTION = false

# connect too the db               
@host     = 'localhost'  # :nodoc:
@username = 'timedj'    # :nodoc:
@password = 'Wg45GSDy4sr' # :nodoc:
if PRODUCTION
  @dbname = 'timedj_prod'
else
  @dbname   = 'timedj_dev'    # :nodoc:
end
@db = Mysql.real_connect(@host, @username, @password, @dbname)
@db.reconnect = true

# get a mapping of the country codes to the country ids
sql = "SELECT id, country_code FROM countries"
rows = @db.query(sql)
countries = {}
rows.each do |row|
  id = row[0]
  country_code = row[1]
  countries[country_code] = id
end

# get a mapping of the region_codes/country_codes to the region ids
sql = "SELECT id, region_code, country_code FROM regions"
rows = @db.query(sql)
regions = {}
rows.each do |row|
  id = row[0]
  region_code = row[1].upcase
  country_code = row[2].upcase
  regions[region_code + country_code] = id
end

# load the cities data file
csv_in = FasterCSV.open(ARGV[0], "r")

cities = []
csv_in.each do |line|
  country_code = line[0].upcase
  next if country_code.size > 2 # skip the title
  next if country_code == 'ZR' # the country of Zaire is now called Democratic Republic of the Congo, which is CD and already in the list
  ascii_name = line[1].gsub(',','-')
  full_name = line[2].gsub(',','-')
  region_code = line[3]
  if region_code == nil
    region_code = ""
  end
  population = line[4].to_i
  if population == 0
    population = "\\N"
  end
  lat = line[5].to_f
  long = line[6].to_f
  region_id = regions[region_code + country_code]
  if region_id == nil
    region_id = "\\N"
  end
  country_id = countries[country_code]
  if country_id == nil
    puts "Couldn't find this country!"
    exit
  end
  time_zone_id = "\\N"
  cities << [ascii_name, country_id, time_zone_id, region_id, full_name, population, lat, long]
end
cities.uniq! # probably not needed

line_num = 1
cities.each do |city|
  ascii_name = city[0]
  country_id = city[1]
  time_zone_id = city[2]
  region_id = city[3]
  full_name = city[4]
  poplulation = city[5]
  lat = city[6]
  long = city[7]
  puts "#{line_num},\"#{ascii_name}\",#{country_id},#{time_zone_id},#{region_id},\"#{full_name}\",#{poplulation},#{lat},#{long}"
  line_num += 1
end