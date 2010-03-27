# runs through the maxmind regions file and builds a mysql .dat file

require 'rubygems'
require 'fastercsv'

# load the countries list
csv_in = FasterCSV.open(ARGV[0], "r")

line_num = 1
csv_in.each do |line|
  country_code = line[0]
  next if country_code.size > 2 # skip the title
  region_code = line[1]
  region_name = line[2].gsub(',','-')
  puts "#{line_num},\"#{region_name}\",\"#{region_code}\",\"#{country_code}\""
  line_num += 1
end
