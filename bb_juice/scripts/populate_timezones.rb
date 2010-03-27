# 

require 'rubygems'
require 'mysql'
require 'singleton'
require 'net/http'
require 'nokogiri'

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

# get all the cities with population and no time zone
sql = "SELECT id, name, lat, `long` FROM cities WHERE time_zone_id IS NULL AND lat IS NOT NULL AND `long` IS NOT NULL AND population > 0 ORDER BY population DESC LIMIT 5000"
rows = @db.query(sql)
cities = []
rows.each do |row|
  id = row[0]
  name = row[1]
  lat = row[2]
  long = row[3]
  cities << [id, name, lat, long]
end

# go through each city and query geonames
cities.each do |city|
  id = city[0]
  name = city[1]
  lat = city[2]
  long = city[3]
  url = URI.parse("http://ws.geonames.org/timezone?lat=#{lat}&lng=#{long}")
  response = Net::HTTP.get_response(url)
  doc = Nokogiri::XML(response.body)
  timezoneId = doc.xpath("//geonames/timezone/timezoneId").children.to_s
  
  if !(timezoneId) or timezoneId == ""
    puts "City: #{city.inspect} did not have a timezoneId"
    sleep(20 + rand(100))
    next
  end
  
  # find the corresponding timezone
  sql = "SELECT id FROM time_zones WHERE timezoneId = '#{timezoneId}' LIMIT 1"
  rows = @db.query(sql)
  tz_id = nil
  rows.each do |row|
    tz_id = row[0].to_i
  end
  
  # update the city with the tz id
  if tz_id and tz_id > 0
    sql = "UPDATE cities SET time_zone_id = #{tz_id} WHERE id = #{id}"
    @db.query(sql)
    puts "City: #{city.inspect}, timezoneId: #{timezoneId}, tz_id: #{tz_id}"
  else
    puts "City: #{city.inspect}, timezoneId: #{timezoneId} ERROR"
  end
  sleep(20 + rand(100))
end

